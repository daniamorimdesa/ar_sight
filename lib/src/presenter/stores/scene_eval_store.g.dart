// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_eval_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SceneEvalStore on _SceneEvalStoreBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_SceneEvalStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorAtom = Atom(
    name: '_SceneEvalStoreBase.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$diagnosisAtom = Atom(
    name: '_SceneEvalStoreBase.diagnosis',
    context: context,
  );

  @override
  dynamic get diagnosis {
    _$diagnosisAtom.reportRead();
    return super.diagnosis;
  }

  @override
  set diagnosis(dynamic value) {
    _$diagnosisAtom.reportWrite(value, super.diagnosis, () {
      super.diagnosis = value;
    });
  }

  late final _$evaluateSceneAsyncAction = AsyncAction(
    '_SceneEvalStoreBase.evaluateScene',
    context: context,
  );

  @override
  Future<void> evaluateScene(String imagePath) {
    return _$evaluateSceneAsyncAction.run(() => super.evaluateScene(imagePath));
  }

  late final _$_SceneEvalStoreBaseActionController = ActionController(
    name: '_SceneEvalStoreBase',
    context: context,
  );

  @override
  void reset() {
    final _$actionInfo = _$_SceneEvalStoreBaseActionController.startAction(
      name: '_SceneEvalStoreBase.reset',
    );
    try {
      return super.reset();
    } finally {
      _$_SceneEvalStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
diagnosis: ${diagnosis}
    ''';
  }
}
