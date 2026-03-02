import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/uk_plate_input.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/risk_badge.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _plateController = TextEditingController();

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _onCheckNow() {
    final reg = _plateController.text.replaceAll(' ', '').trim();
    if (reg.isEmpty) return;
    context.push('/vehicle-confirm/$reg');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textTertiary =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
    final recentChecks = ref.watch(recentChecksProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                _greeting,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(
                    begin: -0.05,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Welcome to CheckMate',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideX(
                    begin: -0.05,
                    end: 0,
                    duration: 400.ms,
                    delay: 100.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: AppSpacing.xl),

              // Hero search card
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                borderColor: AppColors.primary.withValues(alpha: 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.searchCheck,
                          size: 22,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Check a vehicle',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    UKPlateInput(
                      controller: _plateController,
                      onSubmitted: _onCheckNow,
                      onCameraTap: () {
                        // Camera scan - future feature
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onCheckNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.buttonRadius,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Check Now',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 200.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: AppSpacing.xl),

              // Quick Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: LucideIcons.clipboardCheck,
                      label: 'Checks performed',
                      value: '24',
                      iconColor: AppColors.primary,
                      isDark: isDark,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      icon: LucideIcons.piggyBank,
                      label: 'Savings',
                      value: '\u00A34,200',
                      iconColor: AppColors.emerald,
                      isDark: isDark,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 350.ms)
                  .slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 350.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: AppSpacing.xl),

              // Recent Checks
              const SectionHeader(title: 'Recent Checks'),
              const SizedBox(height: AppSpacing.md),

              if (recentChecks.isEmpty)
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          LucideIcons.search,
                          size: 36,
                          color: textTertiary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No checks yet.\nStart your first check above!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 450.ms)
              else
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentChecks.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final check = recentChecks[index];
                      return SizedBox(
                        width: 200,
                        child: AppCard(
                          onTap: () => context.push(
                            '/report/${check.registrationNumber}',
                          ),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${check.make} ${check.model}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                check.registrationNumber,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                  letterSpacing: 1,
                                ),
                              ),
                              RiskBadge(category: check.riskCategory),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: (450 + index * 100).ms,
                          )
                          .slideX(
                            begin: 0.1,
                            end: 0,
                            duration: 400.ms,
                            delay: (450 + index * 100).ms,
                            curve: Curves.easeOut,
                          );
                    },
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),

              // Quick Actions
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: AppSpacing.md),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.3,
                children: [
                  _QuickActionCard(
                    icon: LucideIcons.searchCheck,
                    label: 'Full Check',
                    isDark: isDark,
                    textPrimary: textPrimary,
                    onTap: () => context.go('/check'),
                  ),
                  _QuickActionCard(
                    icon: LucideIcons.car,
                    label: 'My Garage',
                    isDark: isDark,
                    textPrimary: textPrimary,
                    onTap: () => context.go('/garage'),
                  ),
                  _QuickActionCard(
                    icon: LucideIcons.gitCompare,
                    label: 'Compare',
                    isDark: isDark,
                    textPrimary: textPrimary,
                    onTap: () => context.go('/compare'),
                  ),
                  _QuickActionCard(
                    icon: LucideIcons.poundSterling,
                    label: 'Value My Car',
                    isDark: isDark,
                    textPrimary: textPrimary,
                    onTap: () => context.go('/check'),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 550.ms)
                  .slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 550.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(icon, size: 20, color: iconColor),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color textPrimary;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.textPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
