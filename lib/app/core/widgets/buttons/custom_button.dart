import 'package:flutter/material.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.title,
    this.onPress,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.height,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isDisabled
        ? AppColors.bgMuted
        : (backgroundColor ?? AppColors.primary);
    final effectiveRadius = borderRadius ?? Constants.borderRadius;
    final effectiveHeight = height ?? Constants.buttonHeight;

    return CustomInkWell(
      borderRadius: BorderRadius.circular(effectiveRadius),
      onTap: (isDisabled || isLoading) ? null : onPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: effectiveHeight,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: BorderRadius.circular(effectiveRadius),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: (isDisabled || isLoading)
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    style: textColor != null
                        ? context.medium14White.copyWith(color: textColor)
                        : (isDisabled
                            ? context.medium14TextMain.copyWith(color: AppColors.textMuted)
                            : context.medium14White),
                  ),
                ],
              ),
      ),
    );
  }
}
