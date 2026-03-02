import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../domain/entities/vehicle_check_entity.dart';

class ReportScreen extends ConsumerStatefulWidget {
  final String registrationNumber;

  const ReportScreen({super.key, required this.registrationNumber});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  Future<void> _initCheck() async {
    final existing = ref.read(currentCheckProvider);
    if (existing != null &&
        existing.registrationNumber.toUpperCase() ==
            widget.registrationNumber.toUpperCase()) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await ref
          .read(vehicleCheckRepositoryProvider)
          .performFullCheck(widget.registrationNumber);
      ref.read(currentCheckProvider.notifier).state = result;
      ref.read(recentChecksProvider.notifier).addCheck(result);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _textPrimary =>
      _isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

  Color get _textSecondary =>
      _isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

  Color get _textTertiary =>
      _isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

  Color get _cardColor =>
      _isDark ? AppColors.darkCard : AppColors.lightCard;

  Color get _borderColor =>
      _isDark ? AppColors.darkBorder : AppColors.lightBorder;

  Color get _surfaceColor =>
      _isDark ? AppColors.darkSurface : AppColors.lightSurface;

  Color get _bgColor =>
      _isDark ? AppColors.darkBg : AppColors.lightBg;

  Color _riskScoreColor(int score) {
    if (score <= 25) return AppColors.riskClear;
    if (score <= 50) return AppColors.riskCaution;
    if (score <= 75) return AppColors.riskHigh;
    return AppColors.riskCritical;
  }

  String _formatCurrency(double amount) {
    final whole = amount.toInt();
    return '\u00A3${whole.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';
  }

  // -----------------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoadingState();
    if (_error != null) return _buildErrorState();

    final check = ref.watch(currentCheckProvider);
    if (check == null) return _buildErrorState();

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(check),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildRiskScoreHero(check)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                    _buildAISummary(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                    _buildQuickGlanceGrid(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                    _buildStolenSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildFinanceSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 350.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildWriteOffSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildMileageSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 450.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildMOTSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 500.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildKeeperSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 550.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildTaxSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 600.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildValuationSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 650.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildValuationCTA(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 680.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildSpecsSection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 700.ms)
                        .slideY(begin: 0.1, end: 0),
                    _buildSafetySection(check)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 750.ms)
                        .slideY(begin: 0.1, end: 0),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActions(check),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Loading / Error
  // -----------------------------------------------------------------------

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: _isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Loading report...',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: _isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: _isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.alertTriangle, size: 48, color: AppColors.red),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Failed to load report',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _error ?? 'An unknown error occurred.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: _isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _initCheck();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Sliver App Bar
  // -----------------------------------------------------------------------

  SliverAppBar _buildSliverAppBar(VehicleCheckResult check) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: _bgColor,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: _textPrimary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Vehicle Report',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(LucideIcons.moreVertical, color: _textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  // -----------------------------------------------------------------------
  // 1. Risk Score Hero
  // -----------------------------------------------------------------------

  Widget _buildRiskScoreHero(VehicleCheckResult check) {
    final score = check.overallRiskScore;
    final color = _riskScoreColor(score);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          // UK Plate style registration
          _buildUKPlate(check.registrationNumber),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${check.make} ${check.model} ${check.year}',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Circular risk score
          CircularPercentIndicator(
            radius: 80,
            lineWidth: 12,
            percent: (score / 100).clamp(0.0, 1.0),
            animation: true,
            animationDuration: 1200,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: color,
            backgroundColor: color.withValues(alpha: 0.12),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Risk Score',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Risk category badge
          _buildRiskBadge(check.riskCategory),
          const SizedBox(height: AppSpacing.sm),
          // Vehicle details row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDetailChip(LucideIcons.palette, check.colour),
              const SizedBox(width: AppSpacing.sm),
              _buildDetailChip(LucideIcons.fuel, check.fuelType),
              const SizedBox(width: AppSpacing.sm),
              _buildDetailChip(LucideIcons.cog, check.transmission),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUKPlate(String reg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.plateYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.plateBlack, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Blue strip
          Container(
            width: 24,
            height: 32,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: AppColors.plateBlue,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow.shade600, size: 10),
                Text(
                  'UK',
                  style: GoogleFonts.dmSans(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            reg.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.plateBlack,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBadge(String category) {
    final color = AppColors.riskColor(category);
    IconData icon;
    switch (category) {
      case 'Clear':
        icon = LucideIcons.shieldCheck;
        break;
      case 'Caution':
        icon = LucideIcons.alertTriangle;
        break;
      case 'High Risk':
        icon = LucideIcons.alertOctagon;
        break;
      case 'Critical':
        icon = LucideIcons.shieldAlert;
        break;
      default:
        icon = LucideIcons.helpCircle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(
            category,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _textTertiary),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------
  // AI Summary
  // -----------------------------------------------------------------------

  Widget _buildAISummary(VehicleCheckResult check) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: _isDark ? 0.12 : 0.06),
              AppColors.primaryLight.withValues(alpha: _isDark ? 0.06 : 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'AI Summary',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              check.aiSummary,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _textPrimary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // 2. Quick Glance Grid
  // -----------------------------------------------------------------------

  Widget _buildQuickGlanceGrid(VehicleCheckResult check) {
    final items = <_QuickGlanceItem>[
      _QuickGlanceItem(
        label: 'Stolen',
        status: check.stolenCheck.isStolen ? _QGStatus.alert : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'Finance',
        status: check.financeCheck.hasFinance
            ? _QGStatus.caution
            : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'Write-off',
        status: check.writeOffCheck.isWriteOff
            ? _QGStatus.alert
            : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'Mileage',
        status: check.mileageCheck.hasDiscrepancy
            ? _QGStatus.caution
            : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'Keepers',
        status: check.keeperHistory.keeperCount > 3
            ? _QGStatus.caution
            : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'Plates',
        status: check.plateChanges.hasChanges
            ? _QGStatus.caution
            : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'Import',
        status: check.importExport.isImported
            ? _QGStatus.caution
            : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'Scrapped',
        status: check.scrappedCheck.isScrapped
            ? _QGStatus.alert
            : _QGStatus.clear,
      ),
      _QuickGlanceItem(
        label: 'V5C',
        status: _QGStatus.clear,
      ),
    ];

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Glance',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildQuickGlanceItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickGlanceItem(_QuickGlanceItem item) {
    Color color;
    IconData icon;
    switch (item.status) {
      case _QGStatus.clear:
        color = AppColors.riskClear;
        icon = LucideIcons.checkCircle2;
        break;
      case _QGStatus.caution:
        color = AppColors.riskCaution;
        icon = LucideIcons.alertTriangle;
        break;
      case _QGStatus.alert:
        color = AppColors.riskCritical;
        icon = LucideIcons.xCircle;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            border:
                Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
          ),
          child: Center(
            child: Icon(icon, size: 22, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------------------
  // 3. Expandable Detail Sections
  // -----------------------------------------------------------------------

  // -- Stolen ---------------------------------------------------------------

  Widget _buildStolenSection(VehicleCheckResult check) {
    final stolen = check.stolenCheck;
    return _buildExpandableSection(
      icon: LucideIcons.shieldAlert,
      title: 'Stolen Check',
      statusColor: stolen.isStolen ? AppColors.riskCritical : AppColors.riskClear,
      statusLabel: stolen.isStolen ? 'Alert' : 'Clear',
      initiallyExpanded: stolen.isStolen,
      child: stolen.isStolen
          ? _buildAlertCard(
              color: AppColors.riskCritical,
              icon: LucideIcons.shieldAlert,
              title: 'Vehicle Recorded as Stolen',
              rows: [
                if (stolen.dateReported != null)
                  _DetailRow('Date Reported', stolen.dateReported!),
                if (stolen.policeForce != null)
                  _DetailRow('Police Force', stolen.policeForce!),
                if (stolen.referenceNumber != null)
                  _DetailRow('Reference', stolen.referenceNumber!),
              ],
            )
          : _buildClearCard(
              'This vehicle is not recorded as stolen on the Police National Computer.'),
    );
  }

  // -- Finance --------------------------------------------------------------

  Widget _buildFinanceSection(VehicleCheckResult check) {
    final finance = check.financeCheck;
    return _buildExpandableSection(
      icon: LucideIcons.banknote,
      title: 'Finance Check',
      statusColor:
          finance.hasFinance ? AppColors.riskCaution : AppColors.riskClear,
      statusLabel: finance.hasFinance ? 'Caution' : 'Clear',
      initiallyExpanded: finance.hasFinance,
      child: finance.hasFinance
          ? _buildAlertCard(
              color: AppColors.riskCaution,
              icon: LucideIcons.alertTriangle,
              title: 'Outstanding Finance Recorded',
              rows: [
                if (finance.agreementType != null)
                  _DetailRow('Agreement Type', finance.agreementType!),
                if (finance.financeCompany != null)
                  _DetailRow('Finance Company', finance.financeCompany!),
                if (finance.amountOutstanding != null)
                  _DetailRow('Amount Outstanding',
                      _formatCurrency(finance.amountOutstanding!)),
                if (finance.startDate != null)
                  _DetailRow('Start Date', finance.startDate!),
                if (finance.contactNumber != null)
                  _DetailRow('Contact', finance.contactNumber!),
              ],
            )
          : _buildClearCard('No outstanding finance recorded against this vehicle.'),
    );
  }

  // -- Write-off ------------------------------------------------------------

  Widget _buildWriteOffSection(VehicleCheckResult check) {
    final wo = check.writeOffCheck;
    String? categoryDescription;
    if (wo.category != null) {
      switch (wo.category) {
        case 'S':
          categoryDescription =
              'Category S - Structural damage, repairable';
          break;
        case 'N':
          categoryDescription =
              'Category N - Non-structural damage, repairable';
          break;
        case 'A':
          categoryDescription = 'Category A - Scrap only, cannot be repaired';
          break;
        case 'B':
          categoryDescription =
              'Category B - Body shell must be crushed, parts may be salvaged';
          break;
        default:
          categoryDescription = 'Category ${wo.category}';
      }
    }

    return _buildExpandableSection(
      icon: LucideIcons.car,
      title: 'Write-off Check',
      statusColor: wo.isWriteOff ? AppColors.riskCritical : AppColors.riskClear,
      statusLabel: wo.isWriteOff ? 'Alert' : 'Clear',
      initiallyExpanded: wo.isWriteOff,
      child: wo.isWriteOff
          ? _buildAlertCard(
              color: AppColors.riskCritical,
              icon: LucideIcons.alertOctagon,
              title: 'Insurance Write-off Recorded',
              rows: [
                if (categoryDescription != null)
                  _DetailRow('Category', categoryDescription),
                if (wo.date != null) _DetailRow('Date', wo.date!),
                if (wo.insurer != null) _DetailRow('Insurer', wo.insurer!),
                if (wo.damageArea != null)
                  _DetailRow('Damage Area', wo.damageArea!),
              ],
            )
          : _buildClearCard(
              'No insurance write-off recorded for this vehicle.'),
    );
  }

  // -- Mileage --------------------------------------------------------------

  Widget _buildMileageSection(VehicleCheckResult check) {
    final mileage = check.mileageCheck;
    final readings = mileage.readings;
    final hasDiscrepancy = mileage.hasDiscrepancy;

    return _buildExpandableSection(
      icon: LucideIcons.gauge,
      title: 'Mileage Analysis',
      statusColor:
          hasDiscrepancy ? AppColors.riskCaution : AppColors.riskClear,
      statusLabel: hasDiscrepancy ? 'Discrepancy' : 'Consistent',
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDiscrepancy)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.riskCaution.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(
                  color: AppColors.riskCaution.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertTriangle,
                      size: 18, color: AppColors.riskCaution),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Mileage discrepancy detected in the readings below.',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.riskCaution,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Mileage chart
          if (readings.length >= 2)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: _borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mileage Over Time',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: _calculateMileageInterval(readings),
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: _borderColor,
                            strokeWidth: 0.8,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= readings.length) {
                                  return const SizedBox.shrink();
                                }
                                // Show first, last, and middle
                                if (readings.length <= 5 ||
                                    idx == 0 ||
                                    idx == readings.length - 1 ||
                                    idx == readings.length ~/ 2) {
                                  final date = readings[idx].date;
                                  final short = date.length >= 7
                                      ? date.substring(0, 7)
                                      : date;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      short,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10,
                                        color: _textTertiary,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              interval: _calculateMileageInterval(readings),
                              getTitlesWidget: (value, meta) {
                                final k = (value / 1000).round();
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(
                                    '${k}k',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 10,
                                      color: _textTertiary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: readings
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                      e.key.toDouble(),
                                      e.value.mileage.toDouble(),
                                    ))
                                .toList(),
                            isCurved: true,
                            color: hasDiscrepancy
                                ? AppColors.red
                                : AppColors.emerald,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, bar, index) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: hasDiscrepancy
                                    ? AppColors.red
                                    : AppColors.emerald,
                                strokeWidth: 2,
                                strokeColor: _cardColor,
                              ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: (hasDiscrepancy
                                      ? AppColors.red
                                      : AppColors.emerald)
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => _cardColor,
                            tooltipBorder:
                                BorderSide(color: _borderColor, width: 1),
                            tooltipRoundedRadius: 8,
                            getTooltipItems: (spots) {
                              return spots.map((spot) {
                                final idx = spot.spotIndex;
                                final reading = readings[idx];
                                return LineTooltipItem(
                                  '${reading.date}\n',
                                  GoogleFonts.dmSans(
                                    fontSize: 11,
                                    color: _textTertiary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${_formatMileage(reading.mileage)} mi',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: _textPrimary,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          // Average miles
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.trendingUp, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Average miles per year:',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _formatMileage(mileage.averagePerYear),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Readings list
          Text(
            'All Readings',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...readings.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    border: Border.all(color: _borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.date,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                            ),
                            Text(
                              r.source,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: _textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${_formatMileage(r.mileage)} mi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  double _calculateMileageInterval(List<MileageReading> readings) {
    if (readings.isEmpty) return 10000;
    final maxM = readings
        .map((r) => r.mileage)
        .reduce((a, b) => a > b ? a : b);
    final minM = readings
        .map((r) => r.mileage)
        .reduce((a, b) => a < b ? a : b);
    final range = (maxM - minM).toDouble();
    if (range <= 10000) return 2000;
    if (range <= 50000) return 10000;
    if (range <= 100000) return 20000;
    return 50000;
  }

  String _formatMileage(int mileage) {
    return mileage
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  }

  // -- MOT ------------------------------------------------------------------

  Widget _buildMOTSection(VehicleCheckResult check) {
    final tests = check.motHistory.tests;

    return _buildExpandableSection(
      icon: LucideIcons.clipboardCheck,
      title: 'MOT History',
      statusColor: AppColors.primary,
      statusLabel: '${tests.length} tests',
      initiallyExpanded: false,
      child: tests.isEmpty
          ? _buildClearCard('No MOT history available for this vehicle.')
          : Column(
              children: tests.asMap().entries.map((entry) {
                final i = entry.key;
                final test = entry.value;
                final isPass = test.result.toLowerCase() == 'pass';
                final isLast = i == tests.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline visual
                      SizedBox(
                        width: 32,
                        child: Column(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isPass
                                    ? AppColors.riskClear
                                    : AppColors.riskCritical,
                                border: Border.all(
                                  color: (isPass
                                          ? AppColors.riskClear
                                          : AppColors.riskCritical)
                                      .withValues(alpha: 0.4),
                                  width: 3,
                                ),
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: _borderColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // Test card
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: _surfaceColor,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.sm),
                            border:
                                Border.all(color: _borderColor, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    test.date,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: (isPass
                                              ? AppColors.riskClear
                                              : AppColors.riskCritical)
                                          .withValues(alpha: 0.12),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      test.result.toUpperCase(),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isPass
                                            ? AppColors.riskClear
                                            : AppColors.riskCritical,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Row(
                                children: [
                                  _buildMOTDetail(
                                      'Mileage', '${_formatMileage(test.mileage)} mi'),
                                  const SizedBox(width: AppSpacing.lg),
                                  if (test.expiryDate != null)
                                    _buildMOTDetail(
                                        'Expires', test.expiryDate!),
                                ],
                              ),
                              if (test.advisories.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.sm),
                                _buildMOTItemList(
                                  'Advisories',
                                  test.advisories,
                                  AppColors.riskCaution,
                                  LucideIcons.alertTriangle,
                                ),
                              ],
                              if (test.failures.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.sm),
                                _buildMOTItemList(
                                  'Failures',
                                  test.failures,
                                  AppColors.riskCritical,
                                  LucideIcons.xCircle,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildMOTDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 10, color: _textTertiary),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMOTItemList(
      String title, List<String> items, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              '$title (${items.length})',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: _textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // -- Keepers --------------------------------------------------------------

  Widget _buildKeeperSection(VehicleCheckResult check) {
    final keeper = check.keeperHistory;

    return _buildExpandableSection(
      icon: LucideIcons.users,
      title: 'Keeper History',
      statusColor:
          keeper.keeperCount > 3 ? AppColors.riskCaution : AppColors.riskClear,
      statusLabel: '${keeper.keeperCount} keepers',
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keeper count hero
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Text(
                      '${keeper.keeperCount}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Previous Keepers',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        keeper.keeperCount <= 3
                            ? 'Within typical range'
                            : 'Higher than average',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: _textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (keeper.changes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            ...keeper.changes.asMap().entries.map((entry) {
              final i = entry.key;
              final change = entry.value;
              final isLast = i == keeper.changes.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      child: Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: _borderColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                          border: Border.all(color: _borderColor, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Keeper ${i + 1}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _textPrimary,
                                  ),
                                ),
                                Text(
                                  'Acquired ${change.date}',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: _textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                change.duration,
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  // -- Tax ------------------------------------------------------------------

  Widget _buildTaxSection(VehicleCheckResult check) {
    final tax = check.taxStatus;

    return _buildExpandableSection(
      icon: LucideIcons.receipt,
      title: 'Tax Status',
      statusColor: tax.isTaxed ? AppColors.riskClear : AppColors.riskCaution,
      statusLabel: tax.isTaxed ? 'Taxed' : 'Not Taxed',
      initiallyExpanded: false,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: (tax.isTaxed ? AppColors.riskClear : AppColors.riskCaution)
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(
                color:
                    (tax.isTaxed ? AppColors.riskClear : AppColors.riskCaution)
                        .withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (tax.isTaxed
                            ? AppColors.riskClear
                            : AppColors.riskCaution)
                        .withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Icon(
                      tax.isTaxed
                          ? LucideIcons.checkCircle2
                          : LucideIcons.alertTriangle,
                      size: 22,
                      color: tax.isTaxed
                          ? AppColors.riskClear
                          : AppColors.riskCaution,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    tax.isTaxed ? 'Vehicle is taxed' : 'Vehicle is not taxed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: tax.isTaxed
                          ? AppColors.riskClear
                          : AppColors.riskCaution,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDetailGrid([
            if (tax.expiryDate != null)
              _DetailRow('Expires', tax.expiryDate!),
            if (tax.annualCost != null)
              _DetailRow('Annual Cost', _formatCurrency(tax.annualCost!)),
            if (tax.band != null) _DetailRow('Tax Band', tax.band!),
            if (tax.rate != null) _DetailRow('Rate', tax.rate!),
          ]),
        ],
      ),
    );
  }

  // -- Valuation ------------------------------------------------------------

  Widget _buildValuationSection(VehicleCheckResult check) {
    final val = check.valuation;

    return _buildExpandableSection(
      icon: LucideIcons.poundSterling,
      title: 'Valuation',
      statusColor: AppColors.primary,
      statusLabel: val.confidenceLevel,
      initiallyExpanded: false,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildValuationCard(
                  'Trade-in',
                  val.tradeIn,
                  LucideIcons.arrowLeftRight,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildValuationCard(
                  'Private Sale',
                  val.privateSale,
                  LucideIcons.user,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildValuationCard(
                  'Dealer',
                  val.dealer,
                  LucideIcons.store,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.barChart2, size: 14, color: _textTertiary),
                const SizedBox(width: 6),
                Text(
                  'Confidence: ${val.confidenceLevel}',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuationCard(String label, double price, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _formatCurrency(price),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: _textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // -- Specifications -------------------------------------------------------

  Widget _buildSpecsSection(VehicleCheckResult check) {
    final specs = check.specs;

    return _buildExpandableSection(
      icon: LucideIcons.settings2,
      title: 'Specifications',
      statusColor: AppColors.primary,
      statusLabel: '${check.engineSizeCC}cc',
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecGroup('Performance', [
            if (specs.bhp != null)
              _DetailRow('BHP', '${specs.bhp!.toStringAsFixed(0)} bhp'),
            if (specs.torque != null) _DetailRow('Torque', specs.torque!),
            if (specs.zeroToSixty != null)
              _DetailRow('0-60 mph', '${specs.zeroToSixty!.toStringAsFixed(1)}s'),
            if (specs.topSpeed != null)
              _DetailRow(
                  'Top Speed', '${specs.topSpeed!.toStringAsFixed(0)} mph'),
          ]),
          const SizedBox(height: AppSpacing.md),
          _buildSpecGroup('Economy', [
            if (specs.fuelEconomyUrban != null)
              _DetailRow(
                  'Urban', '${specs.fuelEconomyUrban!.toStringAsFixed(1)} mpg'),
            if (specs.fuelEconomyCombined != null)
              _DetailRow('Combined',
                  '${specs.fuelEconomyCombined!.toStringAsFixed(1)} mpg'),
            if (specs.fuelEconomyExtraUrban != null)
              _DetailRow('Extra-Urban',
                  '${specs.fuelEconomyExtraUrban!.toStringAsFixed(1)} mpg'),
          ]),
          const SizedBox(height: AppSpacing.md),
          _buildSpecGroup('Dimensions', [
            if (specs.length != null)
              _DetailRow('Length', '${specs.length!.toStringAsFixed(0)} mm'),
            if (specs.width != null)
              _DetailRow('Width', '${specs.width!.toStringAsFixed(0)} mm'),
            if (specs.height != null)
              _DetailRow('Height', '${specs.height!.toStringAsFixed(0)} mm'),
            if (specs.weight != null)
              _DetailRow('Weight', '${specs.weight!.toStringAsFixed(0)} kg'),
          ]),
          const SizedBox(height: AppSpacing.md),
          _buildSpecGroup('Other', [
            if (specs.insuranceGroup != null)
              _DetailRow('Insurance Group', specs.insuranceGroup!),
            if (specs.doors != null)
              _DetailRow('Doors', '${specs.doors}'),
            if (specs.seats != null)
              _DetailRow('Seats', '${specs.seats}'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSpecGroup(String title, List<_DetailRow> rows) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildDetailGrid(rows),
      ],
    );
  }

  // -- Safety ---------------------------------------------------------------

  Widget _buildSafetySection(VehicleCheckResult check) {
    final rating = check.euroNcapRating;
    final recalls = check.safetyRecall;

    return _buildExpandableSection(
      icon: LucideIcons.shield,
      title: 'Safety',
      statusColor: recalls.hasRecalls
          ? AppColors.riskCaution
          : AppColors.riskClear,
      statusLabel: recalls.hasRecalls
          ? '${recalls.recalls.length} recalls'
          : '$rating stars',
      initiallyExpanded: recalls.hasRecalls,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Euro NCAP stars
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: Column(
              children: [
                Text(
                  'Euro NCAP Rating',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < rating;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Icon(
                        filled ? LucideIcons.star : LucideIcons.star,
                        size: 28,
                        color: filled
                            ? AppColors.amber
                            : _borderColor,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$rating out of 5',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (recalls.hasRecalls) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Recall Alerts',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...recalls.recalls.map((recall) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.riskCaution.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    border: Border.all(
                      color: AppColors.riskCaution.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recall.date,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _textSecondary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: recall.status.toLowerCase() == 'completed'
                                  ? AppColors.riskClear.withValues(alpha: 0.12)
                                  : AppColors.riskCaution
                                      .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              recall.status,
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: recall.status.toLowerCase() ==
                                        'completed'
                                    ? AppColors.riskClear
                                    : AppColors.riskCaution,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        recall.description,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: _textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            _buildClearCard('No safety recalls recorded for this vehicle.'),
          ],
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Expandable Section Wrapper
  // -----------------------------------------------------------------------

  Widget _buildExpandableSection({
    required IconData icon,
    required String title,
    required Color statusColor,
    required String statusLabel,
    required Widget child,
    bool initiallyExpanded = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            tilePadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            childrenPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(icon, size: 18, color: statusColor),
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: _textTertiary,
                ),
              ],
            ),
            children: [child],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Shared card widgets
  // -----------------------------------------------------------------------

  Widget _buildClearCard(String message) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.riskClear.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: AppColors.riskClear.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.checkCircle2, size: 20, color: AppColors.riskClear),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.riskClear,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required Color color,
    required IconData icon,
    required String title,
    required List<_DetailRow> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (rows.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            ...rows.map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          row.label,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: color.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row.value,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailGrid(List<_DetailRow> rows) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final i = entry.key;
          final row = entry.value;
          final isLast = i == rows.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(bottom: BorderSide(color: _borderColor, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  row.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: _textTertiary,
                  ),
                ),
                Flexible(
                  child: Text(
                    row.value,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // -- Valuation CTA --------------------------------------------------------

  Widget _buildValuationCTA(VehicleCheckResult check) {
    final val = check.valuation;
    return GestureDetector(
      onTap: () => context.push(
        '/valuation/${check.registrationNumber.replaceAll(' ', '')}',
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.emerald.withValues(alpha: 0.15),
              AppColors.primary.withValues(alpha: 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: AppColors.emerald.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.poundSterling,
                      color: AppColors.emerald,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thinking of selling?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'See what your car is worth across multiple buyers',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  _buildMiniPrice('We Buy Any Car', val.privateSale * 0.85),
                  const SizedBox(width: AppSpacing.sm),
                  _buildMiniPrice('Private Sale', val.privateSale),
                  const SizedBox(width: AppSpacing.sm),
                  _buildMiniPrice('Dealer', val.dealer),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.emerald,
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.trendingUp,
                        size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Get Full Valuation',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(LucideIcons.arrowRight,
                        size: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniPrice(String label, double price) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: _cardColor.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _formatCurrency(price),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.emerald,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: _textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Bottom Actions Bar
  // -----------------------------------------------------------------------

  Widget _buildBottomActions(VehicleCheckResult check) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border(top: BorderSide(color: _borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: LucideIcons.bookmark,
            label: 'Save',
            onTap: () {
              ref.read(savedChecksProvider.notifier).addCheck(check);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Saved to your garage',
                    style: GoogleFonts.dmSans(),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: AppColors.emerald,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActionButton(
            icon: LucideIcons.share2,
            label: 'Share',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Share functionality coming soon',
                    style: GoogleFonts.dmSans(),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActionButton(
            icon: LucideIcons.poundSterling,
            label: 'Value',
            highlight: true,
            onTap: () {
              context.push(
                '/valuation/${check.registrationNumber.replaceAll(' ', '')}',
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActionButton(
            icon: LucideIcons.fileText,
            label: 'PDF',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'PDF export coming soon',
                    style: GoogleFonts.dmSans(),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActionButton(
            icon: LucideIcons.gitCompare,
            label: 'Compare',
            onTap: () {
              ref.read(compareVehicle1Provider.notifier).state = check;
              context.go('/compare');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: highlight
                ? AppColors.emerald.withValues(alpha: 0.1)
                : _surfaceColor,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(
              color: highlight
                  ? AppColors.emerald.withValues(alpha: 0.4)
                  : _borderColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 20,
                  color: highlight ? AppColors.emerald : AppColors.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: highlight ? AppColors.emerald : _textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal helper classes
// ---------------------------------------------------------------------------

enum _QGStatus { clear, caution, alert }

class _QuickGlanceItem {
  final String label;
  final _QGStatus status;

  const _QuickGlanceItem({required this.label, required this.status});
}

class _DetailRow {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);
}
