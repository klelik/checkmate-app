import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          children: [
            // Dark Mode
            _SettingsTile(
              icon: LucideIcons.moon,
              title: 'Dark Mode',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              trailing: Switch.adaptive(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).state = value;
                },
                activeTrackColor: AppColors.primary,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 50.ms)
                .slideX(
                  begin: -0.03,
                  end: 0,
                  duration: 400.ms,
                  delay: 50.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.md),

            // Notifications
            _SettingsTile(
              icon: LucideIcons.bell,
              title: 'Notifications',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: textSecondary,
              ),
              onTap: () {
                // Navigate to notifications settings
              },
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms)
                .slideX(
                  begin: -0.03,
                  end: 0,
                  duration: 400.ms,
                  delay: 100.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.md),

            // Privacy Policy
            _SettingsTile(
              icon: LucideIcons.shield,
              title: 'Privacy Policy',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: textSecondary,
              ),
              onTap: () {
                // Navigate to privacy policy
              },
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slideX(
                  begin: -0.03,
                  end: 0,
                  duration: 400.ms,
                  delay: 150.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.md),

            // Terms of Service
            _SettingsTile(
              icon: LucideIcons.fileText,
              title: 'Terms of Service',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: textSecondary,
              ),
              onTap: () {
                // Navigate to terms of service
              },
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideX(
                  begin: -0.03,
                  end: 0,
                  duration: 400.ms,
                  delay: 200.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.md),

            // Rate the App
            _SettingsTile(
              icon: LucideIcons.star,
              title: 'Rate the App',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: textSecondary,
              ),
              onTap: () {
                // Open app store rating
              },
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 250.ms)
                .slideX(
                  begin: -0.03,
                  end: 0,
                  duration: 400.ms,
                  delay: 250.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.md),

            // App Version
            _SettingsTile(
              icon: LucideIcons.info,
              title: 'App Version',
              subtitle: '1.0.0',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms)
                .slideX(
                  begin: -0.03,
                  end: 0,
                  duration: 400.ms,
                  delay: 300.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color? textSecondary;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    this.textSecondary,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: textSecondary,
                  ),
                )
              : null,
          trailing: trailing,
        ),
      ),
    );
  }
}
