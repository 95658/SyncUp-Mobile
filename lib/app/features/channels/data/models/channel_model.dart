import 'package:syncup/app/core/constants/typedefs.dart';

class ChannelModel {
  final String id;
  final String name;
  final String type; // PUBLIC, PRIVATE, DM
  final String? description;
  final int unreadCount;

  const ChannelModel({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.unreadCount = 0,
  });

  factory ChannelModel.fromJson(Json json) {
    return ChannelModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'PUBLIC',
      description: json['description']?.toString(),
      unreadCount: int.tryParse(json['unreadCount']?.toString() ?? '0') ?? 0,
    );
  }

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }
}

class MessageModel {
  final String id;
  final String content;
  final String createdAt;
  final String senderId;
  final String senderName;
  final String? senderAvatar;

  const MessageModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
  });

  factory MessageModel.fromJson(Json json) {
    String name = 'User';
    String? avatar;
    if (json['sender'] is Map) {
      name = json['sender']['fullName']?.toString() ?? json['sender']['name']?.toString() ?? 'User';
      avatar = json['sender']['avatarUrl']?.toString();
    } else if (json['user'] is Map) {
      name = json['user']['fullName']?.toString() ?? json['user']['name']?.toString() ?? 'User';
      avatar = json['user']['avatarUrl']?.toString();
    }

    return MessageModel(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? json['userId']?.toString() ?? '',
      senderName: name,
      senderAvatar: avatar,
    );
  }
}
