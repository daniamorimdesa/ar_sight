import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays the upload state while captured frames are being sent.
///
/// An [UploadingState] informs the user that the captured frame batch is being
/// uploaded to the backend before diagnosis starts.
class UploadingState extends StatelessWidget {
  /// Creates the upload progress state.
  const UploadingState({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF00D4FF);

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Glowing upload icon.
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withOpacity(0.12),
            border: Border.all(color: accent.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.22),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.cloud_upload_rounded,
            color: accent,
            size: 30,
          ),
        ),

        const SizedBox(height: 12),

        // Upload progress message.
        Text(
          'Sending frames...',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.white.withOpacity(0.92),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        // Glowing loading indicator.
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.22),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
      ],
    );
  }
}
