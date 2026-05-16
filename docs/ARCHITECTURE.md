# Architecture Guide

AR Sight implements a **clean architecture** pattern organized into distinct logical layers, each with clearly defined responsibilities.

## Layered Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│         PRESENTATION LAYER                          │
│  (UI Pages, State Management, User Interaction)     │
├─────────────────────────────────────────────────────┤
│      EXTERNAL SERVICES LAYER                        │
│  (Backend Communication, Camera Control)            │
├─────────────────────────────────────────────────────┤
│        DATA MODELS LAYER                            │
│  (Domain Models, Data Transfer Objects)             │
├─────────────────────────────────────────────────────┤
│      INFRASTRUCTURE LAYER                           │
│  (Configuration, Session Management)                │
└─────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### 1. Presentation Layer (`lib/src/presenter/`)

- **Pages**: UI screens and route management
- **Stores**: MobX observables for reactive state management
- **Components**: Reusable UI widgets

**Design Principles:**
- Pure presentation logic (no business logic)
- Observes store state through `Observer` widgets
- Dispatches actions through store methods
- Platform-agnostic (same code across Android/iOS/Web/Linux)

#### 2. External Services Layer (`lib/src/external/`)

- **Datasources**: Remote API communication interfaces
- **Services**: Device-level services (camera, sensors)
- **Adapters**: Backend response transformation
- **Config**: Session management and backend configuration

**Design Principles:**
- Abstracts backend complexity from domain models
- Implements data transformation (API → domain models)
- Handles network errors and retries
- Manages device-level resources (camera, file I/O)

#### 3. Data Models Layer (`lib/src/models/`)

- **Domain Models**: Immutable data classes representing core business concepts
- **Data Transfer Objects**: Serialization-friendly structures

**Design Principles:**
- Type-safe representation of business entities
- Immutability ensures predictable state
- Clear separation between API schemas and domain models
- JSON serialization via `json_serializable`

#### 4. Infrastructure Layer (`lib/src/setup/`)

- **Dependency Injection**: Factory methods for object graph construction
- **Configuration**: Backend resolution and session management

**Design Principles:**
- Centralizes setup logic
- Enables easy testing through mock substitution
- Manages resource lifecycle

---

## Directory Structure

```
lib/
├── src/
│   ├── external/
│   │   ├── adapters/           # API response transformers
│   │   ├── config/
│   │   │   ├── api_config.dart         # Backend endpoint definitions
│   │   │   ├── backend_candidate.dart  # Backend metadata
│   │   │   ├── backend_resolver.dart   # Runtime backend selection
│   │   │   ├── backend_session.dart    # Session state
│   │   │   └── README.md               # Configuration guide
│   │   ├── datasources/
│   │   │   ├── scene_datasource.dart   # Diagnosis interface
│   │   │   └── scene_upload_datasource.dart  # Upload interface
│   │   └── services/
│   │       └── camera_service.dart     # Frame capture service
│   ├── models/
│   │   ├── frame_data.dart             # Per-frame diagnostic data
│   │   └── scene_diagnosis.dart        # Complete diagnosis result
│   ├── presenter/
│   │   ├── pages/
│   │   │   ├── home/
│   │   │   ├── scene_eval/
│   │   │   ├── frames_preview/
│   │   │   └── result/
│   │   └── stores/
│   │       └── scene_eval_store.dart   # Main MobX store
│   └── setup/
│       └── store_factory.dart          # Dependency injection
├── main.dart                            # Entry point
└── [platform-specific: android/, ios/, linux/, web/]
```

---

## State Management with MobX

AR Sight uses **MobX** for reactive state management, providing automatic dependency tracking and UI updates.

### Observable State (`SceneEvalStore`)

```dart
@observable
String diagnosisStatus = 'idle';

@observable
List<Uint8List> lastCapturedFrames = [];

@observable
SceneDiagnosis? lastResult;
```

### Actions

```dart
@action
Future<void> startCapture(CameraController controller) async {
  // Orchestrates complete diagnosis pipeline
}

@action
void _updateProgress(int captured, int total) {
  capturedFrames = captured;
  progress = captured / total;
}
```

### UI Binding

