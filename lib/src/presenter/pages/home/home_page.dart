import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../models/frame_data.dart';
import 'components/dialog_box.dart';
import 'components/elevated_button_3d.dart';
import 'components/home_bottom_bar.dart';
import '../scene_eval/scene_eval_page.dart';
import '../how_to/how_to_page.dart';
import '../frames_preview/frames_preview_page.dart';
import '../result/result_page.dart';
import '../../stores/scene_eval_store.dart';

/// Initial screen of the application.
///
/// A [HomePage] presents the ARSIGHT visual identity, animated background,
/// introductory message, main action button, and shortcuts to instructions,
/// captured frames, and the latest diagnosis result.
class HomePage extends StatefulWidget {
  /// Creates the application home page.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State responsible for managing the animated video background and navigation.
class _HomePageState extends State<HomePage> {
  /// Controller used to play the home page background video.
  late final VideoPlayerController _bg;

  @override
  void initState() {
    super.initState();

    // Configure the background video to loop silently.
    _bg = VideoPlayerController.asset('assets/videos/ar_bg_4.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;

        setState(() {});
        _bg.play();
      });
  }

  @override
  void dispose() {
    _bg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen animated video background.
          Positioned.fill(
            child: _bg.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _bg.value.size.width,
                      height: _bg.value.size.height,
                      child: VideoPlayer(_bg),
                    ),
                  )
                : const ColoredBox(color: Color.fromARGB(100, 0, 0, 0)),
          ),

          // Dark overlay to improve foreground readability.
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 3, 19, 45).withOpacity(0.35),
            ),
          ),

          // Centered top application logo.
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: SvgPicture.asset(
                  'assets/logo/ARSIGHT_logo.svg',
                  height: 56,
                ),
              ),
            ),
          ),

          // Central introduction card with title and description.
          Align(
            alignment: const Alignment(0, -0.25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DialogBox(
                width: min(820, size.width * 0.95),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main application tagline.
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 6,
                        left: 10,
                        right: 10,
                      ),
                      child: Text(
                        'Make your scene ready for AR',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    // Short explanation of the scene diagnosis workflow.
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 16,
                        right: 16,
                      ),
                      child: Text(
                        'A quick scan of your scene will help you understand '
                        'if it’s ready for AR experiences, and how to improve '
                        'it using our tools.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main call-to-action button that starts the scene evaluation flow.
          Align(
            alignment: const Alignment(0, 0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton3D(
                label: 'start',
                icon: Icons.camera_alt_rounded,
                width: min(280, size.width * 0.7),
                height: 66,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SceneEvalPage()),
                  );
                },
              ),
            ),
          ),

          // Decorative animated character placed behind the bottom navigation.
          Positioned(
            left: -80,
            bottom: 100,
            child: IgnorePointer(
              child: SizedBox(
                width: size.width * 1.2,
                child: Lottie.asset(
                  'assets/lottie/blackcat.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Bottom navigation bar with shortcuts to guidance and previous data.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Observer(
                builder: (_) {
                  final store = context.read<SceneEvalStore>();

                  return HomeBottomBar(
                    hasFrames: store.lastCapturedFrames.isNotEmpty,
                    lastStatus: store.lastResult?.status,

                    // Open the instructions page.
                    onInstructionsTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HowToPage()),
                      );
                    },

                    // Open the latest captured frames when available.
                    onLastFramesTap: () {
                      if (store.lastCapturedFrames.isNotEmpty) {
                        final frameDataList = store.lastResult?.frames
                            .asMap()
                            .entries
                            .map((e) => FrameData.fromBackend(e.value, e.key))
                            .toList()
                            .cast<FrameData>();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FramesPreviewPage(
                              frames: store.lastCapturedFrames,
                              frameDataList: frameDataList,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No frames captured yet'),
                          ),
                        );
                      }
                    },

                    // Open the latest diagnosis result when available.
                    onLastDiagnosisTap: () {
                      if (store.lastResult != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ResultPage(diagnosis: store.lastResult!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No diagnosis available yet'),
                          ),
                        );
                      }
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

/// Returns the smallest value between [a] and [b].
double min(double a, double b) => a < b ? a : b;
