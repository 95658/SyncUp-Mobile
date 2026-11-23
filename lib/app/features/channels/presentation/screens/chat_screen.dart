import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/features/channels/presentation/widgets/chat_body.dart';

@RoutePage()
class ChatScreen extends ConsumerWidget {
  final String channelId;
  final String channelName;

  const ChatScreen({
    super.key,
    required this.channelId,
    required this.channelName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: '#$channelName',
      ),
      body: SafeArea(
        child: ChatBody(channelId: channelId),
      ),
    );
  }
}
