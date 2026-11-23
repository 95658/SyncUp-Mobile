import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';

final superAdminServiceProvider = Provider<SuperAdminService>((ref) {
  return SuperAdminService(ref.watch(dioClientProvider));
});

class SuperAdminService {
  final DioClient client;

  SuperAdminService(this.client);

  // 1. GET /super-admin/analytics
  Future<Json> getPlatformAnalytics() async {
    final res = ResponseClient<Json>(
      await client.get(Endpoints.superAdminAnalytics),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 2. GET /super-admin/organizations
  Future<List<dynamic>> getAllOrganizations() async {
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.superAdminOrganizations),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return (res.data is List) ? res.data as List : [];
  }

  // 3. POST /super-admin/organizations
  Future<Json> createOrganization({
    required String name,
    required String adminEmail,
    required String adminName,
  }) async {
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.superAdminOrganizations,
        body: {
          'name': name.trim(),
          'adminEmail': adminEmail.trim(),
          'adminName': adminName.trim(),
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 4. PATCH /super-admin/organizations/:id/status
  Future<bool> updateOrgStatus(String orgId, String status) async {
    final res = ResponseClient<dynamic>(
      await client.patch(
        Endpoints.superAdminOrgStatus(orgId),
        body: {'status': status},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 5. DELETE /super-admin/organizations/:id
  Future<bool> deleteOrganization(String orgId) async {
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.superAdminOrgDelete(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 6. GET /super-admin/administrators
  Future<List<dynamic>> getAdministrators() async {
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.superAdminAdministrators),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return (res.data is List) ? res.data as List : [];
  }

  // 7. PATCH /super-admin/administrators/:id/status
  Future<bool> updateAdminStatus(String adminId, String status) async {
    final res = ResponseClient<dynamic>(
      await client.patch(
        Endpoints.superAdminAdminStatus(adminId),
        body: {'status': status},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }
}
