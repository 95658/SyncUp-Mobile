class Constants {
  Constants._();

  // Dimensions
  static const double borderRadius = 8.0;
  static const double buttonHeight = 48.0;
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 16.0;

  // Storage Keys
  static const String tokenKey = 'syncup_access_token';
  static const String refreshTokenKey = 'syncup_refresh_token';
  static const String userKey = 'syncup_user_data';
  static const String activeOrgIdKey = 'syncup_active_org_id';
  static const String activeOrgNameKey = 'syncup_active_org_name';
  static const String localeKey = 'syncup_app_locale';
  static const String themeKey = 'syncup_app_theme';
  static const String serverUrlKey = 'syncup_server_url';

  // API Config (Live Production Cloudflare/cPanel API)
  static const String productionBaseUrl = 'https://syncup.syntiqtech.com/api/v1';

  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) return envUrl;
    return productionBaseUrl;
  }
}
