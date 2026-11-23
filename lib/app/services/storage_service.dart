import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncup/app/core/constants/constants.dart';
import 'package:syncup/app/core/constants/typedefs.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(
    prefs: ref.watch(sharedPreferencesProvider),
    secureStorage: const FlutterSecureStorage(),
  );
});

class StorageService {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  StorageService({
    required this.prefs,
    required this.secureStorage,
  });

  // Token management
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await secureStorage.write(key: Constants.tokenKey, value: accessToken);
    if (refreshToken != null) {
      await secureStorage.write(key: Constants.refreshTokenKey, value: refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: Constants.tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: Constants.refreshTokenKey);
  }

  Future<void> clearAuthData() async {
    await secureStorage.delete(key: Constants.tokenKey);
    await secureStorage.delete(key: Constants.refreshTokenKey);
    await prefs.remove(Constants.userKey);
    await prefs.remove(Constants.activeOrgIdKey);
    await prefs.remove(Constants.activeOrgNameKey);
  }

  // Active Organization
  String? getActiveOrgId() {
    return prefs.getString(Constants.activeOrgIdKey);
  }

  Future<void> setActiveOrg({required String orgId, required String orgName}) async {
    await prefs.setString(Constants.activeOrgIdKey, orgId);
    await prefs.setString(Constants.activeOrgNameKey, orgName);
  }

  String? getActiveOrgName() {
    return prefs.getString(Constants.activeOrgNameKey);
  }

  // User Profile
  Future<void> saveUser(Json userJson) async {
    await prefs.setString(Constants.userKey, jsonEncode(userJson));
  }

  Json? getUser() {
    final raw = prefs.getString(Constants.userKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Json;
    } catch (_) {
      return null;
    }
  }

  // Locale
  String? getLocale() {
    return prefs.getString(Constants.localeKey);
  }

  Future<void> setLocale(String localeCode) async {
    await prefs.setString(Constants.localeKey, localeCode);
  }

  // Server Base URL
  String? getServerUrl() {
    return prefs.getString(Constants.serverUrlKey);
  }

  Future<void> setServerUrl(String url) async {
    await prefs.setString(Constants.serverUrlKey, url);
  }
}
