import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/enums/app_enums.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/features/projects/presentation/controller/projects_controller.dart';
import 'package:syncup/app/features/projects/presentation/widgets/create_project_body.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class CreateProjectScreen extends ConsumerWidget {
  const CreateProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listeners(ref, context);

    return Scaffold(
      appBar: DefaultAppBar(
        title: tr.projects.create,
      ),
      body: const SafeArea(
        child: CreateProjectBody(),
      ),
    );
  }

  void listeners(WidgetRef ref, BuildContext context) {
    final provider = ref.read(projectsProvider);

    ref.listen(provider.isError.provider, (previous, current) {
      if (current.isNotEmpty) {
        context.showCustomSnackBar(
          message: current,
          snackBarStatus: SnackBarStatus.error,
        );
      }
    });

    ref.listen(provider.isCreatedSuccess.provider, (previous, current) {
      if (current) {
        provider.resetCreatedState();
        context.showCustomSnackBar(
          message: tr.projects.projectCreated,
          snackBarStatus: SnackBarStatus.success,
        );
        context.pop();
      }
    });
  }
}
