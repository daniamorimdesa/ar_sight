// frames_preview_page.dart: página para exibir as últimas frames capturadas, 
// mostrando a qualidade de cada frame e permitindo que o usuário visualize detalhes adicionais ao clicar em cada frame
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/frame_data.dart';
import 'components/frame_card.dart';

class FramesPreviewPage extends StatelessWidget {
  final List<Uint8List> frames;
  final List<FrameData>? frameDataList;

  const FramesPreviewPage({
    super.key,
    required this.frames,
    this.frameDataList,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          'Frame Analysis',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        itemCount: frames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 9 / 16,
        ),
        itemBuilder: (context, index) {
          final frameData = frameDataList != null && index < frameDataList!.length
              ? frameDataList![index]
              : null;

          return FrameCard(
            frame: frames[index],
            index: index,
            frameData: frameData,
            accent: accent,
          );
        },
      ),
    );
  }
}


