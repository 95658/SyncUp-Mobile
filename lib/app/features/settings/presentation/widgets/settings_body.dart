import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/custom_app_dialog.dart';
import 'package:syncup/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:syncup/app/features/settings/presentation/controller/settings_controller.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class SettingsBody extends ConsumerWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsLogic = ref.read(settingsProvider);
    final authLogic = ref.read(authProvider);
    final user = ref.watch(storageServiceProvider).getUser();
    final activeOrgName = ref.watch(storageServiceProvider).getActiveOrgName();
    final currentLocale = ref.watch(settingsLogic.currentLocale.provider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: Constants.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user != null && user['fullName'] != null && user['fullName'].toString().isNotEmpty
                        ? user['fullName'].toString()[0].toUpperCase()
                        : 'U',
                    style: context.bold20TextMain.copyWith(color: AppColors.primary),
                  ),
                ),
                const Width(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?['fullName']?.toString() ?? 'User',
                        style: context.bold16TextMain,
                      ),
                      const Height(4),
                      Text(
                        user?['email']?.toString() ?? '',
                        style: context.roman12Secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Height(24),

          // Workspace Section
          Text(tr.workspace.title, style: context.bold14TextMain),
          const Height(10),
          _SettingsTile(
            icon: Icons.business_rounded,
            title: tr.workspace.current,
            subtitle: activeOrgName ?? 'None',
            trailing: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
            onTap: () {
              context.push(const WorkspacesRoute());
            },
          ),
          const Height(24),

          // Preferences Section
          Text(tr.common.preferences, style: context.bold14TextMain),
          const Height(10),
          _SettingsTile(
            icon: Icons.language_rounded,
            title: tr.settings.language,
            subtitle: currentLocale == 'ar' ? 'العربية' : 'English',
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            onTap: () {
              final newLocale = currentLocale == 'ar' ? AppLocale.en : AppLocale.ar;
              settingsLogic.changeLanguage(newLocale);
            },
          ),
          const Height(24),

          // Account & Actions
          Text(tr.common.account, style: context.bold14TextMain),
          const Height(10),
          _SettingsTile(
            icon: Icons.logout_rounded,
            title: tr.auth.logout,
            titleColor: AppColors.danger,
            iconColor: AppColors.danger,
            onTap: () {
              context.showCustomAlertDialog(
                dialog: CustomAppDialog(
                  title: tr.auth.logout,
                  description: tr.auth.logoutConfirm,
                  confirmTitle: tr.auth.logout,
                  confirmColor: AppColors.danger,
                  cancelTitle: tr.common.cancel,
                  onConfirm: () async {
                    await authLogic.logout();
                    if (context.mounted) {
                      context.pushAndPopAll(const LoginRoute());
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor ?? AppColors.textSecondary),
            const Width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: (titleColor != null)
                        ? context.medium14TextMain.copyWith(color: titleColor)
                        : context.medium14TextMain,
                  ),
                  if (subtitle != null) ...[
                    const Height(2),
                    Text(
                      subtitle!,
                      style: context.roman12Secondary,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
