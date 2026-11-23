import 'package:syncup/app/core/constants/typedefs.dart';

class MeetingModel {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetingUrl;
  final String? location;

  const MeetingModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.meetingUrl,
    this.location,
  });

  factory MeetingModel.fromJson(Json json) {
    return MeetingModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Team Sync',
      description: json['description'] as String?,
      startTime: json['startTime'] != null ? DateTime.tryParse(json['startTime']) ?? DateTime.now() : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime']) ?? DateTime.now().add(const Duration(hours: 1))
          : DateTime.now().add(const Duration(hours: 1)),
      meetingUrl: json['meetingUrl'] as String?,
      location: json['location'] as String?,
    );
  }

  Json toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'meetingUrl': meetingUrl,
        'location': location,
      };
}
