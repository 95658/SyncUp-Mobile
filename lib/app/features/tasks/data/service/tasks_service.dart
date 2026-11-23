import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/tasks/data/models/task_model.dart';
import 'package:syncup/app/services/storage_service.dart';

final tasksServiceProvider = Provider<TasksService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return TasksService(ref.watch(dioClientProvider), storageService);
});

class TasksService {
  final DioClient client;
  final StorageService storageService;

  TasksService(this.client, this.storageService);

  String _getOrgId() {
    final orgId = storageService.getActiveOrgId();
    if (orgId == null || orgId.isEmpty) {
      throw ApiExceptionMessage('No active organization selected');
    }
    return orgId;
  }

  Future<List<TaskModel>> getTasks({String? projectId}) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(
        Endpoints.tasks(orgId),
        queryParameters: {
          if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => TaskModel.fromJson(item as Json)).toList();
    }
    return [];
  }

  Future<TaskModel> getTask(String taskId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.get(Endpoints.task(orgId, taskId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return TaskModel.fromJson(res.data!);
  }

  Future<TaskModel> createTask({
    required String title,
    String? description,
    required String projectId,
    String? priority,
    String? dueDate,
  }) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.tasks(orgId),
        body: {
          'title': title.trim(),
          if (description != null && description.isNotEmpty)
            'description': description.trim(),
          'projectId': projectId,
          if (priority != null) 'priority': priority,
          if (dueDate != null) 'dueDate': dueDate,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return TaskModel.fromJson(res.data!);
  }

  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.patch(
        Endpoints.task(orgId, taskId),
        body: {
          'status': status,
        },
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return TaskModel.fromJson(res.data!);
  }

  // 1. Full update task
  Future<TaskModel> updateTask(String taskId, Map<String, dynamic> data) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.patch(
        Endpoints.task(orgId, taskId),
        body: data,
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return TaskModel.fromJson(res.data!);
  }

  // 2. Delete task
  Future<bool> deleteTask(String taskId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.delete(Endpoints.task(orgId, taskId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 3. Create subtask
  Future<Json> addSubtask(String taskId, String title) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.taskSubtasks(orgId, taskId),
        body: {'title': title.trim()},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 4. Toggle subtask
  Future<Json> toggleSubtask(String taskId, String subtaskId, bool completed) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.patch(
        Endpoints.taskSubtask(orgId, taskId, subtaskId),
        body: {'completed': completed},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }

  // 5. Add comment
  Future<Json> addComment(String taskId, String content) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.taskComments(orgId, taskId),
        body: {'content': content.trim()},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return res.data ?? {};
  }
}
