import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBorderColor = borderColor ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final effectivePadding = padding ?? const EdgeInsets.all(AppSpacing.lg);

    final cardContent = Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: effectiveBorderColor, width: 1),
      ),
      padding: effectivePadding,
      child: child,
    );

    if (onTap == null) return cardContent;

    return GestureDetector(
      onTap: onTap,
      child: cardContent,
    );
  }
}
