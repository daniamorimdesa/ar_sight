import 'package:dio/dio.dart';

import '../external/config/backend_resolver.dart';
import '../external/config/backend_session.dart';
import '../external/datasources/fake_scene_datasource.dart';
import '../external/datasources/fake_scene_upload_datasource.dart';
import '../external/datasources/scene_datasource.dart';
import '../external/datasources/scene_upload_datasource.dart';
import '../presenter/stores/scene_eval_store.dart';

Future<SceneEvalStore> buildStore() async {
  const bool useFakeBackend = false;

  final backendSession = BackendSession();
  final resolver = BackendResolver(Dio());
  backendSession.active = await resolver.resolve();

  if (useFakeBackend) {
    return SceneEvalStore(FakeSceneDatasource(), FakeSceneUploadDatasource(), backendSession);
  }

  final dio = Dio();

  final sceneDatasource = SceneDatasourceImpl(dio, backendSession);

  final sceneUploadDatasource = SceneUploadDatasourceImpl(dio, backendSession);

  return SceneEvalStore(sceneDatasource, sceneUploadDatasource, backendSession);
}
