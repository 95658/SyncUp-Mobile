import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/tasks/data/models/task_model.dart';
import 'package:syncup/app/features/tasks/data/service/tasks_service.dart';

// 1. Public Provider
final tasksProvider = Provider<_TasksLogic>(
  (ref) => _TasksLogic(
    ref: ref,
    service: ref.watch(tasksServiceProvider),
  ),
);

// Read-only FutureProvider for single task details
final taskDetailsProvider = FutureProvider.family.autoDispose<TaskModel, String>(
  (ref, taskId) async {
    final service = ref.watch(tasksServiceProvider);
    return service.getTask(taskId);
  },
);

// 2. Logic Implementation
class _TasksLogic extends _TasksStates {
  final TasksService service;

  final createFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  _TasksLogic({
    required super.ref,
    required this.service,
  });

  Future<void> fetchTasks({String? projectId}) async {
    try {
      isLoading.state = true;
      isError.state = '';
      currentProjectId.state = projectId;

      final list = await service.getTasks(projectId: projectId);
      tasks.state = list;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to load tasks';
    } finally {
      isLoading.state = false;
    }
  }

  Future<void> createTask({required String projectId}) async {
    try {
      if (!createFormKey.currentState!.validate()) return;
      isCreating.state = true;
      isError.state = '';

      final newTask = await service.createTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        projectId: projectId,
        priority: selectedPriority.state,
      );

      tasks.state = [newTask, ...tasks.state];
      titleController.clear();
      descriptionController.clear();
      isCreatedSuccess.state = true;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to create task';
    } finally {
      isCreating.state = false;
    }
  }

  Future<void> updateStatus(String taskId, String newStatus) async {
    try {
      final updated = await service.updateTaskStatus(taskId: taskId, status: newStatus);
      tasks.state = tasks.state.map((t) => t.id == taskId ? updated : t).toList();
    } on ApiException catch (e) {
      isError.state = e.toString();
    }
  }

  void setFilterStatus(String? status) {
    selectedFilterStatus.state = status;
  }

  void resetCreatedState() {
    isCreatedSuccess.state = false;
    isError.state = '';
  }
}

// 3. States Definition
class _TasksStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isCreating;
  final CustomState<bool> isCreatedSuccess;
  final CustomState<String> isError;
  final CustomState<List<TaskModel>> tasks;
  final CustomState<String?> currentProjectId;
  final CustomState<String?> selectedFilterStatus;
  final CustomState<String> selectedPriority;

  _TasksStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isCreating = CustomState(ref, false),
        isCreatedSuccess = CustomState(ref, false),
        isError = CustomState(ref, ''),
        tasks = CustomState(ref, []),
        currentProjectId = CustomState(ref, null),
        selectedFilterStatus = CustomState(ref, null),
        selectedPriority = CustomState(ref, 'MEDIUM');
}
