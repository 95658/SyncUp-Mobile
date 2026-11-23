import 'package:syncup/app/core/constants/typedefs.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String? dueDate;
  final String projectId;
  final String? projectName;
  final String? assigneeId;
  final String? assigneeName;
  final String? assigneeAvatar;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.projectId,
    this.projectName,
    this.assigneeId,
    this.assigneeName,
    this.assigneeAvatar,
  });

  factory TaskModel.fromJson(Json json) {
    String? projName;
    if (json['project'] is Map) {
      projName = json['project']['name']?.toString();
    }

    String? aName;
    String? aAvatar;
    if (json['assignee'] is Map) {
      aName = json['assignee']['fullName']?.toString() ?? json['assignee']['name']?.toString();
      aAvatar = json['assignee']['avatarUrl']?.toString();
    }

    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString() ?? 'TODO',
      priority: json['priority']?.toString() ?? 'MEDIUM',
      dueDate: json['dueDate']?.toString(),
      projectId: json['projectId']?.toString() ?? '',
      projectName: projName,
      assigneeId: json['assigneeId']?.toString(),
      assigneeName: aName,
      assigneeAvatar: aAvatar,
    );
  }

  Json toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate,
      'projectId': projectId,
      'assigneeId': assigneeId,
    };
  }
}
