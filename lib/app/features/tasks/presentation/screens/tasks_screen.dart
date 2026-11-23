import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/enums/app_enums.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/features/tasks/presentation/controller/tasks_controller.dart';
import 'package:syncup/app/features/tasks/presentation/widgets/tasks_body.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class TasksScreen extends ConsumerStatefulWidget {
  final String? projectId;
  final String? projectTitle;

  const TasksScreen({
    super.key,
    this.projectId,
    this.projectTitle,
  });

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tasksProvider).fetchTasks(projectId: widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    listeners(ref, context);

    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.projectTitle ?? tr.tasks.title,
        showBack: widget.projectId != null,
        actions: [
          if (widget.projectId != null)
            CustomInkWell(
              onTap: () => context.push(
                CreateTaskRoute(projectId: widget.projectId!),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.add_rounded, color: AppColors.primary, size: 26),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: TasksBody(projectId: widget.projectId),
      ),
    );
  }

  void listeners(WidgetRef ref, BuildContext context) {
    final provider = ref.read(tasksProvider);

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
