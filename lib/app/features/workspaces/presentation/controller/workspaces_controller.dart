import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/workspaces/data/models/organization_model.dart';
import 'package:syncup/app/features/workspaces/data/service/organization_service.dart';
import 'package:syncup/app/services/storage_service.dart';

// 1. Public Provider
final workspacesProvider = Provider<_WorkspacesLogic>(
  (ref) => _WorkspacesLogic(
    ref: ref,
    service: ref.watch(organizationServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  ),
);

// Read-only FutureProvider for direct screen consumption
final myOrganizationsFutureProvider = FutureProvider.autoDispose<List<OrganizationModel>>((ref) async {
  final service = ref.watch(organizationServiceProvider);
  return service.getMyOrganizations();
});

// 2. Logic Implementation
class _WorkspacesLogic extends _WorkspacesStates {
  final OrganizationService service;
  final StorageService storageService;

  _WorkspacesLogic({
    required super.ref,
    required this.service,
    required this.storageService,
  });

  Future<void> fetchOrganizations() async {
    try {
      isLoading.state = true;
      isError.state = '';

      final list = await service.getMyOrganizations();
      organizations.state = list;

      final currentOrgId = storageService.getActiveOrgId();
      if (currentOrgId != null && list.isNotEmpty) {
        final found = list.where((o) => o.id == currentOrgId);
        if (found.isNotEmpty) {
          selectedOrg.state = found.first;
        } else {
          selectedOrg.state = list.first;
          await storageService.setActiveOrg(
            orgId: list.first.id,
            orgName: list.first.name,
          );
        }
      } else if (list.isNotEmpty) {
        selectedOrg.state = list.first;
        await storageService.setActiveOrg(
          orgId: list.first.id,
          orgName: list.first.name,
        );
      }
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to load workspaces';
    } finally {
      isLoading.state = false;
    }
  }

  Future<void> selectOrganization(OrganizationModel org) async {
    selectedOrg.state = org;
    await storageService.setActiveOrg(orgId: org.id, orgName: org.name);
    isWorkspaceSelected.state = true;
  }

  void resetWorkspaceSelectionState() {
    isWorkspaceSelected.state = false;
  }
}

// 3. States Definition
class _WorkspacesStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isWorkspaceSelected;
  final CustomState<String> isError;
  final CustomState<List<OrganizationModel>> organizations;
  final CustomState<OrganizationModel?> selectedOrg;

  _WorkspacesStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isWorkspaceSelected = CustomState(ref, false),
        isError = CustomState(ref, ''),
        organizations = CustomState(ref, []),
        selectedOrg = CustomState(ref, null);
}
