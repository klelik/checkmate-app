import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../domain/entities/vehicle_check_entity.dart';

class ValuationScreen extends ConsumerStatefulWidget {
  final String registrationNumber;

  const ValuationScreen({super.key, required this.registrationNumber});

  @override
  ConsumerState<ValuationScreen> createState() => _ValuationScreenState();
}

class _ValuationScreenState extends ConsumerState<ValuationScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  String? _error;
  int _conditionIndex = 2; // 0=Poor, 1=Fair, 2=Good, 3=Very Good, 4=Excellent
  bool _barsAnimated = false;

  static const _conditionLabels = [
    'Poor',
    'Fair',
    'Good',
    'Very Good',
    'Excellent',
  ];

  static const _conditionMultipliers = [0.80, 0.90, 1.00, 1.05, 1.10];
  static const _conditionPercentLabels = ['-20%', '-10%', '0%', '+5%', '+10%'];

  @override
  void initState() {
    super.initState();
    _initCheck();
    Future.delayed(600.ms, () {
      if (mounted) setState(() => _barsAnimated = true);
    });
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
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Color helpers
  // ---------------------------------------------------------------------------

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _textPrimary =>
      _isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

  Color get _textSecondary =>
      _isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

  Color get _textTertiary =>
      _isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

  Color get _cardColor => _isDark ? AppColors.darkCard : AppColors.lightCard;

  Color get _borderColor =>
      _isDark ? AppColors.darkBorder : AppColors.lightBorder;

  Color get _surfaceColor =>
      _isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC);

  Color get _bgColor => _isDark ? AppColors.darkBg : AppColors.lightBg;

  // ---------------------------------------------------------------------------
  // Currency formatters
  // ---------------------------------------------------------------------------

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      final k = amount / 1000;
      final formatted = k.toStringAsFixed(1);
      if (formatted.endsWith('.0')) {
        return '\u00A3${formatted.replaceAll('.0', '')}k';
      }
      return '\u00A3${formatted}k';
    }
    return '\u00A3${amount.toStringAsFixed(0)}';
  }

  String _formatFullCurrency(double amount) {
    final whole = amount.toInt();
    return '\u00A3${whole.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';
  }

  // ---------------------------------------------------------------------------
  // Condition price
  // ---------------------------------------------------------------------------

  double _adjustedPrice(double basePrice) {
    return basePrice * _conditionMultipliers[_conditionIndex];
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoadingState();
    if (_error != null) return _buildErrorState();

    final check = ref.watch(currentCheckProvider);
    if (check == null) return _buildErrorState();

    return Scaffold(
      backgroundColor: _bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildVehicleInfoCard(check)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.lg),
                _buildEstimatedValueCard(check)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xxl),
                _buildConditionAdjuster(check)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xxl),
                _buildWhereToSell(check)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xxl),
                _buildPriceComparisonChart(check)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 400.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xxl),
                _buildPriceHistoryTrend(check)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 500.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xxl),
                _buildQuickSellActions()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 600.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xxl),
                _buildDisclaimer()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 700.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Loading / Error
  // ---------------------------------------------------------------------------

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
              'Loading valuation...',
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
                'Failed to load valuation',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _error ?? 'An unknown error occurred.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: _textSecondary,
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

  // ---------------------------------------------------------------------------
  // App Bar
  // ---------------------------------------------------------------------------

  SliverAppBar _buildSliverAppBar() {
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
        'Vehicle Valuation',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(LucideIcons.share2, color: _textSecondary),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Share valuation... (coming soon)'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Vehicle Info Card
  // ---------------------------------------------------------------------------

  Widget _buildVehicleInfoCard(VehicleCheckResult check) {
    final latestMileage = check.mileageCheck.readings.isNotEmpty
        ? check.mileageCheck.readings.last.mileage
        : 0;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            // UK Plate
            _buildCompactPlate(check.registrationNumber),
            const SizedBox(width: AppSpacing.lg),
            // Vehicle details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${check.make} ${check.model}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${check.year}  \u2022  ${check.colour}  \u2022  ${_formatMileage(latestMileage)} mi',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: _textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactPlate(String reg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.plateYellow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.plateBlack, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 22,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: AppColors.plateBlue,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow.shade600, size: 7),
                Text(
                  'UK',
                  style: GoogleFonts.dmSans(
                    fontSize: 5,
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
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.plateBlack,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMileage(int mileage) {
    return mileage.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  }

  // ---------------------------------------------------------------------------
  // 2. Estimated Value Hero Card
  // ---------------------------------------------------------------------------

  Widget _buildEstimatedValueCard(VehicleCheckResult check) {
    final basePrice = check.valuation.privateSale;
    final adjustedPrice = _adjustedPrice(basePrice);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDark
                ? [
                    const Color(0xFF1A2340),
                    const Color(0xFF162038),
                    const Color(0xFF1E2845),
                  ]
                : [
                    const Color(0xFFEFF6FF),
                    const Color(0xFFE0EDFF),
                    const Color(0xFFDBE8FE),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isDark
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: _isDark ? 0.15 : 0.08),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.trendingUp,
                  size: 16,
                  color: AppColors.emerald,
                ),
                const SizedBox(width: 6),
                Text(
                  'Estimated Value',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                _formatFullCurrency(adjustedPrice),
                key: ValueKey(adjustedPrice.toInt()),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: _textPrimary,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Based on current market data',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: _textTertiary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.emerald.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.refreshCw,
                    size: 12,
                    color: AppColors.emerald,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Updated today',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.emerald,
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

  // ---------------------------------------------------------------------------
  // 3. Condition Adjuster
  // ---------------------------------------------------------------------------

  Widget _buildConditionAdjuster(VehicleCheckResult check) {
    final basePrice = check.valuation.privateSale;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Adjust for your vehicle\'s condition'),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              children: [
                // Current condition label
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    key: ValueKey(_conditionIndex),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _conditionColor(_conditionIndex)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _conditionLabels[_conditionIndex],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _conditionColor(_conditionIndex),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Custom slider
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: _conditionColor(_conditionIndex),
                    inactiveTrackColor:
                        _conditionColor(_conditionIndex).withValues(alpha: 0.15),
                    thumbColor: Colors.white,
                    overlayColor:
                        _conditionColor(_conditionIndex).withValues(alpha: 0.12),
                    trackHeight: 6,
                    thumbShape: _PremiumThumbShape(
                      thumbRadius: 14,
                      ringColor: _conditionColor(_conditionIndex),
                    ),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 24),
                  ),
                  child: Slider(
                    value: _conditionIndex.toDouble(),
                    min: 0,
                    max: 4,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() => _conditionIndex = value.round());
                    },
                  ),
                ),
                // Condition labels below slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      final isSelected = i == _conditionIndex;
                      return Text(
                        _conditionLabels[i],
                        style: GoogleFonts.dmSans(
                          fontSize: i == 3 ? 9 : 10,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? _conditionColor(i)
                              : _textTertiary,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // Price adjustment indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _conditionColor(_conditionIndex)
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price adjustment',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: _textTertiary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              _conditionPercentLabels[_conditionIndex],
                              key: ValueKey(
                                  _conditionPercentLabels[_conditionIndex]),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _conditionColor(_conditionIndex),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Adjusted value',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: _textTertiary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              _formatFullCurrency(_adjustedPrice(basePrice)),
                              key: ValueKey(_adjustedPrice(basePrice).toInt()),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _conditionColor(int index) {
    switch (index) {
      case 0:
        return AppColors.red;
      case 1:
        return AppColors.amber;
      case 2:
        return AppColors.primary;
      case 3:
        return AppColors.emerald;
      case 4:
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.primary;
    }
  }

  // ---------------------------------------------------------------------------
  // 4. Where to Sell — Multi-Source Price Comparison
  // ---------------------------------------------------------------------------

  Widget _buildWhereToSell(VehicleCheckResult check) {
    final privateSale = _adjustedPrice(check.valuation.privateSale);
    final channels = _buildChannels(privateSale);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Where to sell'),
          const SizedBox(height: AppSpacing.lg),
          ...channels.map((ch) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildBuyerCard(ch, privateSale),
              )),
        ],
      ),
    );
  }

  List<_SellChannel> _buildChannels(double privateSale) {
    return [
      _SellChannel(
        name: 'Private Sale',
        icon: LucideIcons.user,
        price: privateSale,
        description:
            'Sell privately via AutoTrader, Gumtree, or Facebook Marketplace',
        color: AppColors.emerald,
      ),
      _SellChannel(
        name: 'We Buy Any Car',
        icon: LucideIcons.car,
        price: privateSale * 0.85,
        description: 'Instant offer, drive in and sell same day',
        color: AppColors.primary,
      ),
      _SellChannel(
        name: 'Dealer Part-Exchange',
        icon: LucideIcons.store,
        price: privateSale * 0.75,
        description: 'Trade in at a dealer when buying your next car',
        color: AppColors.amber,
      ),
      _SellChannel(
        name: 'Auction',
        icon: LucideIcons.gavel,
        price: privateSale * 0.70,
        description: 'Sell through BCA or Copart vehicle auction',
        color: _textTertiary,
      ),
      _SellChannel(
        name: 'Scrappage',
        icon: LucideIcons.recycle,
        price: min(300, privateSale * 0.05),
        description: 'Scrap value if vehicle is end of life',
        color: AppColors.red,
      ),
    ];
  }

  Widget _buildBuyerCard(_SellChannel channel, double maxPrice) {
    final barFraction = (channel.price / maxPrice).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: channel.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(channel.icon, size: 20, color: channel.color),
              ),
              const SizedBox(width: 12),
              // Name + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      channel.description,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: _textTertiary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Price
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _formatFullCurrency(channel.price),
                  key: ValueKey(channel.price.toInt()),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: channel.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bar indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  color: channel.color.withValues(alpha: 0.08),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  widthFactor: _barsAnimated ? barFraction : 0.0,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: channel.color,
                      borderRadius: BorderRadius.circular(4),
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

  // ---------------------------------------------------------------------------
  // 5. Price Comparison Bar Chart (custom horizontal bars)
  // ---------------------------------------------------------------------------

  Widget _buildPriceComparisonChart(VehicleCheckResult check) {
    final privateSale = _adjustedPrice(check.valuation.privateSale);
    final channels = _buildChannels(privateSale);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Price comparison'),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              children: channels.map((ch) {
                final barFraction =
                    (ch.price / privateSale).clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(
                          ch.name == 'Dealer Part-Exchange'
                              ? 'Part-Ex'
                              : ch.name,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Stack(
                            children: [
                              Container(
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _surfaceColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              AnimatedFractionallySizedBox(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.easeOutCubic,
                                widthFactor:
                                    _barsAnimated ? barFraction : 0.0,
                                child: Container(
                                  height: 28,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        ch.color.withValues(alpha: 0.7),
                                        ch.color,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.only(right: 8),
                                  child: barFraction > 0.3
                                      ? Text(
                                          _formatCurrency(ch.price),
                                          style: GoogleFonts.dmSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (barFraction <= 0.3)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            _formatCurrency(ch.price),
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Price History Trend
  // ---------------------------------------------------------------------------

  Widget _buildPriceHistoryTrend(VehicleCheckResult check) {
    final basePrice = check.valuation.privateSale;
    final adjustedBase = _adjustedPrice(basePrice);

    // Generate 6 months of historical data with slight depreciation
    final now = DateTime.now();
    final months = <String>[];
    final trendData = <FlSpot>[];

    for (int i = 0; i < 6; i++) {
      final monthsAgo = 5 - i;
      final date = DateTime(now.year, now.month - monthsAgo, 1);
      months.add(_monthAbbr(date.month));
      // Slight appreciation going back (meaning current is lowest = depreciation)
      final depreciation = 1.0 + (monthsAgo * 0.008);
      trendData.add(FlSpot(i.toDouble(), adjustedBase * depreciation));
    }

    // Projected 3 months
    final projectedData = <FlSpot>[];
    for (int i = 0; i < 3; i++) {
      final date = DateTime(now.year, now.month + i + 1, 1);
      months.add(_monthAbbr(date.month));
      final futureDepreciation = 1.0 - ((i + 1) * 0.006);
      projectedData.add(
          FlSpot((6 + i).toDouble(), adjustedBase * futureDepreciation));
    }

    final allSpots = [...trendData, ...projectedData];
    final minY =
        allSpots.map((s) => s.y).reduce(min) * 0.95;
    final maxY =
        allSpots.map((s) => s.y).reduce(max) * 1.03;

    // Determine trend direction
    final firstPrice = trendData.first.y;
    final lastPrice = trendData.last.y;
    final isDepreciating = lastPrice < firstPrice;
    final trendColor = isDepreciating ? AppColors.amber : AppColors.emerald;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Market price trend (6 months)'),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              children: [
                // Trend indicator
                Row(
                  children: [
                    Icon(
                      isDepreciating
                          ? LucideIcons.trendingDown
                          : LucideIcons.trendingUp,
                      size: 16,
                      color: trendColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isDepreciating
                          ? 'Depreciating ~${((1 - lastPrice / firstPrice) * 100).toStringAsFixed(1)}% over 6 months'
                          : 'Stable value over 6 months',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: trendColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: (maxY - minY) / 4,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: _borderColor.withValues(alpha: 0.5),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  _formatCurrency(value),
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    color: _textTertiary,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= months.length) {
                                return const SizedBox.shrink();
                              }
                              final isProjected = idx >= 6;
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  months[idx],
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    fontWeight: isProjected
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    color: isProjected
                                        ? _textTertiary.withValues(alpha: 0.5)
                                        : _textTertiary,
                                    fontStyle: isProjected
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: minY,
                      maxY: maxY,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (spot) =>
                              _isDark
                                  ? const Color(0xFF2A2D3A)
                                  : Colors.white,
                          tooltipBorder: BorderSide(color: _borderColor),
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final isProjected = spot.x >= 6;
                              return LineTooltipItem(
                                '${isProjected ? "(Projected) " : ""}${_formatFullCurrency(spot.y)}',
                                GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _textPrimary,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        // Historical line
                        LineChartBarData(
                          spots: trendData,
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: trendColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 2.5,
                                strokeColor: trendColor,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                trendColor.withValues(alpha: 0.15),
                                trendColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                        // Projected line (dashed)
                        LineChartBarData(
                          spots: [trendData.last, ...projectedData],
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: trendColor.withValues(alpha: 0.4),
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dashArray: [6, 4],
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) {
                              if (index == 0) {
                                return FlDotCirclePainter(
                                  radius: 0,
                                  color: Colors.transparent,
                                  strokeWidth: 0,
                                  strokeColor: Colors.transparent,
                                );
                              }
                              return FlDotCirclePainter(
                                radius: 3,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor:
                                    trendColor.withValues(alpha: 0.4),
                              );
                            },
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 800),
                  ),
                ),
                const SizedBox(height: 8),
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(trendColor, 'Actual', false),
                    const SizedBox(width: 20),
                    _buildLegendItem(
                        trendColor.withValues(alpha: 0.4), 'Projected', true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, bool isDashed) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: isDashed ? null : color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: isDashed
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        Container(
                            width: 6,
                            height: 3,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            )),
                        const SizedBox(width: 3),
                        Container(
                            width: 6,
                            height: 3,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            )),
                      ],
                    );
                  },
                )
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: _textTertiary,
          ),
        ),
      ],
    );
  }

  String _monthAbbr(int month) {
    const abbrs = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return abbrs[(month - 1) % 12];
  }

  // ---------------------------------------------------------------------------
  // 7. Quick Sell Actions
  // ---------------------------------------------------------------------------

  Widget _buildQuickSellActions() {
    final actions = [
      _QuickAction(
        name: 'We Buy Any Car',
        icon: LucideIcons.car,
        subtitle: 'Get instant quote',
        color: AppColors.primary,
      ),
      _QuickAction(
        name: 'Motorway',
        icon: LucideIcons.navigation,
        subtitle: 'Compare dealer offers',
        color: AppColors.emerald,
      ),
      _QuickAction(
        name: 'AutoTrader',
        icon: LucideIcons.megaphone,
        subtitle: 'List for sale',
        color: AppColors.amber,
      ),
    ];

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Ready to sell?'),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: actions.map((action) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: action != actions.last ? 10 : 0,
                  ),
                  child: _buildQuickActionCard(action),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(_QuickAction action) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${action.name}... (coming soon)'),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    action.color.withValues(alpha: 0.15),
                    action.color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(action.icon, size: 22, color: action.color),
            ),
            const SizedBox(height: 10),
            Text(
              action.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              action.subtitle,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: _textTertiary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Get Quote',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: action.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 8. Disclaimer
  // ---------------------------------------------------------------------------

  Widget _buildDisclaimer() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.info, size: 16, color: _textTertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Valuations are estimates based on current market data. '
                'Actual prices may vary depending on vehicle condition, '
                'service history, and local market conditions. '
                'Data sources: CAP HPI, Glass\'s Guide, AutoTrader.',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: _textTertiary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Common section title
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
      ),
    );
  }
}

