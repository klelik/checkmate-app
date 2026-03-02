import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark theme base
  static const darkBg = Color(0xFF0F1117);
  static const darkSurface = Color(0xFF181B23);
  static const darkCard = Color(0xFF1E2130);
  static const darkBorder = Color(0xFF2A2D3A);

  // Light theme base
  static const lightBg = Color(0xFFF5F7FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE2E8F0);

  // Brand
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF1D4ED8);

  // Accents
  static const emerald = Color(0xFF10B981);
  static const emeraldLight = Color(0xFF34D399);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFBBF24);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFF87171);

  // Risk colors
  static const riskClear = Color(0xFF10B981);
  static const riskCaution = Color(0xFFF59E0B);
  static const riskHigh = Color(0xFFF97316);
  static const riskCritical = Color(0xFFEF4444);

  // Text
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const textTertiaryDark = Color(0xFF64748B);

  static const textPrimaryLight = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF475569);
  static const textTertiaryLight = Color(0xFF94A3B8);

  // UK Plate colors
  static const plateYellow = Color(0xFFFFD700);
  static const plateBlack = Color(0xFF1A1A1A);
  static const plateBlue = Color(0xFF003399);

  static Color riskColor(String category) {
    switch (category) {
      case 'Clear':
        return riskClear;
      case 'Caution':
        return riskCaution;
      case 'High Risk':
        return riskHigh;
      case 'Critical':
        return riskCritical;
      default:
        return riskClear;
    }
  }
}