```dart
Observer(
  builder: (_) => Text(diagnosisStatus),  // Auto-updates on change
)
```

---

## Dependency Injection Pattern

### Factory Function

The `buildStore()` function encapsulates object graph construction:

```dart
Future<SceneEvalStore> buildStore() async {
  // Create shared services
  final backendSession = BackendSession();
  final resolver = BackendResolver(Dio());
  
  // Resolve active backend
  backendSession.active = await resolver.resolve();
  
  // Create datasources with shared session
  final dio = Dio();
  final sceneDatasource = SceneDatasourceImpl(dio, backendSession);
  final uploadDatasource = SceneUploadDatasourceImpl(dio, backendSession);
  
  // Compose store with dependencies
  return SceneEvalStore(
    sceneDatasource,
    uploadDatasource,
    backendSession,
  );
}
```

### Benefits

- **Testability**: Easy to swap real implementations with mocks
- **Decoupling**: Store doesn't know about concrete datasources
- **Lifecycle Management**: Shared resources (Dio, sessions) managed centrally
- **Flexibility**: Support for multiple configurations (real/fake backends)

---

## Backend Resolution Strategy

### Multi-Candidate Failover

The `BackendResolver` implements health checks to find an available backend:

1. Iterate through `ApiConfig.candidates` list
2. Send health check request to each candidate
3. Return first responsive backend
4. Fall back to secondary backends if primary fails

### Backend Candidate Configuration

```dart
BackendCandidate(
  name: 'Legion',
  baseUrl: 'http://192.168.155.163:8000',
  healthCheckTimeout: Duration(seconds: 5),
  diagnosisTimeout: Duration(seconds: 30),
  pollingIntervalSeconds: 1,
)
```

### Session State Management

`BackendSession` maintains the active backend and exposes configuration:

```dart
class BackendSession {
  BackendCandidate? active;
  
  String get baseUrl => active!.baseUrl;
  int get pollingIntervalSeconds => active!.pollingIntervalSeconds;
}
```

---

## Error Handling Strategy

### Layered Error Propagation

1. **Service Layer**: Catches network errors, transforms to domain exceptions
2. **Store Layer**: Captures exceptions, updates observable error states
3. **UI Layer**: Observes error states, displays user-friendly messages

### Error Recovery

- **Network Errors**: Automatic retry with configurable intervals
- **Upload Failures**: Trigger `diagnosisStatus = 'upload_failed'`
- **Processing Errors**: Graceful degradation with error messages
- **Resource Cleanup**: `finally` blocks ensure timers and listeners are cancelled

---

## Performance Optimizations

### Frame Capture

- **Temporal Precision**: Frames captured at 1 Hz sampling rate
- **Adaptive Retry**: Camera contention handled with backoff logic
- **Memory Efficiency**: Frames stored as `Uint8List` (typed data)

### Network

- **Batch Upload**: Multiple frames in single HTTP request
- **Async I/O**: Non-blocking network operations
- **Configurable Polling**: Per-backend polling interval adjustment

### Memory Management

- **Frame Disposal**: Large image buffers garbage collected after diagnosis
- **Timer Cleanup**: Countdown timers properly cancelled
- **Observable Batching**: MobX reduces re-renders from state changes

---

## Cross-Platform Considerations

### Unified Codebase

- **Camera API**: Abstracted through `camera` plugin
- **File Access**: Unified through `path_provider` plugin
- **UI Rendering**: Same Flutter code across platforms

### Platform-Specific Adjustments

- **Android**: CameraX integration, runtime permissions
- **iOS**: AVFoundation camera, Info.plist permissions
- **Linux**: GTK integration, desktop UI adaptation
- **Web**: WebRTC camera access, CORS handling

---

## Design Philosophy Summary

1. **Separation of Concerns**: Clear layering enables independent evolution
2. **Reactive Programming**: MobX reduces boilerplate, automatic UI updates
3. **Type Safety**: Immutable models, compile-time correctness
4. **Error Resilience**: Comprehensive error handling, graceful degradation
5. **Testability**: Dependency injection enables mock substitution
6. **Performance**: Strategic async/await usage, memory optimization

AR Sight demonstrates production-grade architecture suitable for scalable mobile applications with complex asynchronous workflows.
