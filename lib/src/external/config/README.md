# Backend Configuration Guide

This directory contains configuration files for the backend endpoint connectivity layer. Developers must create environment-specific configurations to enable communication with diagnosis processing backends.

## 1. Backend Endpoint Configuration (`ApiConfig`)

### 1.1 Overview

The backend endpoint configuration defines a set of `BackendCandidate` objects that represent distinct execution environments available to the diagnosis pipeline. Each candidate encapsulates connection parameters and timeout specifications required to communicate with a backend server performing AI-driven image analysis.

The application supports multiple concurrent backend candidates, enabling intelligent fallback mechanisms when primary backends are unavailable. This architectural pattern ensures robust operation across heterogeneous deployment scenarios, including:

- **Jetson Orin**: High-performance embedded GPU device for real-time inference
- **Jetson Nano**: Resource-constrained embedded platform for edge deployment
- **Desktop Workstation**: Development and testing environment with unbounded resources

### 1.2 Configuration Parameters

Each `BackendCandidate` instance requires the following parameters:

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `name` | `String` | Human-readable identifier for the backend environment | `'Jetson Orin'` |
| `baseUrl` | `String` | Base URL for backend API requests (protocol + host + port) | `'http://192.168.15.3:8000'` |
| `healthCheckTimeout` | `Duration` | Maximum duration for backend health verification requests | `Duration(seconds: 5)` |
| `diagnosisTimeout` | `Duration` | Maximum duration for complete diagnosis pipeline execution | `Duration(seconds: 30)` |
| `pollingIntervalSeconds` | `int` | Interval between repeated status checks during diagnosis | `1` (1 second) |

### 1.3 Implementation and Setup Instructions

#### Step 1: Create Configuration File

Create a new file named `api_config.dart` in this directory with the following template:

```dart
import 'backend_candidate.dart';

/// Defines the backend endpoint candidates available to the application.
///
/// Each [BackendCandidate] represents a possible execution environment for
/// the diagnosis pipeline, such as an embedded Jetson device or a desktop
/// workstation used during development and testing.
///
/// **SECURITY NOTE:** This file contains environment-specific URLs and is
/// intentionally excluded from version control (.gitignore) to prevent
/// accidental exposure of network infrastructure details.
class ApiConfig {
  /// Ordered list of backend candidates used by the connection layer.
  ///
  /// The application can use this list to try different backend endpoints
  /// depending on availability, hardware platform, and expected processing
  /// latency. Candidates are attempted in list order until one succeeds.
  static const List<BackendCandidate> candidates = [
    BackendCandidate(
      name: 'Jetson Orin',
      baseUrl: 'http://your-jetson-orin-host.local:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),

    BackendCandidate(
      name: 'Jetson Nano',
      baseUrl: 'http://your-jetson-nano-host.local:8000',
      healthCheckTimeout: Duration(seconds: 15),
      diagnosisTimeout: Duration(seconds: 240),
      pollingIntervalSeconds: 5,
    ),

    BackendCandidate(
      name: 'Desktop Workstation',
      baseUrl: 'http://your-desktop-host.local:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),
  ];
}
```

#### Step 2: Update with Environment-Specific Values

Replace the placeholder URLs with actual network addresses:

```dart
BackendCandidate(
  name: 'Jetson Orin',
  baseUrl: 'http://192.168.15.3:8000',  // ← Update with actual host IP
  healthCheckTimeout: Duration(seconds: 5),
  diagnosisTimeout: Duration(seconds: 30),
  pollingIntervalSeconds: 1,
),
```

#### Step 3: Configure Timeout Parameters

Adjust timeout values based on hardware capabilities:

- **High-performance devices** (Jetson Orin, Desktop): Short timeouts (5-30 seconds)
- **Resource-constrained devices** (Jetson Nano): Extended timeouts (15-240 seconds)
- **Network conditions**: Increase timeouts for high-latency environments

### 1.4 Git Management

The `api_config.dart` file is intentionally excluded from version control:

```gitignore
# In .gitignore
lib/src/external/config/api_config.dart
```

**Rationale**: Configuration files contain environment-specific infrastructure details (IP addresses, network topology) that should not be committed to repositories. Each developer and deployment environment maintains independent configuration files.

### 1.5 Development Workflow

For local development with a specific backend:

1. **Create local configuration**: Create `api_config.dart` and populate with your backend addresses
2. **Test connectivity**: Use health check endpoints to verify backend availability
3. **Monitor timeouts**: Adjust timeout parameters if diagnosis processing exceeds configured duration
4. **Document environment**: Record backend addresses and timeout configurations used for testing

### 1.6 Architecture Integration

The `ApiConfig` class integrates with the external services layer:

- **Location**: `lib/src/external/config/api_config.dart`
- **Access Pattern**: `ApiConfig.candidates` provides ordered list of available backends
- **Consumer**: Backend connection service attempts candidates sequentially
- **Failure Handling**: Circuit-breaking logic prevents repeated requests to unavailable backends
