# Backend Integration Guide

Learn how to connect AR Sight to your diagnosis backend or integrate with an existing service.

## Quick Start

### 1. Define Backend Candidates

Create `lib/src/external/config/api_config.dart`:

```dart
import 'backend_candidate.dart';

class ApiConfig {
  static const List<BackendCandidate> candidates = [
    BackendCandidate(
      name: 'My Backend',
      baseUrl: 'http://api.example.com:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),
  ];
}
```

### 2. Implement Datasources

Both `SceneDatasourceImpl` and `SceneUploadDatasourceImpl` already exist and work with any HTTP-compatible backend.

### 3. Configure in Store Factory

The `store_factory.dart` automatically resolves backends and creates datasources.

---

## Backend Requirements

Your diagnosis backend must implement these HTTP endpoints:

### Upload Endpoint

**Request:**
```http
POST /api/upload
Content-Type: multipart/form-data

[binary frames]
```

**Response:**
```json
{
  "batch_id": "abc-123-def",
  "status": "success",
  "timestamp": "2024-05-16T10:30:00Z"
}
```

### Status Check Endpoint

**Request:**
```http
GET /api/diagnosis/{batch_id}/status
```

**Response:**
```json
{
  "batch_id": "abc-123-def",
  "status": "processing",
  "progress": 0.45,
  "estimated_seconds_remaining": 15
}
```

Status values: `uploaded`, `processing`, `completed`, `failed`, `upload_failed`

### Result Endpoint

**Request:**
```http
GET /api/diagnosis/{batch_id}/result
```

**Response:**
```json
{
  "batch_id": "abc-123-def",
  "status": "pass",
  "risk_level": "low",
  "dominant_label": "scene_quality_good",
  "explanation": "The scene meets AR requirements",
  "recommendations": [
    "Move closer to the object for better detail"
  ],
  "frames": [
    {
      "index": 0,
      "label": "good",
      "confidence": 0.95
    }
  ],
  "pdi_total_ms": 500,
  "pdi_per_image_ms": 50,
  "slm_total_s": 2.5,
  "total_s": 3.2,
  "target_met": true,
  "accuracy": 0.92,
  "environment": "production",
  "model": "vision-v2.1",
  "device": "GPU",
  "quantization": "FP32",
  "batch_size": 10
}
```

---

## Frame Upload Format

AR Sight sends frames as multipart form data:

```
POST /api/upload

Content-Type: multipart/form-data; boundary=----FormBoundary123

------FormBoundary123
Content-Disposition: form-data; name="frame"; filename="frame_0.jpg"
Content-Type: image/jpeg

[JPEG binary data for frame 0]
------FormBoundary123
Content-Disposition: form-data; name="frame"; filename="frame_1.jpg"
Content-Type: image/jpeg

[JPEG binary data for frame 1]
------FormBoundary123--
```

**Characteristics:**
- Multiple frames in single request
- JPEG format (high-resolution, ~100-200 KB per frame)
- Filename pattern: `frame_{index}.jpg`
- Total payload: 10 frames ≈ 1-2 MB

---

## Multi-Backend Fallover

AR Sight automatically tries backends in list order:

```dart
candidates = [
  BackendCandidate(name: 'Legion', baseUrl: 'http://legion.local:8000', ...),
  BackendCandidate(name: 'Jetson Orin', baseUrl: 'http://orin.local:8000', ...),
  BackendCandidate(name: 'Jetson Nano', baseUrl: 'http://nano.local:8000', ...),
]
```

**Resolution Process:**
1. Send health check to Legion
2. If success: use Legion
3. If timeout/error: try Jetson Orin
4. If timeout/error: try Jetson Nano
5. If all fail: throw error

---

## Custom Datasource Implementation

If your backend has a non-standard API, implement custom datasources:

### Upload Datasource

```dart
abstract class SceneUploadDatasource {
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames);
}

class CustomUploadDatasource implements SceneUploadDatasource {
  @override
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames) async {
    // Your custom upload logic here
    final response = await _sendToYourBackend(frames);
    return response;
  }
}
```

### Diagnosis Datasource

```dart
abstract class SceneDatasource {
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId);
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId);
}

class CustomSceneDatasource implements SceneDatasource {
  @override
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId) async {
    // Your custom status check
    return {'status': 'processing'};
  }
  
  @override
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId) async {
    // Your custom result fetching
    return {...diagnosis data...};
  }
}
```

### Update Store Factory

