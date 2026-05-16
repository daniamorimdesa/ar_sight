import 'package:dio/dio.dart';

import '../external/config/backend_resolver.dart';
import '../external/config/backend_session.dart';
import '../external/datasources/fake_scene_datasource.dart';
import '../external/datasources/fake_scene_upload_datasource.dart';
import '../external/datasources/scene_datasource.dart';
import '../external/datasources/scene_upload_datasource.dart';
import '../presenter/stores/scene_eval_store.dart';

/// Builds and configures the main scene evaluation store.
///
/// This setup function creates the required datasources and injects them into
/// [SceneEvalStore]. It can use either fake datasources for UI development and
/// testing or real HTTP datasources connected to the resolved backend.
Future<SceneEvalStore> buildStore() async {
  const bool useFakeBackend = false;

  final backendSession = BackendSession();

  if (useFakeBackend) {
    return SceneEvalStore(
      FakeSceneDatasource(),
      FakeSceneUploadDatasource(),
      backendSession,
    );
  }

  // Resolve the backend available on the current network.
  final resolver = BackendResolver(Dio());
  backendSession.active = await resolver.resolve();

  // Shared HTTP client used by real backend datasources.
  final dio = Dio();

  final sceneDatasource = SceneDatasourceImpl(dio, backendSession);
  final sceneUploadDatasource = SceneUploadDatasourceImpl(dio, backendSession);

  return SceneEvalStore(sceneDatasource, sceneUploadDatasource, backendSession);
}
