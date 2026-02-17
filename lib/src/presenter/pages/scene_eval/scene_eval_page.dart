// scene_eval_page.dart: Tela de captura e avaliação da cena
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/camera_preview_box.dart';
import '../../stores/scene_eval_store.dart';
import '../result/result_page.dart';

class SceneEvalPage extends StatefulWidget {
  const SceneEvalPage({super.key});

  @override
  State<SceneEvalPage> createState() => _SceneEvalPageState();
}

class _SceneEvalPageState extends State<SceneEvalPage> {
  bool _starting = false; // ✅ trava instantânea do botão

  Future<void> _onStartPressed(SceneEvalStore store) async {
    final controller = CameraPreviewBox.controller;

    if (controller == null || !controller.value.isInitialized) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera not ready')));
      return;
    }

    // ✅ desabilita IMEDIATAMENTE (antes do MobX reagir)
    setState(() => _starting = true);

    try {
      await store.startCapture(controller);

      if (!mounted) return;

      if (store.lastResult != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultPage(diagnosis: store.lastResult!),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No diagnosis returned')));
      }
    } finally {
      // se a navegação não aconteceu (erro / sem resultado), destrava o botão
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<SceneEvalStore>();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: CameraPreviewBox()),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Observer(
                builder: (_) {
                  return _GlassBox(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: store.isCapturing
                          ? _CapturingState(
                              key: const ValueKey('capturing'),
                              secondsRemaining: store.secondsRemaining,
                              progress: store.progress,
                              capturedFrames: store.capturedFrames,
                            )
                          : const _IdleState(key: ValueKey('idle')),
                    ),
                  );
                },
              ),
            ),
          ),

          // Barra preta inferior com botão circular
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              padding: EdgeInsets.only(
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 8,
              ),
              child: Observer(
                builder: (_) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: CameraPreviewBox.isReady,
                    builder: (_, ready, _) {
                      final disabled = _starting || store.isCapturing || !ready;

                      return Center(
                        child: GestureDetector(
                          onTap: disabled ? null : () => _onStartPressed(store),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(disabled ? 0.3 : 1.0),
                                width: 4,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: store.isCapturing
                                      ? Colors.white.withOpacity(0.75)
                                      : Colors.white.withOpacity(disabled ? 0.3 : 1.0),
                                ),
                                child: store.isCapturing
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --------- UI pieces ---------

class _IdleState extends StatelessWidget {
  const _IdleState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Move slowly and keep the phone steady.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.92),
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Capture textures and avoid reflections.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white.withOpacity(0.80),
            fontWeight: FontWeight.w300,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _CapturingState extends StatelessWidget {
  final int secondsRemaining;
  final double progress;
  final int capturedFrames;

  const _CapturingState({
    super.key,
    required this.secondsRemaining,
    required this.progress,
    required this.capturedFrames,
  });

  @override
  Widget build(BuildContext context) {
    const glowColor = Color(0xFF00D4FF);

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Scanning your environment',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.92),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time: ${secondsRemaining}s',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.82),
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Frames: $capturedFrames/10',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.82),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.35),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(glowColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;

  const _GlassBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.50),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: child,
    );
  }
}
