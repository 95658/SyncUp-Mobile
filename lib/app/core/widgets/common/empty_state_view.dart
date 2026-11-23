import 'package:flutter/material.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_button.dart';

class EmptyStateView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionTitle;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.actionTitle,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.bgSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.textMuted),
            ),
            const Height(16),
            Text(
              title,
              style: context.bold16TextMain,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const Height(8),
              Text(
                subtitle!,
                style: context.roman14Secondary,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionTitle != null && onAction != null) ...[
              const Height(20),
              CustomButton(
                title: actionTitle!,
                width: 160,
                onPress: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
