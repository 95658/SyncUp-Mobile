// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;
import 'package:syncup/app/features/auth/presentation/screens/login_screen.dart'
    as _i6;
import 'package:syncup/app/features/channels/presentation/screens/channels_screen.dart'
    as _i1;
import 'package:syncup/app/features/channels/presentation/screens/chat_screen.dart'
    as _i2;
import 'package:syncup/app/features/dashboard/presentation/screens/dashboard_screen.dart'
    as _i5;
import 'package:syncup/app/features/projects/presentation/screens/create_project_screen.dart'
    as _i3;
import 'package:syncup/app/features/projects/presentation/screens/projects_screen.dart'
    as _i7;
import 'package:syncup/app/features/settings/presentation/screens/settings_screen.dart'
    as _i8;
import 'package:syncup/app/features/splash/presentation/screens/splash_screen.dart'
    as _i9;
import 'package:syncup/app/features/onboarding/presentation/screens/onboarding_screen.dart'
    as _i15;
import 'package:syncup/app/features/tasks/presentation/screens/create_task_screen.dart'
    as _i4;
import 'package:syncup/app/features/tasks/presentation/screens/task_details_screen.dart'
    as _i10;
import 'package:syncup/app/features/tasks/presentation/screens/tasks_screen.dart'
    as _i11;
import 'package:syncup/app/features/workspaces/presentation/screens/workspaces_screen.dart'
    as _i12;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    ChannelsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ChannelsScreen(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ChatScreen(
          key: args.key,
          channelId: args.channelId,
          channelName: args.channelName,
        ),
      );
    },
    CreateProjectRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CreateProjectScreen(),
      );
    },
    CreateTaskRoute.name: (routeData) {
      final args = routeData.argsAs<CreateTaskRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.CreateTaskScreen(
          key: args.key,
          projectId: args.projectId,
        ),
      );
    },
    DashboardRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.DashboardScreen(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.OnboardingScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LoginScreen(),
      );
    },
    ProjectsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ProjectsScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SettingsScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SplashScreen(),
      );
    },
    TaskDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TaskDetailsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.TaskDetailsScreen(
          key: args.key,
          taskId: args.taskId,
        ),
      );
    },
    TasksRoute.name: (routeData) {
      final args = routeData.argsAs<TasksRouteArgs>(
          orElse: () => const TasksRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.TasksScreen(
          key: args.key,
          projectId: args.projectId,
          projectTitle: args.projectTitle,
        ),
      );
    },
    WorkspacesRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.WorkspacesScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ChannelsScreen]
class ChannelsRoute extends _i13.PageRouteInfo<void> {
  const ChannelsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ChannelsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChannelsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ChatScreen]
class ChatRoute extends _i13.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i14.Key? key,
    required String channelId,
    required String channelName,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            channelId: channelId,
            channelName: channelName,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const _i13.PageInfo<ChatRouteArgs> page =
      _i13.PageInfo<ChatRouteArgs>(name);
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.channelId,
    required this.channelName,
  });

  final _i14.Key? key;

  final String channelId;

  final String channelName;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, channelId: $channelId, channelName: $channelName}';
  }
}

/// generated route for
/// [_i3.CreateProjectScreen]
class CreateProjectRoute extends _i13.PageRouteInfo<void> {
  const CreateProjectRoute({List<_i13.PageRouteInfo>? children})
      : super(
          CreateProjectRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateProjectRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i4.CreateTaskScreen]
class CreateTaskRoute extends _i13.PageRouteInfo<CreateTaskRouteArgs> {
  CreateTaskRoute({
    _i14.Key? key,
    required String projectId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          CreateTaskRoute.name,
          args: CreateTaskRouteArgs(
            key: key,
            projectId: projectId,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateTaskRoute';

  static const _i13.PageInfo<CreateTaskRouteArgs> page =
      _i13.PageInfo<CreateTaskRouteArgs>(name);
}

class CreateTaskRouteArgs {
  const CreateTaskRouteArgs({
    this.key,
    required this.projectId,
  });

  final _i14.Key? key;

  final String projectId;

  @override
  String toString() {
    return 'CreateTaskRouteArgs{key: $key, projectId: $projectId}';
  }
}

/// generated route for
/// [_i5.DashboardScreen]
class DashboardRoute extends _i13.PageRouteInfo<void> {
  const DashboardRoute({List<_i13.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i13.PageRouteInfo<void> {
  const LoginRoute({List<_i13.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ProjectsScreen]
class ProjectsRoute extends _i13.PageRouteInfo<void> {
  const ProjectsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ProjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SettingsScreen]
class SettingsRoute extends _i13.PageRouteInfo<void> {
  const SettingsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SplashScreen]
class SplashRoute extends _i13.PageRouteInfo<void> {
  const SplashRoute({List<_i13.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i10.TaskDetailsScreen]
class TaskDetailsRoute extends _i13.PageRouteInfo<TaskDetailsRouteArgs> {
  TaskDetailsRoute({
    _i14.Key? key,
    required String taskId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          TaskDetailsRoute.name,
          args: TaskDetailsRouteArgs(
            key: key,
            taskId: taskId,
          ),
          initialChildren: children,
        );

  static const String name = 'TaskDetailsRoute';

  static const _i13.PageInfo<TaskDetailsRouteArgs> page =
      _i13.PageInfo<TaskDetailsRouteArgs>(name);
}

class TaskDetailsRouteArgs {
  const TaskDetailsRouteArgs({
    this.key,
    required this.taskId,
  });

  final _i14.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'TaskDetailsRouteArgs{key: $key, taskId: $taskId}';
  }
}

/// generated route for
/// [_i11.TasksScreen]
class TasksRoute extends _i13.PageRouteInfo<TasksRouteArgs> {
  TasksRoute({
    _i14.Key? key,
    String? projectId,
    String? projectTitle,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          TasksRoute.name,
          args: TasksRouteArgs(
            key: key,
            projectId: projectId,
            projectTitle: projectTitle,
          ),
          initialChildren: children,
        );

  static const String name = 'TasksRoute';

  static const _i13.PageInfo<TasksRouteArgs> page =
      _i13.PageInfo<TasksRouteArgs>(name);
}

class TasksRouteArgs {
  const TasksRouteArgs({
    this.key,
    this.projectId,
    this.projectTitle,
  });

  final _i14.Key? key;

  final String? projectId;

  final String? projectTitle;

  @override
  String toString() {
    return 'TasksRouteArgs{key: $key, projectId: $projectId, projectTitle: $projectTitle}';
  }
}

/// generated route for
/// [_i15.OnboardingScreen]
class OnboardingRoute extends _i13.PageRouteInfo<void> {
  const OnboardingRoute({List<_i13.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i12.WorkspacesScreen]
class WorkspacesRoute extends _i13.PageRouteInfo<void> {
  const WorkspacesRoute({List<_i13.PageRouteInfo>? children})
      : super(
          WorkspacesRoute.name,
          initialChildren: children,
        );

  static const String name = 'WorkspacesRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}
