import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/dio_client.dart';
import 'package:syncup/app/core/api_helper/endpoints.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/api_helper/response_client.dart';
import 'package:syncup/app/core/constants/typedefs.dart';
import 'package:syncup/app/features/channels/data/models/channel_model.dart';
import 'package:syncup/app/services/storage_service.dart';

final channelsServiceProvider = Provider<ChannelsService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ChannelsService(ref.watch(dioClientProvider), storageService);
});

class ChannelsService {
  final DioClient client;
  final StorageService storageService;

  ChannelsService(this.client, this.storageService);

  String _getOrgId() {
    final orgId = storageService.getActiveOrgId();
    if (orgId == null || orgId.isEmpty) {
      throw ApiExceptionMessage('No active organization selected');
    }
    return orgId;
  }

  Future<List<ChannelModel>> getChannels() async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.channels(orgId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => ChannelModel.fromJson(item as Json)).toList();
    }
    return [];
  }

  Future<ChannelModel> createChannel(String name, {bool isPrivate = false}) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.channels(orgId),
        body: {'name': name.trim(), 'isPrivate': isPrivate},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return ChannelModel.fromJson(res.data!);
  }

  Future<List<MessageModel>> getMessages(String channelId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.channelMessages(orgId, channelId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => MessageModel.fromJson(item as Json)).toList();
    }
    return [];
  }

  Future<MessageModel> sendMessage(String channelId, String content) async {
    final orgId = _getOrgId();
    final res = ResponseClient<Json>(
      await client.post(
        Endpoints.channelMessages(orgId, channelId),
        body: {'content': content.trim()},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return MessageModel.fromJson(res.data!);
  }

  // 1. POST /organizations/:orgId/messages/:messageId/reactions
  Future<bool> addReaction(String messageId, String emoji) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.post(
        Endpoints.messageReactions(orgId, messageId),
        body: {'emoji': emoji},
      ),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    return true;
  }

  // 2. GET /organizations/:orgId/messages/:messageId/thread
  Future<List<MessageModel>> getMessageThread(String messageId) async {
    final orgId = _getOrgId();
    final res = ResponseClient<dynamic>(
      await client.get(Endpoints.messageThread(orgId, messageId)),
    );

    if (res.isError) {
      throw ApiExceptionMessage(res.message, statusCode: res.statusCode);
    }

    final data = res.data;
    if (data is List) {
      return data.map((item) => MessageModel.fromJson(item as Json)).toList();
    }
    return [];
  }
}
