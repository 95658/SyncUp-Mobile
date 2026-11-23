import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/empty_state_view.dart';
import 'package:syncup/app/core/widgets/common/shimmer_box.dart';
import 'package:syncup/app/features/tasks/data/models/task_model.dart';
import 'package:syncup/app/features/tasks/presentation/controller/tasks_controller.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class TasksBody extends ConsumerWidget {
  final String? projectId;

  const TasksBody({super.key, this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(tasksProvider);
    final isLoading = ref.watch(logic.isLoading.provider);
    final tasks = ref.watch(logic.tasks.provider);
    final filterStatus = ref.watch(logic.selectedFilterStatus.provider);

    final filteredTasks = filterStatus == null
        ? tasks
        : tasks.where((t) => t.status == filterStatus).toList();

    return Column(
      children: [
        // Status Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.horizontalPadding,
            vertical: 10,
          ),
          child: Row(
            children: [
              _FilterChip(
                label: tr.common.all,
                isSelected: filterStatus == null,
                onTap: () => logic.setFilterStatus(null),
              ),
              const Width(8),
              _FilterChip(
                label: tr.tasks.todo,
                isSelected: filterStatus == 'TODO',
                onTap: () => logic.setFilterStatus('TODO'),
              ),
              const Width(8),
              _FilterChip(
                label: tr.tasks.inProgress,
                isSelected: filterStatus == 'IN_PROGRESS',
                onTap: () => logic.setFilterStatus('IN_PROGRESS'),
              ),
              const Width(8),
              _FilterChip(
                label: tr.tasks.inReview,
                isSelected: filterStatus == 'IN_REVIEW',
                onTap: () => logic.setFilterStatus('IN_REVIEW'),
              ),
              const Width(8),
              _FilterChip(
                label: tr.tasks.done,
                isSelected: filterStatus == 'DONE',
                onTap: () => logic.setFilterStatus('DONE'),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.borderLight),

        // Tasks List
        Expanded(
          child: isLoading && tasks.isEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(Constants.horizontalPadding),
                  itemCount: 5,
                  separatorBuilder: (_, __) => const Height(10),
                  itemBuilder: (_, __) => const ShimmerBox(height: 80),
                )
              : filteredTasks.isEmpty
                  ? EmptyStateView(
                      title: tr.tasks.noTasks,
                      subtitle: tr.tasks.noTasksSubtitle,
                      icon: Icons.check_circle_outline_rounded,
                      actionTitle: projectId != null ? tr.tasks.create : null,
                      onAction: projectId != null
                          ? () => context.push(CreateTaskRoute(projectId: projectId!))
                          : null,
                    )
                  : RefreshIndicator.adaptive(
                      onRefresh: () => logic.fetchTasks(projectId: projectId),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(Constants.horizontalPadding),
                        itemCount: filteredTasks.length,
                        separatorBuilder: (_, __) => const Height(10),
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return _TaskCard(
                            task: task,
                            onStatusChanged: (newStatus) {
                              logic.updateStatus(task.id, newStatus);
                            },
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: isSelected ? context.medium12Primary.copyWith(color: Colors.white) : context.roman12Secondary,
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<String> onStatusChanged;

  const _TaskCard({
    required this.task,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == 'DONE';

    return CustomInkWell(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      onTap: () {
        context.push(TaskDetailsRoute(taskId: task.id));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox for toggling Done status
            CustomInkWell(
              onTap: () {
                onStatusChanged(isDone ? 'TODO' : 'DONE');
              },
              child: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: isDone ? AppColors.success : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone ? AppColors.success : AppColors.borderStrong,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            const Width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: isDone
                        ? context.roman14TextMain.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textMuted,
                          )
                        : context.medium14TextMain,
                  ),
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    const Height(4),
                    Text(
                      task.description!,
                      style: context.roman12Secondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Height(8),
                  Row(
                    children: [
                      _PriorityBadge(priority: task.priority),
                      if (task.projectName != null) ...[
                        const Width(8),
                        Text(
                          task.projectName!,
                          style: context.roman10Muted,
                        ),
                      ],
                      if (task.assigneeName != null) ...[
                        const Spacer(),
                        const Icon(Icons.person_outline, size: 14, color: AppColors.textMuted),
                        const Width(4),
                        Text(
                          task.assigneeName!,
                          style: context.roman10Muted,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (priority.toUpperCase()) {
      case 'URGENT':
        bg = AppColors.dangerBg;
        fg = AppColors.danger;
        break;
      case 'HIGH':
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        break;
      case 'LOW':
        bg = AppColors.bgSubtle;
        fg = AppColors.textSecondary;
        break;
      default:
        bg = AppColors.primaryLight;
        fg = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