// =============================================================================
// Custom slider thumb shape
// =============================================================================

class _PremiumThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final Color ringColor;

  const _PremiumThumbShape({
    required this.thumbRadius,
    required this.ringColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Outer glow
    final glowPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, thumbRadius + 4, glowPaint);

    // White fill
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, fillPaint);

    // Colored ring
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, thumbRadius - 1.5, ringPaint);

    // Inner dot
    final dotPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, dotPaint);
  }
}

// =============================================================================
// Animated fractionally sized box
// =============================================================================

class AnimatedFractionallySizedBox extends ImplicitlyAnimatedWidget {
  final double widthFactor;
  final Widget child;

  const AnimatedFractionallySizedBox({
    super.key,
    required this.widthFactor,
    required this.child,
    required super.duration,
    super.curve,
  });

  @override
  AnimatedFractionallySizedBoxState createState() =>
      AnimatedFractionallySizedBoxState();
}

class AnimatedFractionallySizedBoxState
    extends AnimatedWidgetBaseState<AnimatedFractionallySizedBox> {
  Tween<double>? _widthFactor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _widthFactor = visitor(
      _widthFactor,
      widget.widthFactor,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: _widthFactor?.evaluate(animation) ?? widget.widthFactor,
      child: widget.child,
    );
  }
}

// =============================================================================
// Data classes
// =============================================================================

class _SellChannel {
  final String name;
  final IconData icon;
  final double price;
  final String description;
  final Color color;

  const _SellChannel({
    required this.name,
    required this.icon,
    required this.price,
    required this.description,
    required this.color,
  });
}

class _QuickAction {
  final String name;
  final IconData icon;
  final String subtitle;
  final Color color;

  const _QuickAction({
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.color,
  });
}
