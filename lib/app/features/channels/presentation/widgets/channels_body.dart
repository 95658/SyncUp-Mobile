import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/buttons/custom_ink_well.dart';
import 'package:syncup/app/core/widgets/common/empty_state_view.dart';
import 'package:syncup/app/core/widgets/common/shimmer_box.dart';
import 'package:syncup/app/features/channels/data/models/channel_model.dart';
import 'package:syncup/app/features/channels/presentation/controller/channels_controller.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class ChannelsBody extends ConsumerWidget {
  const ChannelsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.read(channelsProvider);
    final isLoading = ref.watch(logic.isLoading.provider);
    final channels = ref.watch(logic.channels.provider);

    if (isLoading && channels.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: 5,
        separatorBuilder: (_, __) => const Height(10),
        itemBuilder: (_, __) => const ShimmerBox(height: 64),
      );
    }

    if (channels.isEmpty) {
      return EmptyStateView(
        title: tr.channels.noChannels,
        subtitle: tr.channels.noChannelsSubtitle,
        icon: Icons.chat_bubble_outline_rounded,
        actionTitle: tr.common.retry,
        onAction: logic.fetchChannels,
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: logic.fetchChannels,
      child: ListView.separated(
        padding: const EdgeInsets.all(Constants.horizontalPadding),
        itemCount: channels.length,
        separatorBuilder: (_, __) => const Height(8),
        itemBuilder: (context, index) {
          final channel = channels[index];
          return _ChannelTile(channel: channel);
        },
      ),
    );
  }
}

class _ChannelTile extends StatelessWidget {
  final ChannelModel channel;

  const _ChannelTile({required this.channel});

  @override
  Widget build(BuildContext context) {
    final isPrivate = channel.type == 'PRIVATE';

    return CustomInkWell(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      onTap: () {
        context.push(ChatRoute(channelId: channel.id, channelName: channel.name));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isPrivate ? Icons.lock_outline_rounded : Icons.tag_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
            const Width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name,
                    style: context.bold14TextMain,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (channel.description != null && channel.description!.isNotEmpty) ...[
                    const Height(2),
                    Text(
                      channel.description!,
                      style: context.roman12Secondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (channel.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${channel.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Width(4),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
