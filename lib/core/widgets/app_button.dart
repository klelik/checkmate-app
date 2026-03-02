import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum AppButtonVariant { primary, secondary, danger }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (_isEnabled) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (_isEnabled) _controller.reverse();
  }

  void _onTapCancel() {
    if (_isEnabled) _controller.reverse();
  }

  Color _backgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return brightness == Brightness.dark
            ? AppColors.red.withValues(alpha: 0.15)
            : AppColors.red.withValues(alpha: 0.1);
    }
  }

  Color _foregroundColor(BuildContext context) {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.danger:
        return AppColors.red;
    }
  }

  BorderSide? _borderSide(BuildContext context) {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return BorderSide.none;
      case AppButtonVariant.secondary:
        return const BorderSide(color: AppColors.primary, width: 1.5);
      case AppButtonVariant.danger:
        return BorderSide(color: AppColors.red.withValues(alpha: 0.4), width: 1.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _backgroundColor(context);
    final fgColor = _foregroundColor(context);
    final border = _borderSide(context);
    final disabledOpacity = _isEnabled ? 1.0 : 0.5;

    final buttonChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: widget.isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(fgColor),
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 20, color: fgColor),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  widget.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: fgColor,
                  ),
                ),
              ],
            ),
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _isEnabled ? widget.onPressed : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: disabledOpacity,
          child: Container(
            width: widget.fullWidth ? double.infinity : null,
            padding: EdgeInsets.symmetric(
              horizontal: widget.fullWidth ? AppSpacing.xl : AppSpacing.lg,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              border: border != null && border != BorderSide.none
                  ? Border.fromBorderSide(border)
                  : null,
            ),
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );
  }
}
