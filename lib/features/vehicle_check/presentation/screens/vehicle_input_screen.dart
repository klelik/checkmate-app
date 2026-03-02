import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/uk_plate_input.dart';
import '../../../../core/widgets/app_button.dart';

class VehicleInputScreen extends ConsumerStatefulWidget {
  const VehicleInputScreen({super.key});

  @override
  ConsumerState<VehicleInputScreen> createState() => _VehicleInputScreenState();
}

class _VehicleInputScreenState extends ConsumerState<VehicleInputScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _regController = TextEditingController();
  final _vinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _regController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final reg = _tabController.index == 0
        ? _regController.text.trim().replaceAll(' ', '')
        : _vinController.text.trim();

    if (reg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _tabController.index == 0
                ? 'Please enter a registration number'
                : 'Please enter a VIN number',
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
        ),
      );
      return;
    }

    context.push('/vehicle-confirm/$reg');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Check',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Check any vehicle',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Get a comprehensive history report in seconds',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: AppSpacing.xxl),

              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFEEF2F7),
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius - 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  unselectedLabelColor: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Registration'),
                    Tab(text: 'VIN'),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: AppSpacing.xl),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Registration tab
                    _buildRegistrationTab(isDark),
                    // VIN tab
                    _buildVinTab(isDark),
                  ],
                ),
              ),

              // Check Vehicle button
              AppButton(
                label: 'Check Vehicle',
                icon: LucideIcons.search,
                onPressed: _onSubmit,
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UK Plate input
        UKPlateInput(
          controller: _regController,
          onSubmitted: _onSubmit,
          onCameraTap: () {
            // Camera scan placeholder
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Helper text
        Row(
          children: [
            Icon(
              LucideIcons.info,
              size: 16,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Enter a UK registration number to check the vehicle\'s history',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Quick stats row
        _buildStatsRow(isDark),
      ],
    );
  }

  Widget _buildVinTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // VIN input
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: TextField(
            controller: _vinController,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              LengthLimitingTextInputFormatter(17),
              _UpperCaseFormatter(),
            ],
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              letterSpacing: 2,
            ),
            decoration: InputDecoration(
              hintText: 'Enter 17-character VIN',
              hintStyle: GoogleFonts.dmSans(
                fontSize: 16,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
              prefixIcon: Icon(
                LucideIcons.hash,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 20,
              ),
            ),
            onSubmitted: (_) => _onSubmit(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Helper text
        Row(
          children: [
            Icon(
              LucideIcons.info,
              size: 16,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'The VIN can be found on the dashboard, door frame, or V5C document',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        _buildStatItem(
          icon: LucideIcons.shieldCheck,
          value: '2M+',
          label: 'Checks run',
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.md),
        _buildStatItem(
          icon: LucideIcons.database,
          value: '100+',
          label: 'Data points',
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.md),
        _buildStatItem(
          icon: LucideIcons.clock,
          value: '<30s',
          label: 'Results',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
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
