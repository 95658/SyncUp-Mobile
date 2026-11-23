import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/core/widgets/future_provider_builder.dart';
import 'package:syncup/app/features/tasks/presentation/controller/tasks_controller.dart';
import 'package:syncup/app/features/tasks/presentation/widgets/task_details_body.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class TaskDetailsScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: tr.tasks.taskDetails,
      ),
      body: SafeArea(
        child: ref.watchWhen(
          provider: taskDetailsProvider(taskId),
          data: (task) => TaskDetailsBody(task: task),
        ),
      ),
    );
  }
}
