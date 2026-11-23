import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/projects/data/models/project_model.dart';
import 'package:syncup/app/services/storage_service.dart';

final projectsServiceProvider = Provider<ProjectsService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ProjectsService(ref.watch(dioClientProvider), storageService);
});

class ProjectsService {
  final DioClient client;
  final StorageService storageService;

  ProjectsService(this.client, this.storageService);

  String _getOrgId() {
    final orgId = storageService.getActiveOrgId();
    if (orgId == null || orgId.isEmpty) {
      throw ApiExceptionMessage('No active organization selected');
    }
    return orgId;
  }

  // 1. GET /organizations/:orgId/projects
  Future<List<ProjectModel>> getProjects() async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.projects(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => ProjectModel.fromJson(item as Json)).toList();
    }
    return [];
  }

  // 2. GET /organizations/:orgId/projects/:id
  Future<ProjectModel> getProject(String projectId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.get(Endpoints.project(orgId, projectId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return ProjectModel.fromJson(res.data!);
  }

  // 3. POST /organizations/:orgId/projects
  Future<ProjectModel> createProject({
    required String name,
    String? description,
  }) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.projects(orgId),
        body: {
          'name': name.trim(),
          if (description != null && description.isNotEmpty)
            'description': description.trim(),
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return ProjectModel.fromJson(res.data!);
  }

  // 4. PATCH /organizations/:orgId/projects/:id
  Future<ProjectModel> updateProject(String projectId, Map<String, dynamic> data) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.patch(
        Endpoints.project(orgId, projectId),
        body: data,
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return ProjectModel.fromJson(res.data!);
  }

  // 5. DELETE /organizations/:orgId/projects/:id
  Future<bool> deleteProject(String projectId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.project(orgId, projectId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 6. GET /organizations/:orgId/projects/:id/members
  Future<List<dynamic>> getProjectMembers(String projectId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.projectMembers(orgId, projectId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return (res.data is List) ? res.data as List : [];
  }

  // 7. POST /organizations/:orgId/projects/:id/members
  Future<bool> addProjectMember(String projectId, String userId, {String? role}) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.post(
        Endpoints.projectMembers(orgId, projectId),
        body: {'userId': userId, if (role != null) 'role': role},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 8. DELETE /organizations/:orgId/projects/:id/members/:memberId
  Future<bool> removeProjectMember(String projectId, String memberId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.projectMemberDelete(orgId, projectId, memberId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 9. GET /organizations/:orgId/projects/:id/documents
  Future<List<dynamic>> getProjectDocuments(String projectId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.projectDocuments(orgId, projectId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return (res.data is List) ? res.data as List : [];
  }

  // 10. POST /organizations/:orgId/projects/:id/documents
  Future<Json> uploadProjectDocument(String projectId, String title, String fileUrl) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.projectDocuments(orgId, projectId),
        body: {'title': title, 'fileUrl': fileUrl},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 11. GET /organizations/:orgId/projects/:id/analytics
  Future<Json> getProjectAnalytics(String projectId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.get(Endpoints.projectAnalytics(orgId, projectId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }
}
