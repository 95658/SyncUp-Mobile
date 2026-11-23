import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/themes/app_theme.dart';
import 'package:syncup/app/core/themes/theme_provider.dart';
import 'package:syncup/app/router/auto_router.dart';
import 'package:syncup/app/services/notification_service.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Slang i18n
  final savedLocale = sharedPreferences.getString(Constants.localeKey);
  if (savedLocale != null && savedLocale.isNotEmpty) {
    final matchedLocale = AppLocale.values.firstWhere(
      (l) => l.languageCode == savedLocale,
      orElse: () => AppLocale.en,
    );
    LocaleSettings.setLocale(matchedLocale);
  } else {
    LocaleSettings.useDeviceLocale();
  }

  runApp(
    TranslationProvider(
      child: ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const SyncUpApp(),
      ),
    ),
  );
}

class SyncUpApp extends ConsumerStatefulWidget {
  const SyncUpApp({super.key});

  @override
  ConsumerState<SyncUpApp> createState() => _SyncUpAppState();
}

class _SyncUpAppState extends ConsumerState<SyncUpApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: tr.app_name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _appRouter.config(),
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
