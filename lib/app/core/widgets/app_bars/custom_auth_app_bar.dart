import 'package:flutter/material.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/custom_transform_arabic.dart';

class CustomAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBack;
  final String? skipTitle;
  final VoidCallback? onSkip;

  const CustomAuthAppBar({
    super.key,
    this.showBack = true,
    this.onBack,
    this.skipTitle,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBack
          ? CustomInkWell(
              onTap: onBack ?? () => context.pop(),
              child: const Center(
                child: CustomTransformArabic(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.textMain,
                  ),
                ),
              ),
            )
          : null,
      actions: [
        if (skipTitle != null && onSkip != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomInkWell(
              onTap: onSkip,
              child: Center(
                child: Text(
                  skipTitle!,
                  style: context.medium14Primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoAppBar({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  Size get preferredSize => Size.zero;
}
