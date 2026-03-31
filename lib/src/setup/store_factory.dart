import 'package:dio/dio.dart';

import '../external/datasources/fake_scene_datasource.dart';
import '../external/datasources/fake_scene_upload_datasource.dart';
import '../external/datasources/scene_datasource.dart';
import '../external/datasources/scene_upload_datasource.dart';
import '../presenter/stores/scene_eval_store.dart';

SceneEvalStore buildStore() {
  const bool useFakeBackend = false;
  final dio = Dio();

  final sceneDatasource = useFakeBackend
      ? FakeSceneDatasource()
      : SceneDatasourceImpl(dio);

  final sceneUploadDatasource = useFakeBackend
      ? FakeSceneUploadDatasource()
      : SceneUploadDatasourceImpl(dio);

  return SceneEvalStore(sceneDatasource, sceneUploadDatasource);
}
