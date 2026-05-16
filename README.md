# AR Sight

![Flutter](https://img.shields.io/badge/Flutter-3.13.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.1+-0175C2?logo=dart)
![MobX](https://img.shields.io/badge/MobX-2.6.0-FF6F00)
![License](https://img.shields.io/badge/license-MIT-green)

Real-time scene analysis powered by AI. Capture, analyze, and diagnose in a unified framework.

AR Sight is a cross-platform Flutter application designed to capture sequential scene data through mobile cameras and perform real-time AI-driven diagnosis through distributed backend processing. Deploy to any device, connect to any backend.

## What It Does

- **Scene Capture**: Precise temporal frame sequencing from device cameras
- **Smart Upload**: Intelligent batch transmission with error recovery
- **Async Processing**: Non-blocking backend diagnosis with live status polling
- **Rich Results**: Detailed diagnosis reports with frame-level analysis
- **Multi-Platform**: Works on Android, iOS, Linux, and Web

---

## Architecture

AR Sight implements a **4-phase pipeline** for end-to-end scene diagnosis:

```
PHASE 1: CAPTURE          PHASE 2: UPLOAD         PHASE 3: DIAGNOSIS      PHASE 4: RESULTS
─────────────────────────────────────────────────────────────────────────────────────────
Camera → Memory           Network                 Backend Processing      Display Results
~10 seconds               Variable (2-10s)        Variable (30s-mins)     Instant
```

### Core Components

- **CameraService**: Interval-based frame capture with adaptive retry logic
- **SceneEvalStore**: MobX observable managing the complete diagnosis lifecycle
- **Backend Session**: Intelligent fallover mechanism for multiple backends
- **Data Adapters**: Type-safe transformation between network and domain models

[View detailed architecture →](docs/ARCHITECTURE.md)

## Features

- Capture frames at precise 1 Hz intervals
- Batch upload with automatic error recovery
- Real-time diagnosis status polling
- Multi-backend failover with health checks
- Frame-level diagnostic results
- Cross-platform support (Android, iOS, Linux, Web)
- Clean architecture with MobX state management
- Type-safe data serialization

---

## Getting Started

### Prerequisites

- Flutter SDK 3.13.0 or higher
- Dart SDK 3.1.0 or higher
- Android SDK or iOS Xcode (depending on target platform)

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/ar_sight.git
cd ar_sight

# Get dependencies
flutter pub get

# Generate MobX files
dart run build_runner build --delete-conflicting-outputs

# Run on device
flutter run
```

### Configure Backend

Create `lib/src/external/config/api_config.dart`:

```dart
import 'backend_candidate.dart';

class ApiConfig {
  static const List<BackendCandidate> candidates = [
    BackendCandidate(
      name: 'My Backend',
      baseUrl: 'http://192.168.1.100:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),
  ];
}
```

[Full setup guide →](lib/src/external/config/README.md)

---

## Technology Stack

- **[Flutter](https://flutter.dev/)** - Cross-platform UI framework
- **[Dart](https://dart.dev/)** - Programming language with sound null safety
- **[MobX](https://pub.dev/packages/mobx)** - Reactive state management
- **[flutter_mobx](https://pub.dev/packages/flutter_mobx)** - Flutter integration for MobX
- **[Provider](https://pub.dev/packages/provider)** - Dependency injection and service location
- **[Dio](https://pub.dev/packages/dio)** - HTTP client with interceptor support
- **[camera](https://pub.dev/packages/camera)** - Camera plugin for device access
- **[json_serializable](https://pub.dev/packages/json_serializable)** - JSON serialization

### Development Tools

- **[build_runner](https://pub.dev/packages/build_runner)** - Code generation orchestration
- **[mobx_codegen](https://pub.dev/packages/mobx_codegen)** - MobX code generation
- **[flutter_lints](https://pub.dev/packages/flutter_lints)** - Recommended lint rules

---

## Documentation

- **[Architecture Guide](docs/ARCHITECTURE.md)** — System design, layered architecture, design patterns
- **[Pipeline Documentation](docs/PIPELINE.md)** — 4-phase lifecycle, state management, error handling
- **[Backend Integration](docs/BACKEND_INTEGRATION.md)** — Connecting to diagnosis engines, API contracts
- **[Quick Reference](docs/QUICK_REFERENCE.md)** — Common APIs, code examples, debugging

---

## Use Cases

- Medical Imaging Analysis: Real-time diagnostic screening
- Quality Control: Automated scene inspection and analysis
- AR Content Validation: Scene readiness assessment
- Edge AI Deployment: On-device and cloud processing integration

---

## Project Structure

```
ar_sight/
├── lib/
│   ├── src/
│   │   ├── external/              # Backend communication & services
│   │   │   ├── adapters/          # API response adapters
│   │   │   ├── config/            # Backend configuration
│   │   │   ├── datasources/       # Network interfaces
│   │   │   └── services/          # Device services (camera, etc)
│   │   ├── models/                # Domain models and entities
│   │   ├── presenter/             # UI pages and state management
│   │   │   ├── pages/
│   │   │   ├── stores/
│   │   │   └── components/
│   │   └── setup/                 # Dependency injection
│   └── main.dart
├── docs/                          # Technical documentation
├── test/                          # Unit tests
├── analysis_options.yaml
└── pubspec.yaml
```

---

## Development

### Code Generation

Generate MobX code after modifying stores:

```bash
# Generate once
dart run build_runner build --delete-conflicting-outputs

# Or watch mode for development
dart run build_runner watch --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# With coverage report
flutter test --coverage
```

### Build for Production

```bash
# Android
flutter build apk --release
flutter build aab --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Linux
flutter build linux --release
```

---

## Performance

- Frame Capture: ~10 seconds for 10 frames at 1 Hz sampling
- Batch Upload: 2-10 seconds (network dependent)
- Diagnosis Processing: 30 seconds to several minutes (backend dependent)
- Status Polling: Configurable interval (1-5 seconds recommended)
- Total Pipeline: 45 seconds to 15+ minutes (mostly backend processing)

---

## Core Features

- Multi-backend failover mechanism with health checks
- Real-time status polling and live progress updates
- Robust error recovery and retry logic
- Frame-level diagnostic results and analysis
- Cross-platform support (Android, iOS, Linux, Web)
- Clean architecture with MobX state management
- Type-safe data serialization and validation


---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Author

**Daniela Amorim de Sá** — [GitHub](https://github.com/das9)

Developed as the foundation work (TCC) for advancing research on real-time scene analysis and AI-driven diagnosis systems.

---

**Ready to get started?** [Configure your backend →](lib/src/external/config/README.md)

