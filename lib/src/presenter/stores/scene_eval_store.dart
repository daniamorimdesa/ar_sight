import 'package:mobx/mobx.dart';

part 'scene_eval_store.g.dart';

class SceneEvalStore = _SceneEvalStoreBase with _$SceneEvalStore;

abstract class _SceneEvalStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  dynamic diagnosis;

  @action
  Future<void> evaluateScene(String imagePath) async {
    isLoading = true;
    error = null;
    
    try {
      // TODO: Implementar lógica de avaliação
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void reset() {
    isLoading = false;
    error = null;
    diagnosis = null;
  }
}
