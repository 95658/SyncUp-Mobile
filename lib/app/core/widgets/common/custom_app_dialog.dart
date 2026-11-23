import 'package:flutter/material.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_button.dart';

class CustomAppDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmTitle;
  final String? cancelTitle;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;

  const CustomAppDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmTitle,
    required this.onConfirm,
    this.cancelTitle,
    this.onCancel,
    this.confirmColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius * 1.5),
      ),
      backgroundColor: AppColors.bgSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (confirmColor ?? AppColors.primary).withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: confirmColor ?? AppColors.primary,
                ),
              ),
              const Height(16),
            ],
            Text(
              title,
              style: context.bold16TextMain,
              textAlign: TextAlign.center,
            ),
            const Height(8),
            Text(
              description,
              style: context.roman14Secondary,
              textAlign: TextAlign.center,
            ),
            const Height(24),
            Row(
              children: [
                if (cancelTitle != null) ...[
                  Expanded(
                    child: CustomButton(
                      title: cancelTitle!,
                      backgroundColor: AppColors.bgSubtle,
                      textColor: AppColors.textMain,
                      onPress: onCancel ?? () => context.pop(),
                    ),
                  ),
                  const Width(12),
                ],
                Expanded(
                  child: CustomButton(
                    title: confirmTitle,
                    backgroundColor: confirmColor ?? AppColors.primary,
                    onPress: () {
                      context.pop();
                      onConfirm();
                    },
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
