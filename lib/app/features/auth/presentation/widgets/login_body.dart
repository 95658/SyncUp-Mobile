import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/consumer_button.dart';
import 'package:syncup/app/core/widgets/inputs/custom_password_text_form_field.dart';
import 'package:syncup/app/core/widgets/inputs/custom_text_form_field.dart';
import 'package:syncup/app/core/widgets/common/syncup_logo.dart';
import 'package:syncup/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class LoginBody extends ConsumerWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(authProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.horizontalPadding + 4,
            vertical: Constants.verticalPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - (Constants.verticalPadding * 2),
            ),
            child: IntrinsicHeight(
              child: Form(
                key: logic.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    // Brand Logo & Welcome Badge
                    const Center(
                      child: SyncUpLogo(
                        size: 72,
                        borderRadius: 18,
                        showGlow: true,
                        isDark: false,
                      ),
                    ),
                    const Height(20),
                    Center(
                      child: Text(
                        tr.app_name,
                        style: context.bold24TextMain.copyWith(letterSpacing: -0.5),
                      ),
                    ),
                    const Height(8),
                    Center(
                      child: Text(
                        tr.auth.signInSubtitle,
                        style: context.roman14Secondary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Height(36),

                    // Email input
                    CustomTextFormField(
                      title: tr.auth.email,
                      hint: 'name@company.com',
                      controller: logic.emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return tr.auth.emailRequired;
                        }
                        if (!val.contains('@') || !val.contains('.')) {
                          return tr.auth.invalidEmail;
                        }
                        return null;
                      },
                    ),
                    const Height(16),

                    // Password input
                    CustomPasswordTextFormField(
                      title: tr.auth.password,
                      hint: '••••••••',
                      controller: logic.passwordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return tr.auth.passwordRequired;
                        }
                        if (val.length < 6) {
                          return tr.auth.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const Height(24),

                    // Submit Button
                    ConsumerButton(
                      title: tr.auth.login,
                      onPress: logic.login,
                      stateProvider: logic.isLoading,
                    ),
                    const Height(24),

                    // Hint for private SaaS invitation
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.bgSubtle,
                          borderRadius: BorderRadius.circular(Constants.borderRadius),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
                            const Width(8),
                            Flexible(
                              child: Text(
                                tr.auth.invitationOnlyNotice,
                                style: context.roman12Secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
