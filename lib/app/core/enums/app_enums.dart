enum SnackBarStatus {
  success,
  error,
  warning,
  info,
}

enum TaskStatusEnum {
  todo,
  inProgress,
  inReview,
  done;

  String get value {
    switch (this) {
      case TaskStatusEnum.todo:
        return 'TODO';
      case TaskStatusEnum.inProgress:
        return 'IN_PROGRESS';
      case TaskStatusEnum.inReview:
        return 'IN_REVIEW';
      case TaskStatusEnum.done:
        return 'DONE';
    }
  }

  static TaskStatusEnum fromString(String? val) {
    switch (val?.toUpperCase()) {
      case 'IN_PROGRESS':
        return TaskStatusEnum.inProgress;
      case 'IN_REVIEW':
        return TaskStatusEnum.inReview;
      case 'DONE':
        return TaskStatusEnum.done;
      default:
        return TaskStatusEnum.todo;
    }
  }
}

enum TaskPriorityEnum {
  low,
  medium,
  high,
  urgent;

  String get value {
    switch (this) {
      case TaskPriorityEnum.low:
        return 'LOW';
      case TaskPriorityEnum.medium:
        return 'MEDIUM';
      case TaskPriorityEnum.high:
        return 'HIGH';
      case TaskPriorityEnum.urgent:
        return 'URGENT';
    }
  }

  static TaskPriorityEnum fromString(String? val) {
    switch (val?.toUpperCase()) {
      case 'LOW':
        return TaskPriorityEnum.low;
      case 'HIGH':
        return TaskPriorityEnum.high;
      case 'URGENT':
        return TaskPriorityEnum.urgent;
      default:
        return TaskPriorityEnum.medium;
    }
  }
}

enum ProjectStatusEnum {
  active,
  archived,
  completed;

  static ProjectStatusEnum fromString(String? val) {
    switch (val?.toUpperCase()) {
      case 'ARCHIVED':
        return ProjectStatusEnum.archived;
      case 'COMPLETED':
        return ProjectStatusEnum.completed;
      default:
        return ProjectStatusEnum.active;
    }
  }
}
