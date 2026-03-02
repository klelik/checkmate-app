import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';

class CheckLoadingScreen extends ConsumerStatefulWidget {
  final String registrationNumber;

  const CheckLoadingScreen({
    super.key,
    required this.registrationNumber,
  });

  @override
  ConsumerState<CheckLoadingScreen> createState() => _CheckLoadingScreenState();
}

class _CheckLoadingScreenState extends ConsumerState<CheckLoadingScreen>
    with TickerProviderStateMixin {
  final List<_CheckStep> _steps = [
    _CheckStep('Checking DVLA records', const Duration(milliseconds: 500)),
    _CheckStep(
        'Searching finance databases', const Duration(milliseconds: 1000)),
    _CheckStep(
        'Checking stolen vehicle register', const Duration(milliseconds: 1500)),
    _CheckStep(
        'Verifying mileage history', const Duration(milliseconds: 2000)),
    _CheckStep(
        'Generating AI analysis', const Duration(milliseconds: 2500)),
  ];

  final List<bool> _completedSteps = [];
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    _completedSteps.addAll(List.filled(_steps.length, false));
    _runSteps();
  }

  Future<void> _runSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(_steps[i].delay - (i > 0 ? _steps[i - 1].delay : Duration.zero));
      if (!mounted) return;
      setState(() {
        _completedSteps[i] = true;
      });
    }

    // Small pause after the last step
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _allDone = true);

    // Perform the actual check
    try {
      final result = await ref
          .read(vehicleCheckRepositoryProvider)
          .performFullCheck(widget.registrationNumber);

      // Save to current check and recent
      ref.read(currentCheckProvider.notifier).state = result;
      ref.read(recentChecksProvider.notifier).addCheck(result);

      if (!mounted) return;
      context.go('/report/${widget.registrationNumber}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.red,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated car icon
              SizedBox(
                height: 80,
                child: Icon(
                  LucideIcons.car,
                  size: 56,
                  color: AppColors.primary,
                )
                    .animate(onPlay: (c) => c.repeat())
                    .slideX(
                      begin: -0.3,
                      end: 0.3,
                      duration: 1500.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .slideX(
                      begin: 0.3,
                      end: -0.3,
                      duration: 1500.ms,
                      curve: Curves.easeInOut,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // "Running your check..." text with animated dots
              _AnimatedDotsText(
                text: 'Running your check',
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.registrationNumber.toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiaryDark,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Progress steps
              ..._buildSteps(),

              const Spacer(flex: 3),

              // Bottom text
              if (_allDone)
                Text(
                  'Preparing your report...',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(duration: 400.ms)
              else
                Text(
                  'This usually takes a few seconds',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textTertiaryDark,
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSteps() {
    return List.generate(_steps.length, (index) {
      final isCompleted = _completedSteps[index];

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Row(
          children: [
            // Checkmark icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.emerald.withValues(alpha: 0.15)
                    : AppColors.darkSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.emerald
                      : AppColors.darkBorder,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        LucideIcons.check,
                        size: 14,
                        color: AppColors.emerald,
                      )
                        .animate()
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          duration: 300.ms,
                          curve: Curves.elasticOut,
                        )
                    : SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textTertiaryDark.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Step text
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight:
                      isCompleted ? FontWeight.w500 : FontWeight.w400,
                  color: isCompleted
                      ? AppColors.textPrimaryDark
                      : AppColors.textTertiaryDark,
                ),
                child: Text(_steps[index].label),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            duration: 400.ms,
            delay: Duration(milliseconds: index * 100),
          )
          .slideX(begin: -0.05, end: 0);
    });
  }
}

class _CheckStep {
  final String label;
  final Duration delay;

  const _CheckStep(this.label, this.delay);
}

// Animated dots widget
class _AnimatedDotsText extends StatefulWidget {
  final String text;

  const _AnimatedDotsText({required this.text});

  @override
  State<_AnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<_AnimatedDotsText> {
  int _dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _dotCount;
    final padding = ' ' * (3 - _dotCount);

    return Text(
      '${widget.text}$dots$padding',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryDark,
      ),
    );
  }
}
