import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/empty_state_view.dart';
import 'package:syncup/app/core/widgets/future_provider_builder.dart';
import 'package:syncup/app/features/channels/data/models/channel_model.dart';
import 'package:syncup/app/features/channels/presentation/controller/channels_controller.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class ChatBody extends ConsumerStatefulWidget {
  final String channelId;

  const ChatBody({super.key, required this.channelId});

  @override
  ConsumerState<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends ConsumerState<ChatBody> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(storageServiceProvider).getUser()?['id']?.toString() ?? '';

    return Column(
      children: [
        Expanded(
          child: ref.watchWhen(
            provider: channelMessagesProvider(widget.channelId),
            data: (messages) {
              if (messages.isEmpty) {
                return EmptyStateView(
                  title: tr.channels.noMessages,
                  subtitle: tr.channels.startConversation,
                  icon: Icons.chat_bubble_outline_rounded,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(Constants.horizontalPadding),
                reverse: true,
                itemCount: messages.length,
                separatorBuilder: (_, __) => const Height(12),
                itemBuilder: (context, index) {
                  // reverse order for chat
                  final message = messages[messages.length - 1 - index];
                  final isMe = message.senderId == currentUserId;
                  return _MessageBubble(message: message, isMe: isMe);
                },
              );
            },
          ),
        ),
        const Divider(color: AppColors.borderLight, height: 1),
        _MessageInputField(
          controller: textController,
          onSend: (text) {
            ref.read(channelsProvider).messageInputController.text = text;
            ref.read(channelsProvider).sendMessage(widget.channelId);
            textController.clear();
          },
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.bgSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 2),
            bottomRight: Radius.circular(isMe ? 2 : 12),
          ),
          border: isMe ? null : Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(
                message.senderName,
                style: context.medium10Muted.copyWith(color: AppColors.primary),
              ),
              const Height(2),
            ],
            Text(
              message.content,
              style: isMe ? context.roman14TextMain.copyWith(color: Colors.white) : context.roman14TextMain,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;

  const _MessageInputField({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppColors.bgSurface,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                style: context.roman14TextMain,
                decoration: InputDecoration(
                  hintText: tr.channels.typeMessage,
                  hintStyle: context.roman14Muted,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) onSend(val);
                },
              ),
            ),
          ),
          const Width(8),
          CustomInkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onSend(controller.text);
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
