// main.dart: ponto de entrada do aplicativo, configurando o Provider para o SceneEvalStore e iniciando a aplicação com a HomePage como tela inicial
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'src/presenter/pages/home/home_page.dart';
import 'src/presenter/stores/scene_eval_store.dart';
import 'src/setup/store_factory.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  
  runApp(
    Provider<SceneEvalStore>(
      create: (_) => buildStore(),
      dispose: (_, store) => store.dispose(),
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
