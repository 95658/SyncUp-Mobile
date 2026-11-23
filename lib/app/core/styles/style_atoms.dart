import 'package:flutter/material.dart';
import 'package:syncup/app/core/themes/app_colors.dart';

extension StyleAtoms on BuildContext {
  // 10px
  TextStyle get roman10Muted => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      );
  TextStyle get medium10Muted => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );
  TextStyle get bold10Primary => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      );
  TextStyle get bold10Success => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppColors.success,
      );

  // 12px & 13px
  TextStyle get roman12TextMain => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textMain,
      );
  TextStyle get roman12Muted => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      );
  TextStyle get roman12Secondary => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );
  TextStyle get roman13Secondary => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );
  TextStyle get medium12TextMain => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMain,
      );
  TextStyle get medium12Primary => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      );
  TextStyle get medium12Danger => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.danger,
      );
  TextStyle get bold12TextMain => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      );

  // 14px
  TextStyle get light14White => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: AppColors.textInverse,
      );
  TextStyle get roman14TextMain => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textMain,
      );
  TextStyle get roman14Secondary => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );
  TextStyle get roman14Muted => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      );
  TextStyle get roman14Primary => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.primary,
      );
  TextStyle get medium14TextMain => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textMain,
      );
  TextStyle get medium14White => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textInverse,
      );
  TextStyle get medium14Primary => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      );
  TextStyle get bold14TextMain => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      );

  // 16px
  TextStyle get roman16TextMain => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textMain,
      );
  TextStyle get medium16TextMain => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textMain,
      );
  TextStyle get medium16White => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textInverse,
      );
  TextStyle get bold16TextMain => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      );
  TextStyle get bold16Primary => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      );

  // 18px & Headers
  TextStyle get medium18TextMain => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textMain,
      );
  TextStyle get bold18TextMain => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      );
  TextStyle get bold20TextMain => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      );
  TextStyle get bold22TextMain => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      );
  TextStyle get bold24TextMain => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      );
}
