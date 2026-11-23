import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/teams/data/models/team_model.dart';
import 'package:syncup/app/services/storage_service.dart';

final teamsServiceProvider = Provider<TeamsService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return TeamsService(ref.watch(dioClientProvider), storageService);
});

class TeamsService {
  final DioClient client;
  final StorageService storageService;

  TeamsService(this.client, this.storageService);

  String _getOrgId() {
    final orgId = storageService.getActiveOrgId();
    if (orgId == null || orgId.isEmpty) {
      throw ApiExceptionMessage('No active organization selected');
    }
    return orgId;
  }

  // 1. GET /organizations/:orgId/teams
  Future<List<TeamModel>> getTeams() async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.teams(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => TeamModel.fromJson(item as Json)).toList();
    }
    return [];
  }

  // 2. GET /organizations/:orgId/teams/:id
  Future<TeamModel> getTeam(String teamId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.get(Endpoints.team(orgId, teamId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return TeamModel.fromJson(res.data!);
  }

  // 3. POST /organizations/:orgId/teams
  Future<TeamModel> createTeam({
    required String name,
    String? description,
    String? leadId,
  }) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.teams(orgId),
        body: {
          'name': name.trim(),
          if (description != null && description.isNotEmpty) 'description': description.trim(),
          if (leadId != null && leadId.isNotEmpty) 'leadId': leadId,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return TeamModel.fromJson(res.data!);
  }

  // 4. PATCH /organizations/:orgId/teams/:id
  Future<TeamModel> updateTeam(
    String teamId, {
    String? name,
    String? description,
    String? leadId,
  }) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.patch(
        Endpoints.team(orgId, teamId),
        body: {
          if (name != null) 'name': name.trim(),
          if (description != null) 'description': description.trim(),
          if (leadId != null) 'leadId': leadId,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return TeamModel.fromJson(res.data!);
  }

  // 5. DELETE /organizations/:orgId/teams/:id
  Future<bool> deleteTeam(String teamId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.team(orgId, teamId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 6. POST /organizations/:orgId/teams/:id/members
  Future<bool> addMember(String teamId, String memberId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.post(
        Endpoints.teamMembers(orgId, teamId),
        body: {'memberId': memberId},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 7. DELETE /organizations/:orgId/teams/:id/members/:memberId
  Future<bool> removeMember(String teamId, String memberId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.teamMemberDelete(orgId, teamId, memberId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }
}
