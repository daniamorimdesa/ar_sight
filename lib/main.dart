import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/presenter/pages/home/home_page.dart';
import 'src/presenter/stores/scene_eval_store.dart';

void main() {
  runApp(
    Provider<SceneEvalStore>(
      create: (_) => SceneEvalStore(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
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
