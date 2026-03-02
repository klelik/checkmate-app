import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class UKPlateInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmitted;
  final VoidCallback? onCameraTap;

  const UKPlateInput({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.plateYellow,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.plateBlack, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // GB blue strip
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.plateBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // EU stars circle
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CustomPaint(
                    painter: _EUStarsPainter(),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'GB',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

          // Text input
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                LengthLimitingTextInputFormatter(8),
                _UpperCaseTextFormatter(),
              ],
              style: GoogleFonts.dmSans(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.plateBlack,
                letterSpacing: 3,
              ),
              decoration: InputDecoration(
                hintText: 'AB12 CDE',
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.plateBlack.withValues(alpha: 0.25),
                  letterSpacing: 3,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                filled: false,
              ),
              onSubmitted: (_) => onSubmitted?.call(),
            ),
          ),

          // Camera button
          if (onCameraTap != null)
            GestureDetector(
              onTap: onCameraTap,
              child: Container(
                width: 48,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.plateBlack.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    LucideIcons.camera,
                    size: 22,
                    color: AppColors.plateBlack,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _EUStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Draw 12 small dots arranged in a circle (EU flag style)
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final starX = center.dx + radius * math.cos(angle);
      final starY = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(starX, starY), 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