```dart
Future<SceneEvalStore> buildStore() async {
  final backendSession = BackendSession();
  backendSession.active = await resolver.resolve();
  
  final dio = Dio();
  
  // Use custom datasources
  final sceneDatasource = CustomSceneDatasource(dio, backendSession);
  final uploadDatasource = CustomUploadDatasource(dio, backendSession);
  
  return SceneEvalStore(
    sceneDatasource,
    uploadDatasource,
    backendSession,
  );
}
```

---

## Timeout Configuration Per Backend

Each backend can have different timeout values:

```dart
BackendCandidate(
  name: 'Fast Backend',
  baseUrl: 'http://fast.local:8000',
  healthCheckTimeout: Duration(seconds: 2),      // Quick health checks
  diagnosisTimeout: Duration(seconds: 30),       // Fast diagnosis
  pollingIntervalSeconds: 1,                     // Frequent polling
),

BackendCandidate(
  name: 'Slow Backend',
  baseUrl: 'http://slow.local:8000',
  healthCheckTimeout: Duration(seconds: 10),     // Longer health checks
  diagnosisTimeout: Duration(seconds: 120),      // Slow diagnosis
  pollingIntervalSeconds: 5,                     // Less frequent polling
),
```

---

## Error Handling

### Upload Failures

If upload fails:
- `diagnosisStatus = 'upload_failed'`
- `uploadError` contains error message
- User can retry from home screen

### Processing Errors

If backend reports error:
- `diagnosisStatus = 'failed'`
- `diagnosisError` contains error message
- Backend error returned in result response

### Network Timeouts

If backend unresponsive:
- Automatic fallover to next candidate
- If all candidates fail: `diagnosisStatus = 'failed'`

---

## Performance Optimization

### Batch Size

Default: 10 frames ≈ 1-2 MB payload

Optimization strategies:
- **Compress JPEG**: Reduce quality slightly
- **Downscale frames**: Reduce resolution (if model tolerates)
- **Stream incrementally**: Upload frames as captured instead of batch

### Polling Interval

Default: 1-5 seconds depending on backend

Trade-offs:
- **Faster polling**: More responsive, higher backend load
- **Slower polling**: Less responsive, lower server load

### Parallel Requests

AR Sight uses sequential polling. For faster results, implement backend-side queueing.

---

## Testing with Fake Backend

For development without a real backend:

```dart
class FakeSceneUploadDatasource implements SceneUploadDatasource {
  @override
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'batch_id': 'fake-batch-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'success',
    };
  }
}

class FakeSceneDatasource implements SceneDatasource {
  @override
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId) async {
    // Simulate polling progression
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'completed'};
  }
  
  @override
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId) async {
    return {
      'status': 'pass',
      'risk_level': 'low',
      'accuracy': 0.95,
      // ... full result
    };
  }
}
```

Enable in `store_factory.dart`:

```dart
const bool useFakeBackend = true;

if (useFakeBackend) {
  return SceneEvalStore(
    FakeSceneDatasource(),
    FakeSceneUploadDatasource(),
    backendSession,
  );
}
```

---

## Monitoring and Debugging

### Access Session State

```dart
final store = Provider.of<SceneEvalStore>(context);
print('Active backend: ${store.backendSession.active?.name}');
print('Status: ${store.diagnosisStatus}');
print('Batch ID: ${store.batchId}');
```

### Network Debugging

Enable Dio logging:

```dart
final dio = Dio();
dio.interceptors.add(
  LogInterceptor(
    requestBody: true,
    responseBody: true,
  ),
);
```

### Error Messages

- `uploadError`: Populated if upload fails
- `diagnosisError`: Populated if diagnosis fails
- Both available in store for debugging

---

## Deployment Checklist

- [ ] Backend endpoints tested with Postman/curl
- [ ] `api_config.dart` created with correct backend URLs
- [ ] Health check working (manual: `curl http://backend:8000/health`)
- [ ] Upload endpoint returns valid batch_id
- [ ] Status endpoint returns correct status values
- [ ] Result endpoint returns complete diagnosis JSON
- [ ] Timeouts appropriate for backend speed
- [ ] Error messages user-friendly
- [ ] Tested failover with secondary backend
- [ ] Monitoring/logging configured

---

## Support

For issues with backend integration:

1. Check backend logs for errors
2. Verify endpoints with manual HTTP requests
3. Enable Dio logging for network debugging
4. Check timeout configuration matches backend speed
5. Test with fake backend to isolate issues
