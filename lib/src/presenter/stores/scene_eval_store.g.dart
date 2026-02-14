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

  late final _$startCaptureAsyncAction = AsyncAction(
    '_SceneEvalStore.startCapture',
    context: context,
  );

  @override
  Future<void> startCapture(CameraController controller) {
    return _$startCaptureAsyncAction.run(() => super.startCapture(controller));
  }

  @override
  String toString() {
    return '''
isCapturing: ${isCapturing},
capturedFrames: ${capturedFrames},
progress: ${progress},
secondsRemaining: ${secondsRemaining},
lastCapturedFrames: ${lastCapturedFrames}
    ''';
  }
}
