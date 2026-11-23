import 'package:auto_route/auto_route.dart';
import 'package:syncup/app/router/auto_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: WorkspacesRoute.page),
        AutoRoute(page: DashboardRoute.page),
        AutoRoute(page: ProjectsRoute.page),
        AutoRoute(page: CreateProjectRoute.page),
        AutoRoute(page: TasksRoute.page),
        AutoRoute(page: CreateTaskRoute.page),
        AutoRoute(page: TaskDetailsRoute.page),
        AutoRoute(page: ChannelsRoute.page),
        AutoRoute(page: ChatRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ];
}
