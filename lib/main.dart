import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'src/presenter/pages/home/home_page.dart';
import 'src/presenter/stores/scene_eval_store.dart';
import 'src/setup/store_factory.dart';

/// Entry point of the ARSIGHT application.
///
/// The function initializes Flutter bindings, attempts to load environment
/// variables, builds the main [SceneEvalStore], and starts the application
/// with dependency injection configured through [Provider].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Keep app startup resilient even when .env is missing or unreadable.
    debugPrint('Could not load .env: $e');
  }

  final store = await buildStore();

  runApp(
    Provider<SceneEvalStore>(
      create: (_) => store,
      dispose: (_, store) => store.dispose(),
      child: const MainApp(),
    ),
  );
}

/// Root widget of the application.
///
/// A [MainApp] configures the global [MaterialApp] settings and defines
/// [HomePage] as the initial screen.
class MainApp extends StatelessWidget {
  /// Creates the root application widget.
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AR_Sight',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
