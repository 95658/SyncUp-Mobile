import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/widgets/app_bars/no_app_bar.dart';
import 'package:syncup/app/features/splash/presentation/widgets/splash_body.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/app/services/storage_service.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;

    final storage = ref.read(storageServiceProvider);
    final token = await storage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      final user = storage.getUser();
      final isPlatformOwner = user?['isPlatformOwner'] == true;

      if (!mounted) return;
      if (isPlatformOwner) {
        // Platform Owners always go to the Super Admin Platform Control Plane
        context.pushAndPopAll(const WorkspacesRoute());
      } else {
        final activeOrgId = storage.getActiveOrgId();
        if (activeOrgId != null && activeOrgId.isNotEmpty) {
          context.pushAndPopAll(const DashboardRoute());
        } else {
          context.pushAndPopAll(const WorkspacesRoute());
        }
      }
    } else {
      if (!mounted) return;
      final hasSeenOnboarding = storage.prefs.getBool('syncup_has_seen_onboarding') ?? false;
      if (!hasSeenOnboarding) {
        context.pushAndPopAll(const OnboardingRoute());
      } else {
        context.pushAndPopAll(const LoginRoute());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NoAppBar(),
      body: SplashBody(),
    );
  }
}
