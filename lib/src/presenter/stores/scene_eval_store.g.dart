// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_eval_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SceneEvalStore on _SceneEvalStore, Store {
  late final _$isCapturingAtom = Atom(
    name: '_SceneEvalStore.isCapturing',
    context: context,
  );

  @override
  bool get isCapturing {
    _$isCapturingAtom.reportRead();
    return super.isCapturing;
  }

  @override
  set isCapturing(bool value) {
    _$isCapturingAtom.reportWrite(value, super.isCapturing, () {
      super.isCapturing = value;
    });
  }

  late final _$isUploadingAtom = Atom(
    name: '_SceneEvalStore.isUploading',
    context: context,
  );

  @override
  bool get isUploading {
    _$isUploadingAtom.reportRead();
    return super.isUploading;
  }

  @override
  set isUploading(bool value) {
    _$isUploadingAtom.reportWrite(value, super.isUploading, () {
      super.isUploading = value;
    });
  }

  late final _$isDiagnosingAtom = Atom(
    name: '_SceneEvalStore.isDiagnosing',
    context: context,
  );

  @override
  bool get isDiagnosing {
    _$isDiagnosingAtom.reportRead();
    return super.isDiagnosing;
  }

  @override
  set isDiagnosing(bool value) {
    _$isDiagnosingAtom.reportWrite(value, super.isDiagnosing, () {
      super.isDiagnosing = value;
    });
  }

  late final _$capturedFramesAtom = Atom(
    name: '_SceneEvalStore.capturedFrames',
    context: context,
  );

  @override
  int get capturedFrames {
    _$capturedFramesAtom.reportRead();
    return super.capturedFrames;
  }

  @override
  set capturedFrames(int value) {
    _$capturedFramesAtom.reportWrite(value, super.capturedFrames, () {
      super.capturedFrames = value;
    });
  }

  late final _$progressAtom = Atom(
    name: '_SceneEvalStore.progress',
    context: context,
  );

  @override
  double get progress {
    _$progressAtom.reportRead();
    return super.progress;
  }

  @override
  set progress(double value) {
    _$progressAtom.reportWrite(value, super.progress, () {
      super.progress = value;
    });
  }

  late final _$secondsRemainingAtom = Atom(
    name: '_SceneEvalStore.secondsRemaining',
    context: context,
  );

  @override
  int get secondsRemaining {
    _$secondsRemainingAtom.reportRead();
    return super.secondsRemaining;
  }

  @override
  set secondsRemaining(int value) {
    _$secondsRemainingAtom.reportWrite(value, super.secondsRemaining, () {
      super.secondsRemaining = value;
    });
  }

  late final _$lastCapturedFramesAtom = Atom(
    name: '_SceneEvalStore.lastCapturedFrames',
    context: context,
  );

  @override
  List<Uint8List> get lastCapturedFrames {
    _$lastCapturedFramesAtom.reportRead();
    return super.lastCapturedFrames;
  }

  @override
  set lastCapturedFrames(List<Uint8List> value) {
    _$lastCapturedFramesAtom.reportWrite(value, super.lastCapturedFrames, () {
      super.lastCapturedFrames = value;
    });
  }

  late final _$lastResultAtom = Atom(
    name: '_SceneEvalStore.lastResult',
    context: context,
  );

  @override
  SceneDiagnosis? get lastResult {
    _$lastResultAtom.reportRead();
    return super.lastResult;
  }

  @override
  set lastResult(SceneDiagnosis? value) {
    _$lastResultAtom.reportWrite(value, super.lastResult, () {
      super.lastResult = value;
    });
  }

  late final _$lastUploadResponseAtom = Atom(
    name: '_SceneEvalStore.lastUploadResponse',
    context: context,
  );

  @override
  Map<String, dynamic>? get lastUploadResponse {
    _$lastUploadResponseAtom.reportRead();
    return super.lastUploadResponse;
  }

  @override
  set lastUploadResponse(Map<String, dynamic>? value) {
    _$lastUploadResponseAtom.reportWrite(value, super.lastUploadResponse, () {
      super.lastUploadResponse = value;
    });
  }

  late final _$uploadErrorAtom = Atom(
    name: '_SceneEvalStore.uploadError',
    context: context,
  );

  @override
  String? get uploadError {
    _$uploadErrorAtom.reportRead();
    return super.uploadError;
  }

  @override
  set uploadError(String? value) {
    _$uploadErrorAtom.reportWrite(value, super.uploadError, () {
      super.uploadError = value;
    });
  }

  late final _$diagnosisErrorAtom = Atom(
    name: '_SceneEvalStore.diagnosisError',
    context: context,
  );

  @override
  String? get diagnosisError {
    _$diagnosisErrorAtom.reportRead();
    return super.diagnosisError;
  }

  @override
  set diagnosisError(String? value) {
    _$diagnosisErrorAtom.reportWrite(value, super.diagnosisError, () {
      super.diagnosisError = value;
    });
  }

  late final _$batchIdAtom = Atom(
    name: '_SceneEvalStore.batchId',
    context: context,
  );

  @override
  String? get batchId {
    _$batchIdAtom.reportRead();
    return super.batchId;
  }

  @override
  set batchId(String? value) {
    _$batchIdAtom.reportWrite(value, super.batchId, () {
      super.batchId = value;
    });
  }

  late final _$diagnosisStatusAtom = Atom(
    name: '_SceneEvalStore.diagnosisStatus',
    context: context,
  );

  @override
  String get diagnosisStatus {
    _$diagnosisStatusAtom.reportRead();
    return super.diagnosisStatus;
  }

  @override
  set diagnosisStatus(String value) {
    _$diagnosisStatusAtom.reportWrite(value, super.diagnosisStatus, () {
      super.diagnosisStatus = value;
    });
  }

  late final _$startCaptureAsyncAction = AsyncAction(
    '_SceneEvalStore.startCapture',
    context: context,
  );

  @override
  Future<void> startCapture(CameraController controller) {
    return _$startCaptureAsyncAction.run(() => super.startCapture(controller));
  }

  late final _$_uploadAndDiagnoseAsyncAction = AsyncAction(
    '_SceneEvalStore._uploadAndDiagnose',
    context: context,
  );

  @override
  Future<void> _uploadAndDiagnose(List<Uint8List> frames) {
    return _$_uploadAndDiagnoseAsyncAction.run(
      () => super._uploadAndDiagnose(frames),
    );
  }

  @override
  String toString() {
    return '''
isCapturing: ${isCapturing},
isUploading: ${isUploading},
isDiagnosing: ${isDiagnosing},
capturedFrames: ${capturedFrames},
progress: ${progress},
secondsRemaining: ${secondsRemaining},
lastCapturedFrames: ${lastCapturedFrames},
lastResult: ${lastResult},
lastUploadResponse: ${lastUploadResponse},
uploadError: ${uploadError},
diagnosisError: ${diagnosisError},
batchId: ${batchId},
diagnosisStatus: ${diagnosisStatus}
    ''';
  }
}
