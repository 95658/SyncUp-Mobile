import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/workspaces/data/models/organization_model.dart';

final organizationServiceProvider = Provider<OrganizationService>((ref) {
  return OrganizationService(ref.watch(dioClientProvider));
});

class OrganizationService {
  final DioClient client;
  OrganizationService(this.client);

  // 1. GET /organizations
  Future<List<OrganizationModel>> getMyOrganizations() async {
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.organizations),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data
          .map((item) => OrganizationModel.fromJson(item as Json))
          .toList();
    }
    return [];
  }

  // 2. GET /organizations/:orgId
  Future<OrganizationModel> getOrganization(String orgId) async {
    final res = ResponseClient<Json>(
      await client.get(Endpoints.organization(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return OrganizationModel.fromJson(res.data!);
  }

  // 3. GET /organizations/:orgId/settings
  Future<Json> getSettings(String orgId) async {
    final res = ResponseClient<Json>(
      await client.get(Endpoints.orgSettings(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 4. PATCH /organizations/:orgId/settings
  Future<Json> updateSettings(String orgId, Json settings) async {
    final res = ResponseClient<Json>(
      await client.patch(
        Endpoints.orgSettings(orgId),
        body: settings,
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 5. GET /organizations/:orgId/members
  Future<List<dynamic>> getMembers(String orgId) async {
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.orgMembers(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return (res.data is List) ? res.data as List : [];
  }

  // 6. PATCH /organizations/:orgId/members/:memberId/role
  Future<bool> updateMemberRole(String orgId, String memberId, String role) async {
    final res = ResponseClient<dynamic>(
      await client.patch(
        Endpoints.orgMemberRole(orgId, memberId),
        body: {'role': role},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 7. PATCH /organizations/:orgId/members/:memberId/status
  Future<bool> updateMemberStatus(String orgId, String memberId, String status) async {
    final res = ResponseClient<dynamic>(
      await client.patch(
        Endpoints.orgMemberStatus(orgId, memberId),
        body: {'status': status},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 8. DELETE /organizations/:orgId/members/:memberId
  Future<bool> removeMember(String orgId, String memberId) async {
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.orgMemberDelete(orgId, memberId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 9. POST /organizations/:orgId/invitations
  Future<Json> createInvitation(String orgId, String email, String role) async {
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.orgInvitations(orgId),
        body: {'email': email.trim(), 'role': role},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 10. GET /organizations/:orgId/invitations
  Future<List<dynamic>> getInvitations(String orgId) async {
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.orgInvitations(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return (res.data is List) ? res.data as List : [];
  }

  // 11. DELETE /organizations/:orgId/invitations/:id
  Future<bool> revokeInvitation(String orgId, String invitationId) async {
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.orgInvitationDelete(orgId, invitationId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }
}
