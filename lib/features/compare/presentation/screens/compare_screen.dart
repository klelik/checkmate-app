import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../domain/entities/vehicle_check_entity.dart';

class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key});

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  final _regController = TextEditingController();

  @override
  void dispose() {
    _regController.dispose();
    super.dispose();
  }

  void _showVehicleSelector(int slot) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final savedChecks = ref.read(savedChecksProvider);

    _regController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.65,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.bottomSheetRadius),
              topRight: Radius.circular(AppSpacing.bottomSheetRadius),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding),
                child: Text(
                  'Select Vehicle ${slot == 1 ? "1" : "2"}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // New check input
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppSpacing.buttonRadius),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: TextField(
                          controller: _regController,
                          textCapitalization: TextCapitalization.characters,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                            letterSpacing: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter reg number',
                            hintStyle: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                            prefixIcon: Icon(
                              LucideIcons.search,
                              size: 18,
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: 14,
                            ),
                          ),
                          onSubmitted: (_) =>
                              _onNewCheck(ctx, slot),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => _onNewCheck(ctx, slot),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                              AppSpacing.buttonRadius),
                        ),
                        child: const Icon(
                          LucideIcons.arrowRight,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider with "or"
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md),
                      child: Text(
                        'or select from garage',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                  ],
                ),
              ),

              // Saved vehicles list
              if (savedChecks.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.car,
                        size: 32,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'No saved vehicles yet',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding),
                    itemCount: savedChecks.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, index) {
                      final v = savedChecks[index];
                      final riskColor =
                          AppColors.riskColor(v.riskCategory);
                      return GestureDetector(
                        onTap: () {
                          _setVehicle(slot, v);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: riskColor
                                      .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  LucideIcons.car,
                                  size: 20,
                                  color: riskColor,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${v.make} ${v.model}',
                                      style:
                                          GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${v.registrationNumber}  ·  ${v.year}',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 18,
                                color: isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _setVehicle(int slot, VehicleCheckResult vehicle) {
    if (slot == 1) {
      ref.read(compareVehicle1Provider.notifier).state = vehicle;
    } else {
      ref.read(compareVehicle2Provider.notifier).state = vehicle;
    }
  }

  Future<void> _onNewCheck(BuildContext ctx, int slot) async {
    final reg = _regController.text.trim().replaceAll(' ', '').toUpperCase();
    if (reg.isEmpty) return;

    Navigator.pop(ctx);

    try {
      final result = await ref
          .read(vehicleCheckRepositoryProvider)
          .performFullCheck(reg);
      _setVehicle(slot, result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not find vehicle: $reg'),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final vehicle1 = ref.watch(compareVehicle1Provider);
    final vehicle2 = ref.watch(compareVehicle2Provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compare Vehicles',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (vehicle1 != null || vehicle2 != null)
            IconButton(
              onPressed: () {
                ref.read(compareVehicle1Provider.notifier).state = null;
                ref.read(compareVehicle2Provider.notifier).state = null;
              },
              icon: Icon(
                LucideIcons.rotateCcw,
                size: 20,
                color: textSecondary,
              ),
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            // Vehicle selection row
            Row(
              children: [
                Expanded(
                  child: _VehicleSlotCard(
                    vehicle: vehicle1,
                    slotLabel: '1',
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onTap: () => _showVehicleSelector(1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.arrowLeftRight,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: _VehicleSlotCard(
                    vehicle: vehicle2,
                    slotLabel: '2',
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onTap: () => _showVehicleSelector(2),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.05, end: 0, curve: Curves.easeOut),

            const SizedBox(height: AppSpacing.xl),

            // Comparison content
            if (vehicle1 != null && vehicle2 != null)
              _ComparisonContent(
                vehicle1: vehicle1,
                vehicle2: vehicle2,
                isDark: isDark,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              )
            else if (vehicle1 != null || vehicle2 != null)
              _buildSingleVehicleMessage(isDark, textPrimary, textSecondary)
            else
              _buildEmptyMessage(isDark, textPrimary, textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleVehicleMessage(
      bool isDark, Color textPrimary, Color textSecondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.plusCircle,
            size: 40,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Select a second vehicle to compare',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tap the empty slot above to add another vehicle',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: textSecondary,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.05, end: 0);
  }

  Widget _buildEmptyMessage(
      bool isDark, Color textPrimary, Color textSecondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.gitCompare,
            size: 48,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Compare Two Vehicles',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Select two vehicles to see a side-by-side\ncomparison of their key details',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

// ---------------------------------------------------------------------------
// Vehicle slot card
// ---------------------------------------------------------------------------

class _VehicleSlotCard extends StatelessWidget {
  final VehicleCheckResult? vehicle;
  final String slotLabel;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _VehicleSlotCard({
    required this.vehicle,
    required this.slotLabel,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (vehicle != null) {
      return _buildFilledSlot();
    }
    return _buildEmptySlot();
  }

  Widget _buildEmptySlot() {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard.withValues(alpha: 0.5)
              : AppColors.lightCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: borderColor,
            width: 1.5,
            // Dashed border approximated via a dashed pattern isn't trivial
            // in Flutter; using a normal border with reduced opacity instead
          ),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: borderColor,
            radius: AppSpacing.cardRadius,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.plus,
                    size: 22,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Select Vehicle',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilledSlot() {
    final v = vehicle!;
    final riskColor = AppColors.riskColor(v.riskCategory);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: riskColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
                v.registrationNumber,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.plateBlack,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Make + Model
            Text(
              '${v.make} ${v.model}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),

            // Risk badge small
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
                  v.riskCategory,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: riskColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dashed border painter
// ---------------------------------------------------------------------------

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, end.clamp(0, metric.length)),
          paint,
        );
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Comparison content
// ---------------------------------------------------------------------------

class _ComparisonContent extends StatelessWidget {
  final VehicleCheckResult vehicle1;
  final VehicleCheckResult vehicle2;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  const _ComparisonContent({
    required this.vehicle1,
    required this.vehicle2,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  int get _v1LastMileage => vehicle1.mileageCheck.readings.isNotEmpty
      ? vehicle1.mileageCheck.readings.first.mileage
      : 0;

  int get _v2LastMileage => vehicle2.mileageCheck.readings.isNotEmpty
      ? vehicle2.mileageCheck.readings.first.mileage
      : 0;

  double get _v1PassRate {
    final tests = vehicle1.motHistory.tests;
    if (tests.isEmpty) return 0;
    final passes = tests.where((t) => t.result == 'Pass').length;
    return (passes / tests.length) * 100;
  }

  double get _v2PassRate {
    final tests = vehicle2.motHistory.tests;
    if (tests.isEmpty) return 0;
    final passes = tests.where((t) => t.result == 'Pass').length;
    return (passes / tests.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows();

    return Column(
      children: List.generate(rows.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: rows[i],
        )
            .animate()
            .fadeIn(
              duration: 400.ms,
              delay: (200 + i * 60).ms,
            )
            .slideY(
              begin: 0.05,
              end: 0,
              duration: 400.ms,
              delay: (200 + i * 60).ms,
              curve: Curves.easeOut,
            );
      }),
    );
  }

  List<Widget> _buildRows() {
    return [
      // 1. Risk Score
      _CompareRow(
        category: 'Risk Score',
        leftValue: '${vehicle1.overallRiskScore}',
        rightValue: '${vehicle2.overallRiskScore}',
        leftSubtitle: vehicle1.riskCategory,
        rightSubtitle: vehicle2.riskCategory,
        leftWidget: _RiskCircle(
          score: vehicle1.overallRiskScore,
          category: vehicle1.riskCategory,
        ),
        rightWidget: _RiskCircle(
          score: vehicle2.overallRiskScore,
          category: vehicle2.riskCategory,
        ),
        leftWins: vehicle1.overallRiskScore < vehicle2.overallRiskScore,
        rightWins: vehicle2.overallRiskScore < vehicle1.overallRiskScore,
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 2. Valuation
      _CompareRow(
        category: 'Valuation',
        leftValue:
            '\u00A3${_formatNumber(vehicle1.valuation.privateSale.round())}',
        rightValue:
            '\u00A3${_formatNumber(vehicle2.valuation.privateSale.round())}',
        leftWins:
            vehicle1.valuation.privateSale > vehicle2.valuation.privateSale,
        rightWins:
            vehicle2.valuation.privateSale > vehicle1.valuation.privateSale,
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 3. Mileage
      _CompareRow(
        category: 'Mileage',
        leftValue: '${_formatNumber(_v1LastMileage)} mi',
        rightValue: '${_formatNumber(_v2LastMileage)} mi',
        leftWins: _v1LastMileage < _v2LastMileage && _v1LastMileage > 0,
        rightWins: _v2LastMileage < _v1LastMileage && _v2LastMileage > 0,
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 4. MOT History
      _CompareRow(
        category: 'MOT History',
        leftValue: '${_v1PassRate.toStringAsFixed(0)}% pass',
        rightValue: '${_v2PassRate.toStringAsFixed(0)}% pass',
        leftWins: _v1PassRate > _v2PassRate,
        rightWins: _v2PassRate > _v1PassRate,
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 5. Keepers
      _CompareRow(
        category: 'Keepers',
        leftValue: '${vehicle1.keeperHistory.keeperCount}',
        rightValue: '${vehicle2.keeperHistory.keeperCount}',
        leftWins: vehicle1.keeperHistory.keeperCount <
            vehicle2.keeperHistory.keeperCount,
        rightWins: vehicle2.keeperHistory.keeperCount <
            vehicle1.keeperHistory.keeperCount,
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 6. Fuel Economy
      _CompareRow(
        category: 'Fuel Economy',
        leftValue: vehicle1.specs.fuelEconomyCombined != null
            ? '${vehicle1.specs.fuelEconomyCombined!.toStringAsFixed(1)} mpg'
            : 'N/A',
        rightValue: vehicle2.specs.fuelEconomyCombined != null
            ? '${vehicle2.specs.fuelEconomyCombined!.toStringAsFixed(1)} mpg'
            : 'N/A',
        leftWins: (vehicle1.specs.fuelEconomyCombined ?? 0) >
            (vehicle2.specs.fuelEconomyCombined ?? 0),
        rightWins: (vehicle2.specs.fuelEconomyCombined ?? 0) >
            (vehicle1.specs.fuelEconomyCombined ?? 0),
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 7. Insurance Group
      _CompareRow(
        category: 'Insurance Group',
        leftValue: vehicle1.specs.insuranceGroup ?? 'N/A',
        rightValue: vehicle2.specs.insuranceGroup ?? 'N/A',
        leftWins: _compareInsuranceGroups(
            vehicle1.specs.insuranceGroup, vehicle2.specs.insuranceGroup, true),
        rightWins: _compareInsuranceGroups(
            vehicle1.specs.insuranceGroup, vehicle2.specs.insuranceGroup, false),
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 8. Power (no winner)
      _CompareRow(
        category: 'Power',
        leftValue: vehicle1.specs.bhp != null
            ? '${vehicle1.specs.bhp!.toStringAsFixed(0)} bhp'
            : 'N/A',
        rightValue: vehicle2.specs.bhp != null
            ? '${vehicle2.specs.bhp!.toStringAsFixed(0)} bhp'
            : 'N/A',
        leftWins: false,
        rightWins: false,
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 9. Emissions
      _CompareRow(
        category: 'Emissions',
        leftValue: vehicle1.co2Emissions.isNotEmpty
            ? '${vehicle1.co2Emissions} g/km'
            : 'N/A',
        rightValue: vehicle2.co2Emissions.isNotEmpty
            ? '${vehicle2.co2Emissions} g/km'
            : 'N/A',
        leftWins: _compareCO2(vehicle1.co2Emissions, vehicle2.co2Emissions, true),
        rightWins: _compareCO2(vehicle1.co2Emissions, vehicle2.co2Emissions, false),
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),

      // 10. ULEZ
      _CompareRow(
        category: 'ULEZ',
        leftValue: vehicle1.ulezCompliant ? 'Compliant' : 'Non-compliant',
        rightValue: vehicle2.ulezCompliant ? 'Compliant' : 'Non-compliant',
        leftWidget: _UlezBadge(compliant: vehicle1.ulezCompliant),
        rightWidget: _UlezBadge(compliant: vehicle2.ulezCompliant),
        leftWins:
            vehicle1.ulezCompliant && !vehicle2.ulezCompliant,
        rightWins:
            vehicle2.ulezCompliant && !vehicle1.ulezCompliant,
        isDark: isDark,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),
    ];
  }

  bool _compareInsuranceGroups(
      String? left, String? right, bool checkLeftWins) {
    final leftNum = int.tryParse(left?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
    final rightNum =
        int.tryParse(right?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
    if (leftNum == null || rightNum == null) return false;
    return checkLeftWins ? leftNum < rightNum : rightNum < leftNum;
  }

  bool _compareCO2(String left, String right, bool checkLeftWins) {
    final leftNum = int.tryParse(left.replaceAll(RegExp(r'[^0-9]'), ''));
    final rightNum = int.tryParse(right.replaceAll(RegExp(r'[^0-9]'), ''));
    if (leftNum == null || rightNum == null) return false;
    return checkLeftWins ? leftNum < rightNum : rightNum < leftNum;
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final s = n.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
        buffer.write(s[i]);
      }
      return buffer.toString();
    }
    return n.toString();
  }
}

// ---------------------------------------------------------------------------
// Comparison row
// ---------------------------------------------------------------------------

class _CompareRow extends StatelessWidget {
  final String category;
  final String leftValue;
  final String rightValue;
  final String? leftSubtitle;
  final String? rightSubtitle;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final bool leftWins;
  final bool rightWins;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  const _CompareRow({
    required this.category,
    required this.leftValue,
    required this.rightValue,
    this.leftSubtitle,
    this.rightSubtitle,
    this.leftWidget,
    this.rightWidget,
    required this.leftWins,
    required this.rightWins,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          // Category header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.5)
                  : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.cardRadius),
                topRight: Radius.circular(AppSpacing.cardRadius),
              ),
            ),
            child: Text(
              category,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Values
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                // Left value
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: leftWins
                          ? AppColors.emerald.withValues(alpha: 0.06)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: leftWins
                          ? Border.all(
                              color:
                                  AppColors.emerald.withValues(alpha: 0.2),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        if (leftWidget != null) ...[
                          leftWidget!,
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        Text(
                          leftValue,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: leftWins
                                ? AppColors.emerald
                                : textPrimary,
                          ),
                        ),
                        if (leftSubtitle != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              leftSubtitle!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        if (leftWins)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: AppSpacing.xs),
                            child: Icon(
                              LucideIcons.trophy,
                              size: 14,
                              color: AppColors.emerald
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // "vs" divider
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm),
                  child: Text(
                    'vs',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                  ),
                ),

                // Right value
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: rightWins
                          ? AppColors.emerald.withValues(alpha: 0.06)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: rightWins
                          ? Border.all(
                              color:
                                  AppColors.emerald.withValues(alpha: 0.2),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        if (rightWidget != null) ...[
                          rightWidget!,
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        Text(
                          rightValue,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: rightWins
                                ? AppColors.emerald
                                : textPrimary,
                          ),
                        ),
                        if (rightSubtitle != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              rightSubtitle!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        if (rightWins)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: AppSpacing.xs),
                            child: Icon(
                              LucideIcons.trophy,
                              size: 14,
                              color: AppColors.emerald
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Risk circle indicator
// ---------------------------------------------------------------------------

class _RiskCircle extends StatelessWidget {
  final int score;
  final String category;

  const _RiskCircle({
    required this.score,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.riskColor(category);

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 4,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text(
            '$score',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ULEZ badge
// ---------------------------------------------------------------------------

class _UlezBadge extends StatelessWidget {
  final bool compliant;

  const _UlezBadge({required this.compliant});

  @override
  Widget build(BuildContext context) {
    final color = compliant ? AppColors.emerald : AppColors.red;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            compliant ? LucideIcons.checkCircle : LucideIcons.xCircle,
            size: 14,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            compliant ? 'ULEZ' : 'ULEZ',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
