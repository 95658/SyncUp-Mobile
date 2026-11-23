import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/widgets/app_bars/default_app_bar.dart';
import 'package:syncup/app/features/settings/presentation/widgets/settings_body.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: tr.settings.title,
        showBack: false,
      ),
      body: const SafeArea(
        child: SettingsBody(),
      ),
    );
  }
}
