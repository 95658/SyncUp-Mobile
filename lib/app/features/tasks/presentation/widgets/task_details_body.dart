import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_button.dart';
import 'package:syncup/app/features/tasks/data/models/task_model.dart';
import 'package:syncup/app/features/tasks/presentation/controller/tasks_controller.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class TaskDetailsBody extends ConsumerWidget {
  final TaskModel task;

  const TaskDetailsBody({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(tasksProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: Constants.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.status,
                  style: context.bold12TextMain.copyWith(color: AppColors.primary),
                ),
              ),
              const Width(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.priority,
                  style: context.medium12TextMain,
                ),
              ),
            ],
          ),
          const Height(16),
          Text(
            task.title,
            style: context.bold20TextMain,
          ),
          const Height(12),
          if (task.description != null && task.description!.isNotEmpty) ...[
            Text(
              task.description!,
              style: context.roman14Secondary,
            ),
            const Height(24),
          ],
          const Divider(color: AppColors.borderLight),
          const Height(16),
          _DetailRow(
            label: tr.projects.title,
            value: task.projectName ?? tr.common.general,
            icon: Icons.folder_outlined,
          ),
          const Height(12),
          _DetailRow(
            label: tr.tasks.assignee,
            value: task.assigneeName ?? tr.common.unassigned,
            icon: Icons.person_outline,
          ),
          if (task.dueDate != null) ...[
            const Height(12),
            _DetailRow(
              label: tr.tasks.dueDate,
              value: task.dueDate!,
              icon: Icons.calendar_today_outlined,
            ),
          ],
          const Height(36),
          Text(tr.tasks.changeStatus, style: context.bold14TextMain),
          const Height(12),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: tr.tasks.todo,
                  backgroundColor: task.status == 'TODO' ? AppColors.primary : AppColors.bgSubtle,
                  textColor: task.status == 'TODO' ? Colors.white : AppColors.textMain,
                  onPress: () => logic.updateStatus(task.id, 'TODO'),
                ),
              ),
              const Width(8),
              Expanded(
                child: CustomButton(
                  title: tr.tasks.inProgress,
                  backgroundColor: task.status == 'IN_PROGRESS' ? AppColors.primary : AppColors.bgSubtle,
                  textColor: task.status == 'IN_PROGRESS' ? Colors.white : AppColors.textMain,
                  onPress: () => logic.updateStatus(task.id, 'IN_PROGRESS'),
                ),
              ),
              const Width(8),
              Expanded(
                child: CustomButton(
                  title: tr.tasks.done,
                  backgroundColor: task.status == 'DONE' ? AppColors.success : AppColors.bgSubtle,
                  textColor: task.status == 'DONE' ? Colors.white : AppColors.textMain,
                  onPress: () => logic.updateStatus(task.id, 'DONE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const Width(8),
        Text(label, style: context.roman14Secondary),
        const Spacer(),
        Text(value, style: context.medium14TextMain),
      ],
    );
  }
}
