import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const _pages = [
  _OnboardingPage(
    icon: LucideIcons.searchCheck,
    title: 'Check any UK vehicle\nin seconds',
    subtitle:
        'Enter a registration number and get a comprehensive history report instantly',
  ),
  _OnboardingPage(
    icon: LucideIcons.shieldCheck,
    title: 'Know the truth\nbefore you buy',
    subtitle:
        'Uncover hidden finance, write-offs, stolen status, and mileage discrepancies',
  ),
  _OnboardingPage(
    icon: LucideIcons.piggyBank,
    title: 'Save thousands on\nyour next car',
    subtitle:
        'Our detailed reports help you negotiate better deals and avoid costly mistakes',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSkip() {
    ref.read(onboardingCompletedProvider.notifier).state = true;
    context.go('/home');
  }

  void _onGetStarted() {
    ref.read(onboardingCompletedProvider.notifier).state = true;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  right: AppSpacing.screenPadding,
                ),
                child: _currentPage < _pages.length - 1
                    ? GestureDetector(
                        onTap: _onSkip,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(height: 28),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageContent(
                    key: ValueKey(index),
                    page: page,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    isDark: isDark,
                  );
                },
              ),
            ),

            // Bottom section: indicator + button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                AppSpacing.xxxl,
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentPage == _pages.length - 1
                        ? SizedBox(
                            key: const ValueKey('getStarted'),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onGetStarted,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.buttonRadius,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Get Started',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            key: const ValueKey('next'),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.buttonRadius,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Next',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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

class _OnboardingPageContent extends StatelessWidget {
  final _OnboardingPage page;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;

  const _OnboardingPageContent({
    super.key,
    required this.page,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with background circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                page.icon,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          )
              .animate()
              .fadeIn(
                duration: 500.ms,
                delay: 100.ms,
              )
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                delay: 100.ms,
                curve: Curves.easeOutBack,
              ),

          const SizedBox(height: AppSpacing.xxxl),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              height: 1.2,
            ),
          )
              .animate()
              .fadeIn(
                duration: 500.ms,
                delay: 300.ms,
              )
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 500.ms,
                delay: 300.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: AppSpacing.lg),

          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textSecondary,
              height: 1.5,
            ),
          )
              .animate()
              .fadeIn(
                duration: 500.ms,
                delay: 500.ms,
              )
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 500.ms,
                delay: 500.ms,
                curve: Curves.easeOut,
              ),
        ],
      ),
    );
  }
}
