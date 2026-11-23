import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/features/calendar/presentation/controller/calendar_controller.dart';
import 'package:syncup/app/features/calendar/presentation/widgets/calendar_body.dart';
import 'package:syncup/app/features/channels/presentation/controller/channels_controller.dart';
import 'package:syncup/app/features/channels/presentation/widgets/channels_body.dart';
import 'package:syncup/app/features/notifications/presentation/controller/notifications_controller.dart';
import 'package:syncup/app/features/projects/presentation/controller/projects_controller.dart';
import 'package:syncup/app/features/projects/presentation/widgets/projects_body.dart';
import 'package:syncup/app/features/settings/presentation/widgets/settings_body.dart';
import 'package:syncup/app/features/tasks/presentation/controller/tasks_controller.dart';
import 'package:syncup/app/features/tasks/presentation/widgets/tasks_body.dart';
import 'package:syncup/app/features/teams/presentation/controller/teams_controller.dart';
import 'package:syncup/app/features/teams/presentation/widgets/teams_body.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectsProvider).fetchProjects();
      ref.read(tasksProvider).fetchTasks();
      ref.read(teamsProvider).fetchTeams();
      ref.read(channelsProvider).fetchChannels();
      ref.read(calendarProvider).fetchMeetings();
      ref.read(notificationsProvider).fetchNotifications();
    });
  }

  final List<Widget> _bodies = const [
    ProjectsBody(),
    TasksBody(),
    TeamsBody(),
    ChannelsBody(),
    CalendarBody(),
    SettingsBody(),
  ];

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(storageServiceProvider);
    final activeOrgName = storage.getActiveOrgName();
    final user = storage.getUser();
    final isPlatformOwner = user?['isPlatformOwner'] == true;
    final notificationsLogic = ref.read(notificationsProvider);
    final notificationsList = ref.watch(notificationsLogic.notifications.provider);
    final unreadCount = notificationsList.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: CustomInkWell(
          onTap: () => context.push(const WorkspacesRoute()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.business_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const Width(8),
              Flexible(
                child: Text(
                  activeOrgName ?? tr.app_name,
                  style: context.bold16TextMain,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Width(4),
              const Icon(
                Icons.unfold_more_rounded,
                size: 18,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
        actions: [
          if (isPlatformOwner)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CustomInkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.pushAndPopAll(const WorkspacesRoute()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Width(6),
                      Text(
                        tr.superAdmin.controlPlane,
                        style: context.bold10Primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Notifications Bell
          CustomInkWell(
            onTap: () => _showNotificationsSheet(context, notificationsLogic),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary, size: 24),
                  if (unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_currentIndex == 0)
            CustomInkWell(
              onTap: () => context.push(const CreateProjectRoute()),
              child: const Padding(
                padding: EdgeInsets.only(left: 8, right: 16),
                child: Icon(Icons.add_rounded, color: AppColors.primary, size: 26),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _bodies,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          backgroundColor: AppColors.bgSurface,
          indicatorColor: AppColors.primaryLight,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.folder_outlined),
              selectedIcon: const Icon(Icons.folder_rounded, color: AppColors.primary),
              label: tr.projects.title,
            ),
            NavigationDestination(
              icon: const Icon(Icons.check_circle_outline_rounded),
              selectedIcon: const Icon(Icons.check_circle_rounded, color: AppColors.primary),
              label: tr.tasks.title,
            ),
            NavigationDestination(
              icon: const Icon(Icons.groups_2_outlined),
              selectedIcon: const Icon(Icons.groups_2_rounded, color: AppColors.primary),
              label: tr.teams.title,
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
              label: tr.channels.title,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              label: tr.calendar.title,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded, color: AppColors.primary),
              label: tr.settings.title,
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context, dynamic logic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final list = ref.watch(logic.notifications.provider);
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.65,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tr.notifications.title, style: ctx.bold18TextMain),
                      TextButton(
                        onPressed: () async {
                          await logic.markAllAsRead();
                        },
                        child: Text(tr.notifications.markAllAsRead, style: ctx.bold10Primary),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: list.isEmpty
                        ? Center(child: Text(tr.notifications.noNewNotifications))
                        : ListView.separated(
                            itemCount: list.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = list[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: item.isRead ? AppColors.bgSubtle : AppColors.primaryLight,
                                  child: Icon(
                                    Icons.notifications_active_outlined,
                                    size: 18,
                                    color: item.isRead ? AppColors.textMuted : AppColors.primary,
                                  ),
                                ),
                                title: Text(item.title, style: ctx.bold14TextMain),
                                subtitle: Text(item.message, style: ctx.roman12Secondary),
                                onTap: () => logic.markAsRead(item.id),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
