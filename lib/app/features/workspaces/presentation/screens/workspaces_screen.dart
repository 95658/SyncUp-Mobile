import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/enums/app_enums.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/features/super_admin/presentation/controller/super_admin_controller.dart';
import 'package:syncup/app/features/super_admin/presentation/widgets/admin_profile_modal.dart';
import 'package:syncup/app/features/workspaces/presentation/controller/workspaces_controller.dart';
import 'package:syncup/app/features/workspaces/presentation/widgets/workspaces_body.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class WorkspacesScreen extends ConsumerStatefulWidget {
  const WorkspacesScreen({super.key});

  @override
  ConsumerState<WorkspacesScreen> createState() => _WorkspacesScreenState();
}

class _WorkspacesScreenState extends ConsumerState<WorkspacesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workspacesProvider).fetchOrganizations();
      final user = ref.read(storageServiceProvider).getUser();
      if (user?['isPlatformOwner'] == true) {
        ref.read(superAdminProvider).fetchAnalytics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listeners(ref, context);
    final user = ref.watch(storageServiceProvider).getUser();
    final isPlatformOwner = user?['isPlatformOwner'] == true;

    return Scaffold(
      appBar: DefaultAppBar(
        title: isPlatformOwner ? tr.superAdmin.dashboardTitle : tr.workspace.title,
        showBack: false,
        actions: [
          if (isPlatformOwner)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: CustomInkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => showAdminProfileModal(context, ref),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user != null && user['fullName'] != null && user['fullName'].toString().isNotEmpty
                        ? user['fullName'].toString()[0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: const SafeArea(
        child: WorkspacesBody(),
      ),
    );
  }

  void listeners(WidgetRef ref, BuildContext context) {
    final provider = ref.read(workspacesProvider);

    ref.listen(provider.isError.provider, (previous, current) {
      if (current.isNotEmpty) {
        context.showCustomSnackBar(
          message: current,
          snackBarStatus: SnackBarStatus.error,
        );
      }
    });

    ref.listen(provider.isWorkspaceSelected.provider, (previous, current) {
      if (current) {
        provider.resetWorkspaceSelectionState();
        context.pushAndPopAll(const DashboardRoute());
      }
    });
  }
}
