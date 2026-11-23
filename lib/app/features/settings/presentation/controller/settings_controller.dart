import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/models/custom_state.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

final settingsProvider = Provider<_SettingsLogic>(
  (ref) => _SettingsLogic(
    ref: ref,
    storageService: ref.watch(storageServiceProvider),
  ),
);

class _SettingsLogic extends _SettingsStates {
  final StorageService storageService;

  _SettingsLogic({
    required super.ref,
    required this.storageService,
  }) {
    final savedLocale = storageService.getLocale();
    if (savedLocale != null) {
      currentLocale.state = savedLocale;
    }
  }

  Future<void> changeLanguage(AppLocale locale) async {
    LocaleSettings.setLocale(locale);
    currentLocale.state = locale.languageCode;
    await storageService.setLocale(locale.languageCode);
  }
}

class _SettingsStates {
  final Ref ref;
  final CustomState<String> currentLocale;

  _SettingsStates({required this.ref})
      : currentLocale = CustomState(ref, 'en');
}
