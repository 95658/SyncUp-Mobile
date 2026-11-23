import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/themes/theme_provider.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/custom_app_dialog.dart';
import 'package:syncup/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:syncup/app/features/settings/presentation/controller/settings_controller.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

void showAdminProfileModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _AdminProfileContent(parentContext: context),
  );
}

class _AdminProfileContent extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const _AdminProfileContent({required this.parentContext});

  @override
  ConsumerState<_AdminProfileContent> createState() => _AdminProfileContentState();
}

class _AdminProfileContentState extends ConsumerState<_AdminProfileContent> {
  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(storageServiceProvider);
    final user = storage.getUser();
    final authLogic = ref.read(authProvider);
    final settingsLogic = ref.read(settingsProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final currentLocale = ref.watch(settingsLogic.currentLocale.provider);

    final fullName = user?['fullName']?.toString() ?? 'Platform Owner';
    final email = user?['email']?.toString() ?? 'admin@syncup.com';
    final avatarUrl = user?['avatarUrl']?.toString();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Height(16),

          // Admin Profile Header
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                alignment: Alignment.center,
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          avatarUrl,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Text(
                            fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A',
                            style: context.bold24TextMain.copyWith(color: AppColors.primary),
                          ),
                        ),
                      )
                    : Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A',
                        style: context.bold24TextMain.copyWith(color: AppColors.primary),
                      ),
              ),
              CustomInkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showChangePhotoDialog(context, storage),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bgSurface, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const Height(10),

          Text(
            fullName,
            style: context.bold18TextMain,
          ),
          const Height(2),
          Text(
            email,
            style: context.roman13Secondary,
          ),
          const Height(8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_rounded, size: 13, color: AppColors.primary),
                const Width(4),
                Text(
                  tr.superAdmin.controlPlane.toUpperCase(),
                  style: context.bold10Primary,
                ),
              ],
            ),
          ),
          const Height(20),

          // Preferences & Controls
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                // Dark Mode Switch
                SwitchListTile.adaptive(
                  value: isDark,
                  activeTrackColor: AppColors.primary,
                  secondary: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primary.withAlpha(30) : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    isDark ? tr.common.darkMode : tr.common.lightMode,
                    style: context.bold14TextMain,
                  ),
                  subtitle: Text(
                    isDark ? tr.settings.darkModeDesc : tr.settings.lightModeDesc,
                    style: context.roman12Secondary,
                  ),
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
                const Divider(height: 1, color: AppColors.borderLight),

                // Language Selector
                ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.language_rounded, color: AppColors.primary, size: 18),
                  ),
                  title: Text(
                    tr.settings.language,
                    style: context.bold14TextMain,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentLocale == 'ar' ? 'العربية' : 'English',
                        style: context.bold12TextMain.copyWith(color: AppColors.primary),
                      ),
                      const Width(4),
                      const Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 18),
                    ],
                  ),
                  onTap: () {
                    final newLocale = currentLocale == 'ar' ? AppLocale.en : AppLocale.ar;
                    settingsLogic.changeLanguage(newLocale);
                  },
                ),
              ],
            ),
          ),
          const Height(16),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.borderRadius)),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.danger),
              label: Text(
                tr.auth.logout,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.parentContext.showCustomAlertDialog(
                  dialog: CustomAppDialog(
                    title: tr.auth.logout,
                    description: tr.auth.logoutConfirm,
                    confirmTitle: tr.auth.logout,
                    confirmColor: AppColors.danger,
                    cancelTitle: tr.common.cancel,
                    onConfirm: () async {
                      await authLogic.logout();
                      if (widget.parentContext.mounted) {
                        widget.parentContext.pushAndPopAll(const LoginRoute());
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePhotoDialog(BuildContext context, StorageService storage) {
    final urlCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text(tr.common.photoUrl, style: dialogCtx.bold18TextMain),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlCtrl,
              decoration: InputDecoration(
                labelText: tr.common.avatarUrl,
                hintText: 'https://images.unsplash.com/...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(tr.common.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              final newUrl = urlCtrl.text.trim();
              if (newUrl.isNotEmpty) {
                final user = storage.getUser() ?? {};
                user['avatarUrl'] = newUrl;
                await storage.saveUser(user);
                if (mounted) {
                  setState(() {});
                }
              }
              if (dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
              }
            },
            child: Text(tr.common.save, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
