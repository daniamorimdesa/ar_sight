# Configuration Examples

This directory contains configuration templates for the project.

## api_config.example.dart

Template for backend endpoint configuration.

**Setup:**
1. Copy the `api_config.example.dart` file to `lib/src/external/config/api_config.dart`
2. Edit the `baseUrl` values with the actual addresses of your environment
3. Do not commit the `api_config.dart` file (it is in `.gitignore` for security reasons)

**Expected variables:**
- `name`: Descriptive name for the backend (e.g., 'Jetson Orin')
- `baseUrl`: Server URL (e.g., 'http://192.168.15.3:8000')
- `healthCheckTimeout`: Timeout for server health checks
- `diagnosisTimeout`: Timeout for diagnosis execution
- `pollingIntervalSeconds`: Polling interval between attempts

**Example:**
```dart
BackendCandidate(
  name: 'Jetson Jeff',
  baseUrl: 'http://192.168.15.3:8000',
  healthCheckTimeout: Duration(seconds: 5),
  diagnosisTimeout: Duration(seconds: 30),
  pollingIntervalSeconds: 1,
),
```
