# Pipeline Documentation

AR Sight implements a **4-phase asynchronous pipeline** that manages the complete lifecycle of scene diagnosis.

## Pipeline Overview

```
PHASE 1: CAPTURE          PHASE 2: UPLOAD         PHASE 3: DIAGNOSIS      PHASE 4: RESULTS
─────────────────────────────────────────────────────────────────────────────────────────
Camera → Memory           Network                 Backend Processing      Display Results
⏱️ ~10 seconds            Variable                Variable                600ms transition
(Reference: 10 frames)    (2-10 seconds)          (30s - minutes)         (Instant)

┌──────────┐    Frames    ┌───────────┐  batch   ┌──────────┐  Status  ┌──────────┐
│ CAPTURE  │─────────────▶│  UPLOAD   │─────────▶│ POLLING  │─────────▶│ RESULTS  │
└──────────┘   Buffered   └───────────┘ stored   └──────────┘ polling  └──────────┘
```

---

## Phase 1: Scene Capture (CameraService)

### Responsibilities

- Initialize device camera
- Capture frames at precise 1 Hz intervals
- Buffer frames in memory
- Track progress and countdown
- Handle camera errors gracefully

### Implementation Details

```dart
Future<void> captureFrames({
  required CameraController controller,
  required int frameCount,
  required void Function(Uint8List) onFrameCaptured,
  required void Function(int) onProgressUpdate,
}) async {
  final startTime = DateTime.now();
  final interval = Duration(seconds: 1);
  
  for (int i = 0; i < frameCount; i++) {
    // Calculate target capture time
    final targetTime = startTime.add(interval * i);
    final now = DateTime.now();
    
    // Wait until target time
    if (now.isBefore(targetTime)) {
      await Future.delayed(targetTime.difference(now));
    }
    
    // Retry if camera is busy
    while (controller.value.isTakingPicture) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    
    // Capture frame
    final xFile = await controller.takePicture();
    final bytes = await xFile.readAsBytes();
    
    onFrameCaptured(bytes);
    onProgressUpdate(i + 1);
  }
}
```

### Key Features

