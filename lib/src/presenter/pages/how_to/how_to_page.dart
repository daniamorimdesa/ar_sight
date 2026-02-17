import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/section_title.dart';
import 'components/tip_row.dart';
import 'components/tip_divider.dart';
import 'components/surface_card.dart';

class HowToPage extends StatelessWidget {
  const HowToPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        titleSpacing: 0,
        title: Text(
          'HOW TO SCAN',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 85),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ARsight captures a short scan (10 seconds) of your environment.',
                            style: _body(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'The frames are sent to a server that evaluates scene conditions and returns recommendations to improve AR tracking stability.',
                            style: _body(opacity: 0.78),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -10,
                      top: 0,
                      child: Transform.rotate(
                        angle: -math.pi / 2, // 90 graus anti-horário
                        child: Image.asset(
                          'assets/icon/icon3_rm_bg.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                const SectionTitle(title: '- How to get good results'),
                const SizedBox(height: 10),
                SurfaceCard(
                  child: Column(
                    children: const [
                      TipRow(
                        icon: Icons.pan_tool_alt_outlined,
                        title: 'Hold steady',
                        text:
                            'Hold the phone firmly (both hands if possible) to reduce shake.',
                      ),
                      TipDivider(),
                      TipRow(
                        icon: Icons.crop_free_rounded,
                        title: 'Aim at the target area',
                        text:
                            'Point the camera to the floor/region where AR content will be placed.',
                      ),
                      TipDivider(),
                      TipRow(
                        icon: Icons.slow_motion_video_rounded,
                        title: 'Move slowly for 10 seconds',
                        text:
                            'Do smooth, slow movements around the area (ARCore-style scan).',
                      ),
                      TipDivider(),
                      TipRow(
                        icon: Icons.motion_photos_off_outlined,
                        title: 'Avoid blur',
                        text:
                            'Avoid quick turns, sudden stops, and fast motion that causes blur.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                const SectionTitle(title: '- A good environment'),
                const SizedBox(height: 10),
                SurfaceCard(
                  child: Column(
                    children: const [
                      TipRow(
                        icon: Icons.texture_rounded,
                        title: 'Visible textures',
                        text:
                            'Surfaces with texture help tracking (avoid plain, glossy floors when possible).',
                      ),
                      TipDivider(),
                      TipRow(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Stable lighting',
                        text:
                            'Prefer consistent lighting and avoid very dark scenes.',
                      ),
                      TipDivider(),
                      TipRow(
                        icon: Icons.layers_clear_outlined,
                        title: 'Low occlusion',
                        text:
                            'Keep the view clear so the camera can “see” the area reliably.',
                      ),
                      TipDivider(),
                      TipRow(
                        icon: Icons.visibility_outlined,
                        title: 'Low reflections',
                        text:
                            'Strong reflections can confuse tracking—use matte coverings if needed.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

/// ---------- styles / pieces ----------

TextStyle _body({double opacity = 0.92}) => GoogleFonts.montserrat(
      fontSize: 14,
      height: 1.45,
      color: const Color(0xFF64748B).withOpacity(opacity),
      fontWeight: FontWeight.w400,
    );

