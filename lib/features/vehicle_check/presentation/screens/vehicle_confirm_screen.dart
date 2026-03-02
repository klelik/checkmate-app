import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../domain/entities/vehicle_check_entity.dart';

class VehicleConfirmScreen extends ConsumerWidget {
  final String registrationNumber;

  const VehicleConfirmScreen({
    super.key,
    required this.registrationNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Vehicle',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<VehicleCheckResult>(
          future: ref
              .read(vehicleCheckRepositoryProvider)
              .performBasicCheck(registrationNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmer(isDark);
            }

            if (snapshot.hasError) {
              return _buildError(context, isDark, snapshot.error.toString());
            }

            final vehicle = snapshot.data!;
            return _buildContent(context, isDark, vehicle);
          },
        ),
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          // Plate shimmer
          const ShimmerBox(height: 56),
          const SizedBox(height: AppSpacing.xl),
          // Card shimmer
          const ShimmerBox(height: 280),
          const SizedBox(height: AppSpacing.xl),
          // Buttons shimmer
          const ShimmerBox(height: 54),
          const SizedBox(height: AppSpacing.md),
          const ShimmerBox(height: 54),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, bool isDark, String error) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.alertTriangle,
                color: AppColors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Vehicle Not Found',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We couldn\'t find a vehicle with that registration. Please check and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: 'Try Again',
              icon: LucideIcons.arrowLeft,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isDark,
    VehicleCheckResult vehicle,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          // Registration plate display
          _buildPlateDisplay(vehicle.registrationNumber, isDark)
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.1, end: 0),
          const SizedBox(height: AppSpacing.xl),

          // Vehicle info card
          _buildVehicleCard(context, isDark, vehicle)
              .animate()
              .fadeIn(duration: 500.ms, delay: 150.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),

          // Confirmation text
          Text(
            'Is this your vehicle?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
          const SizedBox(height: AppSpacing.lg),

          // Buttons
          AppButton(
            label: 'Yes, check this vehicle',
            icon: LucideIcons.checkCircle,
            onPressed: () {
              context.push('/package-select/${vehicle.registrationNumber.replaceAll(' ', '')}');
            },
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'No, try again',
            icon: LucideIcons.arrowLeft,
            variant: AppButtonVariant.secondary,
            onPressed: () => context.pop(),
          ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildPlateDisplay(String reg, bool isDark) {
    // Format plate with space if not present (e.g., AB12CDE -> AB12 CDE)
    String displayReg = reg.toUpperCase();
    if (!displayReg.contains(' ') && displayReg.length >= 4) {
      displayReg =
          '${displayReg.substring(0, 4)} ${displayReg.substring(4)}';
    }

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
          // GB strip
          Container(
            width: 40,
            decoration: const BoxDecoration(
              color: AppColors.plateBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.globe, size: 14, color: Colors.white.withValues(alpha: 0.9)),
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
          Expanded(
            child: Center(
              child: Text(
                displayReg,
                style: GoogleFonts.dmSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.plateBlack,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context,
    bool isDark,
    VehicleCheckResult vehicle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          // Vehicle icon header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.cardRadius),
                topRight: Radius.circular(AppSpacing.cardRadius),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.car,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '${vehicle.make} ${vehicle.model}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${vehicle.year}',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Details grid
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Make',
                        vehicle.make,
                        LucideIcons.building2,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: _buildDetailItem(
                        'Model',
                        vehicle.model,
                        LucideIcons.car,
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Year',
                        '${vehicle.year}',
                        LucideIcons.calendar,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: _buildDetailItem(
                        'Colour',
                        vehicle.colour,
                        LucideIcons.palette,
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Fuel Type',
                        vehicle.fuelType,
                        LucideIcons.fuel,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: _buildDetailItem(
                        'Body Type',
                        vehicle.bodyType,
                        LucideIcons.car,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
