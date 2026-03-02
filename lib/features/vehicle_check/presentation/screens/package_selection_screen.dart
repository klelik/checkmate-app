import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

class PackageSelectionScreen extends ConsumerWidget {
  final String registrationNumber;

  const PackageSelectionScreen({
    super.key,
    required this.registrationNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Check',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FREE card
              _buildFreeCard(context, isDark)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.lg),

              // STANDARD card
              _buildStandardCard(context, isDark)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.lg),

              // FULL CHECK card
              _buildFullCard(context, isDark)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xl),

              // Bundle offers
              _buildBundleSection(isDark)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms),
              const SizedBox(height: AppSpacing.xl),

              // Trust badges
              _buildTrustBadges(isDark)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 400.ms),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FREE
  // ---------------------------------------------------------------------------
  Widget _buildFreeCard(BuildContext context, bool isDark) {
    return _PackageCard(
      isDark: isDark,
      borderColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      badgeText: 'Free',
      badgeColor: isDark ? AppColors.darkSurface : const Color(0xFFE2E8F0),
      badgeTextColor: isDark
          ? AppColors.textSecondaryDark
          : AppColors.textSecondaryLight,
      title: 'Basic Check',
      price: 'FREE',
      priceSubtext: null,
      features: const [
        'DVLA vehicle data',
        'MOT status',
        'Tax status',
        'Basic specifications',
        '20+ data points',
      ],
      button: AppButton(
        label: 'Get Free Check',
        variant: AppButtonVariant.secondary,
        onPressed: () =>
            context.push('/check-loading/$registrationNumber'),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STANDARD
  // ---------------------------------------------------------------------------
  Widget _buildStandardCard(BuildContext context, bool isDark) {
    return _PackageCard(
      isDark: isDark,
      borderColor: AppColors.primary,
      badgeText: 'Popular',
      badgeColor: AppColors.primary,
      badgeTextColor: Colors.white,
      title: 'Standard Check',
      price: '\u00A34.99',
      priceSubtext: 'one-time payment',
      features: const [
        'Everything in Free +',
        'Stolen vehicle check',
        'Outstanding finance',
        'Insurance write-off',
        'Mileage verification',
        '60+ data points',
      ],
      button: AppButton(
        label: 'Get Standard Check',
        onPressed: () =>
            context.push('/payment/$registrationNumber/standard'),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FULL
  // ---------------------------------------------------------------------------
  Widget _buildFullCard(BuildContext context, bool isDark) {
    return _PackageCard(
      isDark: isDark,
      borderColor: AppColors.emerald,
      badgeText: 'Best Value',
      badgeColor: AppColors.emerald,
      badgeTextColor: Colors.white,
      title: 'Full Check',
      price: '\u00A39.99',
      priceSubtext: 'one-time payment',
      features: const [
        'Everything in Standard +',
        'Vehicle valuation',
        'Full MOT history',
        'AI risk analysis',
        'PDF export',
        '\u00A310,000 data guarantee',
        '100+ data points',
      ],
      button: AppButton(
        label: 'Get Full Check',
        onPressed: () =>
            context.push('/payment/$registrationNumber/full'),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bundle
  // ---------------------------------------------------------------------------
  Widget _buildBundleSection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.emerald.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.tags,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Bundle & Save',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildBundleRow(
            'Buy 3 Full Checks',
            '\u00A312.99',
            'Save 57%',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildBundleRow(
            'Buy 5 Full Checks',
            '\u00A319.99',
            'Save 60%',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBundleRow(
    String title,
    String price,
    String savings,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.5)
              : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Text(
              savings,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.emerald,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Trust
  // ---------------------------------------------------------------------------
  Widget _buildTrustBadges(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTrustBadge(LucideIcons.lock, '256-bit SSL', isDark),
        _buildTrustBadge(LucideIcons.shieldCheck, 'GDPR\nCompliant', isDark),
        _buildTrustBadge(LucideIcons.badgeCheck, 'Data\nGuarantee', isDark),
      ],
    );
  }

  Widget _buildTrustBadge(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCard
                : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.emerald,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Package Card widget
// =============================================================================

class _PackageCard extends StatelessWidget {
  final bool isDark;
  final Color borderColor;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String title;
  final String price;
  final String? priceSubtext;
  final List<String> features;
  final Widget button;

  const _PackageCard({
    required this.isDark,
    required this.borderColor,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.title,
    required this.price,
    this.priceSubtext,
    required this.features,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              // Title & price
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  if (priceSubtext != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        priceSubtext!,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                height: 1,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Features
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.check,
                            size: 12,
                            color: AppColors.emerald,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            feature,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: feature.startsWith('Everything')
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: AppSpacing.sm),

              // Button
              button,
            ],
          ),
        ),

        // Badge
        Positioned(
          top: -12,
          right: AppSpacing.lg,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs + 2,
            ),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              boxShadow: [
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              badgeText,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: badgeTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
