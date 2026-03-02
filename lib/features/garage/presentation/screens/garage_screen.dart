import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../domain/entities/vehicle_check_entity.dart';

class GarageScreen extends ConsumerStatefulWidget {
  const GarageScreen({super.key});

  @override
  ConsumerState<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends ConsumerState<GarageScreen> {
  bool _isGridView = true;

  void _onVehicleTap(VehicleCheckResult vehicle) {
    ref.read(currentCheckProvider.notifier).state = vehicle;
    context.push('/report/${vehicle.registrationNumber}');
  }

  void _showDeleteDialog(VehicleCheckResult vehicle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Text(
          'Remove Vehicle',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        content: Text(
          'Remove ${vehicle.make} ${vehicle.model} (${vehicle.registrationNumber}) from your garage?',
          style: GoogleFonts.dmSans(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(savedChecksProvider.notifier)
                  .removeCheck(vehicle.registrationNumber);
              Navigator.pop(ctx);
            },
            child: Text(
              'Remove',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final savedChecks = ref.watch(savedChecksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Garage',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (savedChecks.isNotEmpty)
            IconButton(
              onPressed: () => setState(() => _isGridView = !_isGridView),
              icon: Icon(
                _isGridView ? LucideIcons.layoutGrid : LucideIcons.list,
                size: 22,
                color: textSecondary,
              ),
              tooltip: _isGridView ? 'Grid view' : 'List view',
            ),
        ],
      ),
      body: savedChecks.isEmpty
          ? _buildEmptyState(textPrimary, textSecondary, isDark)
          : _buildVehicleList(savedChecks, isDark, textPrimary, textSecondary),
      floatingActionButton: savedChecks.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => context.go('/check'),
              backgroundColor: AppColors.primary,
              child: const Icon(LucideIcons.plus, color: Colors.white),
            )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
          : null,
    );
  }

  Widget _buildEmptyState(
      Color textPrimary, Color textSecondary, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.car,
                size: 64,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Your garage is empty',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Save vehicles from your check results\nto track MOT and tax reminders',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: textSecondary,
                height: 1.5,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 250.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/check'),
                icon: const Icon(LucideIcons.search, size: 20),
                label: Text(
                  'Check a Vehicle',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                  elevation: 0,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 350.ms)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList(
    List<VehicleCheckResult> vehicles,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.72,
        ),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return _VehicleGridCard(
            vehicle: vehicle,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => _onVehicleTap(vehicle),
            onLongPress: () => _showDeleteDialog(vehicle),
          )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: (100 + index * 80).ms,
              )
              .slideY(
                begin: 0.08,
                end: 0,
                duration: 400.ms,
                delay: (100 + index * 80).ms,
                curve: Curves.easeOut,
              );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: vehicles.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return Dismissible(
          key: ValueKey(vehicle.registrationNumber),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: const Icon(LucideIcons.trash2, color: AppColors.red),
          ),
          confirmDismiss: (direction) async {
            _showDeleteDialog(vehicle);
            return false;
          },
          child: _VehicleListCard(
            vehicle: vehicle,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => _onVehicleTap(vehicle),
            onLongPress: () => _showDeleteDialog(vehicle),
          ),
        )
            .animate()
            .fadeIn(
              duration: 400.ms,
              delay: (100 + index * 80).ms,
            )
            .slideX(
              begin: 0.05,
              end: 0,
              duration: 400.ms,
              delay: (100 + index * 80).ms,
              curve: Curves.easeOut,
            );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Grid card
// ---------------------------------------------------------------------------

class _VehicleGridCard extends StatelessWidget {
  final VehicleCheckResult vehicle;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _VehicleGridCard({
    required this.vehicle,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    required this.onLongPress,
  });

  bool get _motValid =>
      vehicle.motHistory.tests.isNotEmpty &&
      vehicle.motHistory.tests.first.result == 'Pass';

  @override
  Widget build(BuildContext context) {
    final riskColor = AppColors.riskColor(vehicle.riskCategory);
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top icon section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.cardRadius),
                  topRight: Radius.circular(AppSpacing.cardRadius),
                ),
              ),
              child: Icon(
                LucideIcons.car,
                size: 36,
                color: riskColor.withValues(alpha: 0.7),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Registration plate
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.plateYellow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        vehicle.registrationNumber,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.plateBlack,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Make + Model
                    Text(
                      '${vehicle.make} ${vehicle.model}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Year & Colour
                    Text(
                      '${vehicle.year}  ·  ${vehicle.colour}',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Risk badge
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: riskColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          vehicle.riskCategory,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: riskColor,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // MOT & Tax chips
                    Row(
                      children: [
                        Expanded(
                          child: _StatusChip(
                            label: _motValid ? 'MOT Valid' : 'MOT Expired',
                            isPositive: _motValid,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: _StatusChip(
                            label: vehicle.taxStatus.isTaxed
                                ? 'Taxed'
                                : 'Not Taxed',
                            isPositive: vehicle.taxStatus.isTaxed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List card
// ---------------------------------------------------------------------------

class _VehicleListCard extends StatelessWidget {
  final VehicleCheckResult vehicle;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _VehicleListCard({
    required this.vehicle,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    required this.onLongPress,
  });

  bool get _motValid =>
      vehicle.motHistory.tests.isNotEmpty &&
      vehicle.motHistory.tests.first.result == 'Pass';

  @override
  Widget build(BuildContext context) {
    final riskColor = AppColors.riskColor(vehicle.riskCategory);
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            // Left icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                LucideIcons.car,
                size: 28,
                color: riskColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),

            // Middle info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plate
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.plateYellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vehicle.registrationNumber,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.plateBlack,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Make + Model
                  Text(
                    '${vehicle.make} ${vehicle.model}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Year, Colour, Risk
                  Row(
                    children: [
                      Text(
                        '${vehicle.year}  ·  ${vehicle.colour}',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: riskColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        vehicle.riskCategory,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: riskColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // MOT & Tax
                  Row(
                    children: [
                      _StatusChip(
                        label: _motValid ? 'MOT Valid' : 'MOT Expired',
                        isPositive: _motValid,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _StatusChip(
                        label: vehicle.taxStatus.isTaxed
                            ? 'Taxed'
                            : 'Not Taxed',
                        isPositive: vehicle.taxStatus.isTaxed,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status chip (MOT / Tax)
// ---------------------------------------------------------------------------

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isPositive;

  const _StatusChip({
    required this.label,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.emerald : AppColors.red;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
