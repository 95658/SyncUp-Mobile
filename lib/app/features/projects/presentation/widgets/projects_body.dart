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
import 'package:syncup/app/features/projects/data/models/project_model.dart';
import 'package:syncup/app/features/projects/presentation/controller/projects_controller.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class ProjectsBody extends ConsumerWidget {
  const ProjectsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(projectsProvider);
    final isLoading = ref.watch(logic.isLoading.provider);
    final projects = ref.watch(logic.projects.provider);

    if (isLoading && projects.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: 4,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (_, __) => const ShimmerBox(height: 100),
      );
    }

    if (projects.isEmpty) {
      return EmptyStateView(
        title: tr.projects.noProjects,
        subtitle: tr.projects.noProjectsSubtitle,
        icon: Icons.folder_outlined,
        actionTitle: tr.projects.create,
        onAction: () => context.push(const CreateProjectRoute()),
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: logic.fetchProjects,
      child: ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: projects.length,
        separatorBuilder: (_, __) => const Height(12),
        itemBuilder: (context, index) {
          final project = projects[index];
          return _ProjectCard(project: project);
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      onTap: () {
        context.push(TasksRoute(projectId: project.id, projectTitle: project.name));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.folder_special_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const Width(12),
                Expanded(
                  child: Text(
                    project.name,
                    style: context.bold16TextMain,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bgSubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    project.status,
                    style: context.medium10Muted,
                  ),
                ),
              ],
            ),
            if (project.description != null && project.description!.isNotEmpty) ...[
              const Height(10),
              Text(
                project.description!,
                style: context.roman14Secondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const Height(14),
            const Divider(color: AppColors.borderSubtle),
            const Height(8),
            Row(
              children: [
                const Icon(Icons.task_alt_rounded, size: 16, color: AppColors.textMuted),
                const Width(6),
                Text(
                  '${project.tasksCount} ${tr.projects.tasksCount}',
                  style: context.roman12Secondary,
                ),
                const Spacer(),
                const Icon(Icons.people_alt_outlined, size: 16, color: AppColors.textMuted),
                const Width(6),
                Text(
                  '${project.membersCount} members',
                  style: context.roman12Secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
