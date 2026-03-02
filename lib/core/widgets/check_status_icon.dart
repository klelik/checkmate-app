import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum CheckStatus { clear, caution, alert, unknown }

class CheckStatusIcon extends StatelessWidget {
  final CheckStatus status;
  final String label;
  final double size;

  const CheckStatusIcon({
    super.key,
    required this.status,
    required this.label,
    this.size = 48,
  });

  Color get _color {
    switch (status) {
      case CheckStatus.clear:
        return AppColors.riskClear;
      case CheckStatus.caution:
        return AppColors.riskCaution;
      case CheckStatus.alert:
        return AppColors.riskCritical;
      case CheckStatus.unknown:
        return AppColors.textTertiaryDark;
    }
  }

  IconData get _icon {
    switch (status) {
      case CheckStatus.clear:
        return LucideIcons.checkCircle2;
      case CheckStatus.caution:
        return LucideIcons.alertTriangle;
      case CheckStatus.alert:
        return LucideIcons.xCircle;
      case CheckStatus.unknown:
        return LucideIcons.helpCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.48;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _color.withValues(alpha: 0.12),
            border: Border.all(
              color: _color.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Icon(_icon, size: iconSize, color: _color),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
