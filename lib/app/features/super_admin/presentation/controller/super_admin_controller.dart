import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/super_admin/data/service/super_admin_service.dart';

final superAdminProvider = Provider<_SuperAdminLogic>(
  (ref) => _SuperAdminLogic(
    ref: ref,
    service: ref.watch(superAdminServiceProvider),
  ),
);

class _SuperAdminLogic extends _SuperAdminStates {
  final SuperAdminService service;

  _SuperAdminLogic({
    required super.ref,
    required this.service,
  });

  Future<void> fetchAnalytics() async {
    try {
      isLoading.state = true;
      final data = await service.getPlatformAnalytics();
      analytics.state = data;
    } catch (_) {} finally {
      isLoading.state = false;
    }
  }

  Future<void> fetchOrganizations() async {
    try {
      isLoading.state = true;
      final list = await service.getAllOrganizations();
      organizations.state = list;
    } catch (_) {} finally {
      isLoading.state = false;
    }
  }

  Future<bool> createOrganization({
    required String name,
    required String adminEmail,
    required String adminName,
  }) async {
    try {
      isActionLoading.state = true;
      await service.createOrganization(
        name: name,
        adminEmail: adminEmail,
        adminName: adminName,
      );
      await fetchOrganizations();
      await fetchAnalytics();
      return true;
    } on ApiException catch (e) {
      isError.state = e.toString();
      return false;
    } catch (_) {
      isError.state = 'Failed to provision organization';
      return false;
    } finally {
      isActionLoading.state = false;
    }
  }

  Future<bool> toggleOrgStatus(String orgId, String currentStatus) async {
    try {
      isActionLoading.state = true;
      final newStatus = currentStatus.toUpperCase() == 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';
      await service.updateOrgStatus(orgId, newStatus);
      await fetchOrganizations();
      await fetchAnalytics();
      return true;
    } catch (_) {
      return false;
    } finally {
      isActionLoading.state = false;
    }
  }

  Future<bool> deleteOrganization(String orgId) async {
    try {
      isActionLoading.state = true;
      await service.deleteOrganization(orgId);
      await fetchOrganizations();
      await fetchAnalytics();
      return true;
    } catch (_) {
      return false;
    } finally {
      isActionLoading.state = false;
    }
  }
}

class _SuperAdminStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isActionLoading;
  final CustomState<String> isError;
  final CustomState<Json> analytics;
  final CustomState<List<dynamic>> organizations;

  _SuperAdminStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isActionLoading = CustomState(ref, false),
        isError = CustomState(ref, ''),
        analytics = CustomState(ref, {}),
        organizations = CustomState(ref, []);
}
