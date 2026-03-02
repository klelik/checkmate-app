import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class RiskBadge extends StatelessWidget {
  final String category;
  final bool large;

  const RiskBadge({
    super.key,
    required this.category,
    this.large = false,
  });

  Color get _color => AppColors.riskColor(category);

  IconData get _icon {
    switch (category) {
      case 'Clear':
        return LucideIcons.checkCircle;
      case 'Caution':
        return LucideIcons.alertTriangle;
      case 'High Risk':
        return LucideIcons.alertOctagon;
      case 'Critical':
        return LucideIcons.xCircle;
      default:
        return LucideIcons.helpCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = large ? 18.0 : 14.0;
    final fontSize = large ? 14.0 : 12.0;
    final horizontalPadding = large ? AppSpacing.md : AppSpacing.sm;
    final verticalPadding = large ? AppSpacing.sm : AppSpacing.xs;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(large ? AppSpacing.sm : 6),
        border: Border.all(
          color: _color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: iconSize, color: _color),
          SizedBox(width: large ? AppSpacing.sm : AppSpacing.xs),
          Text(
            category,
            style: GoogleFonts.plusJakartaSans(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
