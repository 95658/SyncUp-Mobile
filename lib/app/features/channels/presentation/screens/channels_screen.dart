import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/enums/app_enums.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/features/channels/presentation/controller/channels_controller.dart';
import 'package:syncup/app/features/channels/presentation/widgets/channels_body.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  @override
  ConsumerState<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(channelsProvider).fetchChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    listeners(ref, context);

    return Scaffold(
      appBar: DefaultAppBar(
        title: tr.channels.title,
        showBack: false,
      ),
      body: const SafeArea(
        child: ChannelsBody(),
      ),
    );
  }

  void listeners(WidgetRef ref, BuildContext context) {
    final provider = ref.read(channelsProvider);

    ref.listen(provider.isError.provider, (previous, current) {
      if (current.isNotEmpty) {
        context.showCustomSnackBar(
          message: current,
          snackBarStatus: SnackBarStatus.error,
        );
      }
    });
  }
}
