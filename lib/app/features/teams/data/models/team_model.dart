import 'package:syncup/app/core/constants/typedefs.dart';

class TeamModel {
  final String id;
  final String name;
  final String? description;
  final String? leadId;
  final String? leadName;
  final int memberCount;
  final List<dynamic> members;

  const TeamModel({
    required this.id,
    required this.name,
    this.description,
    this.leadId,
    this.leadName,
    this.memberCount = 0,
    this.members = const [],
  });

  factory TeamModel.fromJson(Json json) {
    String? leadName;
    if (json['lead'] is Map) {
      leadName = json['lead']['name'] as String?;
    }

    final membersList = (json['members'] is List) ? json['members'] as List : [];

    return TeamModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      leadId: json['leadId'] as String?,
      leadName: leadName,
      memberCount: json['memberCount'] as int? ?? json['_count']?['members'] as int? ?? membersList.length,
      members: membersList,
    );
  }

  Json toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'leadId': leadId,
      };
}
