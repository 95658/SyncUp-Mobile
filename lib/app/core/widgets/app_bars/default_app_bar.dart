import 'package:flutter/material.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/custom_transform_arabic.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final VoidCallback? onBack;
  final PreferredSizeWidget? bottom;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = true,
    this.onBack,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: context.bold16TextMain,
      ),
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.bgSurface,
      leading: leading ??
          (showBack
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
              : null),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
