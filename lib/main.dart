// main.dart: Ponto de entrada da aplicação

import 'package:flutter/material.dart';
import 'src/presenter/pages/home_page.dart';

void main() {
  runApp(const ArSightApp());
}

class ArSightApp extends StatelessWidget {
  const ArSightApp({super.key});

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

