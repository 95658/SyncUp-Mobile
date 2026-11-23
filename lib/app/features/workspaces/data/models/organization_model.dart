import 'package:syncup/app/core/constants/typedefs.dart';

class OrganizationModel {
  final String id;
  final String name;
  final String slug;
  final String? logoUrl;
  final String plan;
  final String status;
  final String? role;
  final int memberCount;
  final int projectCount;
  final int teamCount;
  final int channelCount;
  final String? adminName;
  final String? adminEmail;
  final String? createdAt;

  const OrganizationModel({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
    required this.plan,
    required this.status,
    this.role,
    this.memberCount = 1,
    this.projectCount = 0,
    this.teamCount = 0,
    this.channelCount = 0,
    this.adminName,
    this.adminEmail,
    this.createdAt,
  });

  factory OrganizationModel.fromJson(Json json) {
    // When returned from memberships query, org might be under 'organization' key
    final org = json['organization'] is Map<String, dynamic>
        ? json['organization'] as Json
        : json;

    final count = (org['_count'] is Map) ? org['_count'] as Map<String, dynamic> : null;
    final membersList = (org['members'] is List) ? org['members'] as List : null;
    Map<String, dynamic>? ownerUser;
    if (membersList != null && membersList.isNotEmpty) {
      final first = membersList[0];
      if (first is Map && first['user'] is Map) {
        ownerUser = (first['user'] as Map).cast<String, dynamic>();
      }
    }

    final int mCount = (count?['members'] as num?)?.toInt() ??
        (org['memberCount'] as num?)?.toInt() ??
        1;
    final int pCount = (count?['projects'] as num?)?.toInt() ??
        (org['projectCount'] as num?)?.toInt() ??
        0;
    final int tCount = (count?['teams'] as num?)?.toInt() ??
        (org['teamCount'] as num?)?.toInt() ??
        0;
    final int cCount = (count?['channels'] as num?)?.toInt() ??
        (org['channelCount'] as num?)?.toInt() ??
        0;

    return OrganizationModel(
      id: org['id']?.toString() ?? '',
      name: org['name']?.toString() ?? '',
      slug: org['slug']?.toString() ?? '',
      logoUrl: org['logoUrl']?.toString() ?? org['logo']?.toString(),
      plan: org['plan']?.toString() ?? 'STARTER',
      status: org['status']?.toString() ?? 'ACTIVE',
      role: json['role']?.toString(),
      memberCount: mCount,
      projectCount: pCount,
      teamCount: tCount,
      channelCount: cCount,
      adminName: ownerUser?['fullName']?.toString() ?? org['adminName']?.toString(),
      adminEmail: ownerUser?['email']?.toString() ?? org['adminEmail']?.toString(),
      createdAt: org['createdAt']?.toString(),
    );
  }

  OrganizationModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? logoUrl,
    String? plan,
    String? status,
    String? role,
    int? memberCount,
    int? projectCount,
    int? teamCount,
    int? channelCount,
    String? adminName,
    String? adminEmail,
    String? createdAt,
  }) {
    return OrganizationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      logoUrl: logoUrl ?? this.logoUrl,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      role: role ?? this.role,
      memberCount: memberCount ?? this.memberCount,
      projectCount: projectCount ?? this.projectCount,
      teamCount: teamCount ?? this.teamCount,
      channelCount: channelCount ?? this.channelCount,
      adminName: adminName ?? this.adminName,
      adminEmail: adminEmail ?? this.adminEmail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logoUrl': logoUrl,
      'plan': plan,
      'status': status,
      'role': role,
      'memberCount': memberCount,
      'projectCount': projectCount,
      'teamCount': teamCount,
      'channelCount': channelCount,
      'adminName': adminName,
      'adminEmail': adminEmail,
      'createdAt': createdAt,
    };
  }
}
