import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/enums/app_enums.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/widgets/app_bars/no_app_bar.dart';
import 'package:syncup/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:syncup/app/features/auth/presentation/widgets/login_body.dart';
import 'package:syncup/app/router/auto_router.gr.dart';

@RoutePage()
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listeners(ref, context);

    return const Scaffold(
      appBar: NoAppBar(),
      body: SafeArea(
        child: LoginBody(),
      ),
    );
  }

  void listeners(WidgetRef ref, BuildContext context) {
    final provider = ref.read(authProvider);

    // SnackBar errors
    ref.listen(provider.isError.provider, (previous, current) {
      if (current.isNotEmpty) {
        context.showCustomSnackBar(
          message: current,
          snackBarStatus: SnackBarStatus.error,
        );
      }
    });

    // Navigation on login success -> navigate to workspaces screen
    ref.listen(provider.isSuccess.provider, (previous, current) {
      if (current) {
        provider.resetStates();
        context.pushAndPopAll(const WorkspacesRoute());
      }
    });
  }
}