- **Temporal Precision**: `DateTime` comparison ensures consistent 1 Hz sampling
- **Adaptive Retry**: Camera contention handled with 50ms backoff (doesn't consume frame quota)
- **Async/Await**: Non-blocking I/O preserves UI responsiveness
- **Progress Callbacks**: Real-time updates without state mutation

### Error Handling

- Frame capture errors are caught and logged
- Loop terminates gracefully if error occurs
- Exception is rethrown for upstream handling in store

---

## Phase 2: Batch Upload (SceneEvalStore)

### Workflow

1. Set `diagnosisStatus = 'uploading'` and `isUploading = true`
2. Invoke `uploadDatasource.uploadFrames(frames)`
3. Extract `batch_id` from response
4. Store upload metadata in `lastUploadResponse`
5. Transition to `diagnosisStatus = 'uploaded'`

### Implementation

```dart
@action
Future<void> _uploadAndDiagnose(List<Uint8List> frames) async {
  try {
    // Phase 2: Upload
    isUploading = true;
    runInAction(() => diagnosisStatus = 'uploading');
    
    final response = await uploadDatasource.uploadFrames(frames);
    final batchId = response['batch_id'] as String;
    
    runInAction(() {
      this.batchId = batchId;
      lastUploadResponse = response;
      diagnosisStatus = 'uploaded';
      isUploading = false;
    });
    
    // Visual feedback delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Phase 3-4: Start diagnosis polling
    await _pollDiagnosis(batchId);
    
  } catch (e) {
    runInAction(() {
      uploadError = e.toString();
      diagnosisStatus = 'upload_failed';
      isUploading = false;
    });
    rethrow;
  }
}
```

### Error States

- **Network Error**: `diagnosisStatus = 'upload_failed'`, `uploadError` populated
- **Invalid Response**: Exception thrown with error details
- **Timeout**: Dio timeout triggers network error handling

---

## Phase 3: Asynchronous Diagnosis (Status Polling)

### Polling Loop

```dart
Future<void> _pollDiagnosis(String batchId) async {
  isDiagnosing = true;
  runInAction(() => diagnosisStatus = 'processing');
  
  try {
    while (true) {
      // Wait for polling interval (configurable per backend)
      await Future.delayed(
        Duration(seconds: backendSession.pollingIntervalSeconds)
      );
      
      // Check diagnosis status
      final response = await datasource.getDiagnosisStatus(batchId);
      final status = response['status']?.toString() ?? 'unknown';
      
      runInAction(() => diagnosisStatus = status);
      
      // Terminal states
      if (status == 'completed') break;
      if (status == 'failed') {
        throw Exception(response['error'] ?? 'Unknown error');
      }
    }
    
    // Phase 4: Retrieve results
    await _retrieveResults(batchId);
    
  } catch (e) {
    runInAction(() {
      diagnosisError = e.toString();
      diagnosisStatus = 'failed';
    });
    rethrow;
  } finally {
    isDiagnosing = false;
  }
}
```

### Key Features

- **Configurable Polling Interval**: Per-backend adjustment (Legion: 1s, Nano: 5s)
- **Safe Null Handling**: Default 'unknown' status prevents null exceptions
- **State Tracking**: Each status change observable for UI updates
- **Early Termination**: Loop breaks on success or failure

### Status Progression

```
'processing'
    ├─ Polling...
    ├─ Polling...
    └─ Status: 'completed' ──▶ Break loop
    └─ Status: 'failed' ─────▶ Throw exception
```

---

## Phase 4: Result Retrieval and Presentation

### Implementation

```dart
Future<void> _retrieveResults(String batchId) async {
  try {
    // Visual feedback delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Retrieve full diagnosis result
    final response = await datasource.getDiagnosisResult(batchId);
    
    // Transform API response to domain model
    final diagnosis = SceneDiagnosisAdapter.fromBackend(response);
    
    runInAction(() {
      lastResult = diagnosis;
      diagnosisStatus = 'completed';
    });
    
  } catch (e) {
    runInAction(() {
      diagnosisError = e.toString();
      diagnosisStatus = 'failed';
    });
    rethrow;
  }
}
```

### Result Model

The `SceneDiagnosis` domain model contains:

- **Diagnostic Data**: status, risk level, dominant label, explanation
- **Recommendations**: Actionable recommendations grouped by category
- **Performance Metrics**: PDI/SLM timing, accuracy metrics
- **Backend Metadata**: Environment, model, device, quantization info
- **Frame Details**: Per-frame metrics and diagnostics

### Transformation

`SceneDiagnosisAdapter.fromBackend()` handles:

- Type conversions (JSON string → strongly-typed fields)
- Nested structure flattening
- Validation of required fields
- Default values for optional fields

---

## State Machine

Complete diagnosis lifecycle as state transitions:

```
┌─────────┐
│  IDLE   │
└────┬────┘
     │ startCapture()
     ▼
┌──────────┐
│ CAPTURING│ (Phase 1: Camera)
└────┬─────┘
     │ frames buffered
     ▼
┌──────────┐
│ UPLOADING│ (Phase 2: Network)
└────┬─────┘
     │ batch_id received
     ▼
┌──────────┐
│ UPLOADED │ 
└────┬─────┘
     │ startDiagnosis()
     ▼
┌──────────────┐
│ PROCESSING   │ (Phase 3-4: Polling)
│ (polling...) │
└────┬─────────┘
     │ status: 'completed'
     ▼
┌──────────┐
│COMPLETED │
└──────────┘

Error at any state:
     │
     ▼
┌──────────┐
│ FAILED   │ (or 'upload_failed')
└──────────┘
```

---

## Observable State Variables

| Variable | Type | Purpose |
|----------|------|---------|
| `diagnosisStatus` | String | State machine value |
| `isCapturing` | bool | Phase 1 active |
| `isUploading` | bool | Phase 2 active |
| `isDiagnosing` | bool | Phase 3-4 active |
| `capturedFrames` | int | Frame counter |
| `progress` | double | Normalized 0.0-1.0 |
| `secondsRemaining` | int | Countdown |
| `lastCapturedFrames` | List<Uint8List> | Buffered frames |
| `batchId` | String | Backend batch ID |
| `lastResult` | SceneDiagnosis? | Complete diagnosis |
| `uploadError` | String | Phase 2 error message |
| `diagnosisError` | String | Phase 3-4 error message |

---

## Timing Characteristics

### Reference Timeline

```
Phase 1 (Capture):    ~10 seconds (10 frames @ 1 Hz)
Phase 2 (Upload):     2-10 seconds (network dependent)
Transition Delay:     1500 milliseconds (visual feedback)
Phase 3 (Polling):    Variable (30 seconds - minutes)
  └─ Polling Interval: 1-5 seconds (backend configurable)
Phase 4 (Results):    600 milliseconds (visual feedback)

Total: 45 seconds to 15+ minutes (mostly backend processing)
```

### Performance Optimization

- **Non-blocking**: All phases use async/await
- **UI Responsiveness**: 60 FPS maintained during capture
- **Network Efficiency**: Batch upload minimizes HTTP overhead
- **Memory Management**: Frame buffers released after diagnosis completes

---

## Error Handling Per Phase

| Phase | Error Scenario | Handling | State |
|-------|---|---|---|
| 1 | Frame capture fails | Log, terminate loop | `isCapturing = false` |
| 2 | Network error | Retry, capture error | `upload_failed` |
| 2 | Invalid response | Parse error | `upload_failed` |
| 3 | Polling timeout | Retry up to limit | `processing` → `failed` |
| 3 | Backend error | Throw exception | `failed` |
| 4 | Result parsing | Transform error | `failed` |

### Resource Cleanup

```dart
finally {
  _timer?.cancel();           // Release countdown timer
  isCapturing = false;        // Reset capture state
  isUploading = false;        // Reset upload state
  isDiagnosing = false;       // Reset diagnosis state
}
```

---

## Integration with UI

### Observer Pattern

```dart
Observer(
  builder: (_) {
    switch (store.diagnosisStatus) {
      case 'capturing':
        return CaptureState(progress: store.progress);
      case 'uploading':
      case 'uploaded':
        return UploadState();
      case 'processing':
        return ProcessingState(
          status: store.diagnosisStatus,
        );
      case 'completed':
        return ResultPage(diagnosis: store.lastResult!);
      case 'failed':
      case 'upload_failed':
        return ErrorState(message: store.diagnosisError);
      default:
        return HomePage();
    }
  },
)
```

### State Transitions in UI

- Progress bar updates on `progress` observable change
- Status messages reflect `diagnosisStatus` state
- Error messages displayed from `uploadError` / `diagnosisError`
- Results rendered when `lastResult` is populated

---

## Testing the Pipeline

### Fake Backend

For development without a real backend:

```dart
const bool useFakeBackend = true;

if (useFakeBackend) {
  return SceneEvalStore(
    FakeSceneDatasource(),       // Instant 'completed' status
    FakeSceneUploadDatasource(), // Immediate batch_id response
    backendSession,
  );
}
```

### Unit Testing

```dart
test('Pipeline transitions from capturing to completed', () async {
  final store = SceneEvalStore(
    MockSceneDatasource(),
    MockSceneUploadDatasource(),
    mockSession,
  );
  
  expect(store.diagnosisStatus, 'idle');
  
  // Mock camera and trigger capture
  await store.startCapture(mockController);
  
  expect(store.diagnosisStatus, 'completed');
  expect(store.lastResult, isNotNull);
});
```

---

## Summary

The 4-phase pipeline provides:

1. **Clear Phase Semantics**: Each phase has well-defined responsibilities
2. **Observable State**: MobX observables enable reactive UI updates
3. **Error Resilience**: Comprehensive error handling at each phase
4. **Performance Optimization**: Async/await, batch operations, configurable intervals
5. **Testability**: Dependency injection enables fake backends for testing

The pipeline handles the complete lifecycle from camera capture through backend diagnosis to result presentation.
