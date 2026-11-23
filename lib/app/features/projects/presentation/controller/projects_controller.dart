import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/projects/data/models/project_model.dart';
import 'package:syncup/app/features/projects/data/service/projects_service.dart';

// 1. Public Provider
final projectsProvider = Provider<_ProjectsLogic>(
  (ref) => _ProjectsLogic(
    ref: ref,
    service: ref.watch(projectsServiceProvider),
  ),
);

// Read-only FutureProvider
final projectsFutureProvider = FutureProvider.autoDispose<List<ProjectModel>>((ref) async {
  final service = ref.watch(projectsServiceProvider);
  return service.getProjects();
});

// 2. Logic Implementation
class _ProjectsLogic extends _ProjectsStates {
  final ProjectsService service;

  final createFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  _ProjectsLogic({
    required super.ref,
    required this.service,
  });

  Future<void> fetchProjects() async {
    try {
      isLoading.state = true;
      isError.state = '';
      final list = await service.getProjects();
      projects.state = list;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to load projects';
    } finally {
      isLoading.state = false;
    }
  }

  Future<void> createProject() async {
    try {
      if (!createFormKey.currentState!.validate()) return;
      isCreating.state = true;
      isError.state = '';

      final newProject = await service.createProject(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
      );

      // Add to existing list
      projects.state = [newProject, ...projects.state];
      nameController.clear();
      descriptionController.clear();
      isCreatedSuccess.state = true;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to create project';
    } finally {
      isCreating.state = false;
    }
  }

  void resetCreatedState() {
    isCreatedSuccess.state = false;
    isError.state = '';
  }
}

// 3. States Definition
class _ProjectsStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isCreating;
  final CustomState<bool> isCreatedSuccess;
  final CustomState<String> isError;
  final CustomState<List<ProjectModel>> projects;

  _ProjectsStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isCreating = CustomState(ref, false),
        isCreatedSuccess = CustomState(ref, false),
        isError = CustomState(ref, ''),
        projects = CustomState(ref, []);
}
