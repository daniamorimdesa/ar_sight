import 'package:ar_sight/src/presenter/pages/components/camera_preview_box.dart';
import 'package:flutter/material.dart';


class SceneEvalPage extends StatelessWidget {
  const SceneEvalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ARSIGHT')),
      body: const CameraPreviewBox(),
    );
  }
}
