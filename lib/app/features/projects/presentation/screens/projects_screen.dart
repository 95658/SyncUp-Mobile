import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/enums/app_enums.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/features/projects/presentation/controller/projects_controller.dart';
import 'package:syncup/app/features/projects/presentation/widgets/projects_body.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectsProvider).fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    listeners(ref, context);

    return Scaffold(
      appBar: DefaultAppBar(
        title: tr.projects.title,
        showBack: false,
        actions: [
          CustomInkWell(
            onTap: () => context.push(const CreateProjectRoute()),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.add_rounded, color: AppColors.primary, size: 26),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: ProjectsBody(),
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
  }
}
