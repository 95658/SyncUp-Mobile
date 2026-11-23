import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/api_helper/exceptions.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/features/channels/data/models/channel_model.dart';
import 'package:syncup/app/features/channels/data/service/channels_service.dart';

// 1. Public Provider
final channelsProvider = Provider<_ChannelsLogic>(
  (ref) => _ChannelsLogic(
    ref: ref,
    service: ref.watch(channelsServiceProvider),
  ),
);

// Read-only FutureProvider for messages in a channel
final channelMessagesProvider = FutureProvider.family.autoDispose<List<MessageModel>, String>(
  (ref, channelId) async {
    final service = ref.watch(channelsServiceProvider);
    return service.getMessages(channelId);
  },
);

// 2. Logic Implementation
class _ChannelsLogic extends _ChannelsStates {
  final ChannelsService service;
  final messageInputController = TextEditingController();

  _ChannelsLogic({
    required super.ref,
    required this.service,
  });

  Future<void> fetchChannels() async {
    try {
      isLoading.state = true;
      isError.state = '';
      final list = await service.getChannels();
      channels.state = list;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } catch (e) {
      isError.state = 'Failed to load channels';
    } finally {
      isLoading.state = false;
    }
  }

  Future<void> loadMessages(String channelId) async {
    try {
      isLoadingMessages.state = true;
      activeChannelId.state = channelId;
      final msgs = await service.getMessages(channelId);
      messages.state = msgs;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } finally {
      isLoadingMessages.state = false;
    }
  }

  Future<void> sendMessage(String channelId) async {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    try {
      isSending.state = true;
      messageInputController.clear();

      final sentMessage = await service.sendMessage(channelId, text);
      messages.state = [...messages.state, sentMessage];
    } on ApiException catch (e) {
      isError.state = e.toString();
    } finally {
      isSending.state = false;
    }
  }
}

// 3. States Definition
class _ChannelsStates {
  final Ref ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> isLoadingMessages;
  final CustomState<bool> isSending;
  final CustomState<String> isError;
  final CustomState<List<ChannelModel>> channels;
  final CustomState<List<MessageModel>> messages;
  final CustomState<String?> activeChannelId;

  _ChannelsStates({required this.ref})
      : isLoading = CustomState(ref, false),
        isLoadingMessages = CustomState(ref, false),
        isSending = CustomState(ref, false),
        isError = CustomState(ref, ''),
        channels = CustomState(ref, []),
        messages = CustomState(ref, []),
        activeChannelId = CustomState(ref, null);
}
