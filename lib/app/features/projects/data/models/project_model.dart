import 'package:syncup/app/core/constants/typedefs.dart';

class ProjectModel {
  final String id;
  final String name;
  final String? description;
  final String status;
  final String organizationId;
  final int tasksCount;
  final int membersCount;

  const ProjectModel({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.organizationId,
    this.tasksCount = 0,
    this.membersCount = 0,
  });

  factory ProjectModel.fromJson(Json json) {
    int tasks = 0;
    if (json['_count'] is Map && json['_count']['tasks'] != null) {
      tasks = int.tryParse(json['_count']['tasks'].toString()) ?? 0;
    } else if (json['tasksCount'] != null) {
      tasks = int.tryParse(json['tasksCount'].toString()) ?? 0;
    }

    int members = 0;
    if (json['_count'] is Map && json['_count']['members'] != null) {
      members = int.tryParse(json['_count']['members'].toString()) ?? 0;
    } else if (json['membersCount'] != null) {
      members = int.tryParse(json['membersCount'].toString()) ?? 0;
    }

    return ProjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      organizationId: json['organizationId']?.toString() ?? '',
      tasksCount: tasks,
      membersCount: members,
    );
  }

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'organizationId': organizationId,
    };
  }
}
