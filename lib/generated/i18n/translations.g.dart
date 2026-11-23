/// Generated file. Do not edit.
///
/// Original: assets/lang
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 424 (212 per locale)
///
/// Built on 2026-11-15 at 00:32 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	ar(languageCode: 'ar', build: _TranslationsAr.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of tr).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = tr.someKey.anotherKey;
/// String b = tr['someKey.anotherKey']; // Only for edge cases!
Translations get tr => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final tr = Translations.of(context); // Get tr variable.
/// String a = tr.someKey.anotherKey; // Use tr variable.
/// String b = tr['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.tr.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get tr => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final tr = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get app_name => 'SyncUp';
	late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
	late final _TranslationsAuthEn auth = _TranslationsAuthEn._(_root);
	late final _TranslationsWorkspaceEn workspace = _TranslationsWorkspaceEn._(_root);
	late final _TranslationsSuperAdminEn superAdmin = _TranslationsSuperAdminEn._(_root);
	late final _TranslationsTeamsEn teams = _TranslationsTeamsEn._(_root);
	late final _TranslationsCalendarEn calendar = _TranslationsCalendarEn._(_root);
	late final _TranslationsProjectsEn projects = _TranslationsProjectsEn._(_root);
	late final _TranslationsTasksEn tasks = _TranslationsTasksEn._(_root);
	late final _TranslationsChannelsEn channels = _TranslationsChannelsEn._(_root);
	late final _TranslationsNotificationsEn notifications = _TranslationsNotificationsEn._(_root);
	late final _TranslationsSettingsEn settings = _TranslationsSettingsEn._(_root);
	late final _TranslationsOnboardingEn onboarding = _TranslationsOnboardingEn._(_root);
	late final _TranslationsSplashEn splash = _TranslationsSplashEn._(_root);
}

// Path: common
class _TranslationsCommonEn {
	_TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cancel => 'Cancel';
	String get submit => 'Submit';
	String get save => 'Save';
	String get delete => 'Delete';
	String get edit => 'Edit';
	String get back => 'Back';
	String get retry => 'Retry';
	String get error => 'Error';
	String get loading => 'Loading...';
	String get success => 'Success';
	String get search => 'Search';
	String get filter => 'Filter';
	String get noData => 'No data available';
	String get seeAll => 'See All';
	String get close => 'Close';
	String get confirm => 'Confirm';
	String get skip => 'Skip';
	String get all => 'All';
	String get manage => 'Manage';
	String get open => 'Open';
	String get status => 'Status';
	String get name => 'Name';
	String get description => 'Description';
	String get email => 'Email';
	String get actions => 'Actions';
	String get preferences => 'Preferences';
	String get account => 'Account';
	String get getStarted => 'Get Started';
	String get next => 'Next';
	String get activeWorkspace => 'Active Workspace';
	String get general => 'General';
	String get unassigned => 'Unassigned';
	String get darkMode => 'Dark Mode';
	String get lightMode => 'Light Mode';
	String get photoUrl => 'Profile Photo URL';
	String get avatarUrl => 'Avatar Image URL';
}

// Path: auth
class _TranslationsAuthEn {
	_TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get login => 'Sign In';
	String get register => 'Create Account';
	String get email => 'Email Address';
	String get password => 'Password';
	String get confirmPassword => 'Confirm Password';
	String get fullName => 'Full Name';
	String get organizationCode => 'Organization Code';
	String get forgotPassword => 'Forgot Password?';
	String get logout => 'Sign Out';
	String get welcomeBack => 'Welcome Back';
	String get signInSubtitle => 'Sign in to access your workspaces and team tasks';
	String get noAccount => 'Don\'t have an account?';
	String get haveAccount => 'Already have an account?';
	String get emailRequired => 'Email is required';
	String get invalidEmail => 'Please enter a valid email';
	String get passwordRequired => 'Password is required';
	String get passwordTooShort => 'Password must be at least 6 characters';
	String get loginSuccess => 'Signed in successfully';
	String get logoutConfirm => 'Are you sure you want to sign out?';
	String get invitationOnlyNotice => 'SyncUp is an invitation-only workspace.';
	String get serverConnectionError => 'Unable to connect to backend server at:';
	String get ensureBackendRunning => 'Please ensure the backend is running.';
	String get unexpectedError => 'An unexpected error occurred';
}

// Path: workspace
class _TranslationsWorkspaceEn {
	_TranslationsWorkspaceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Workspaces';
	String get switchWorkspace => 'Switch Workspace';
	String get current => 'Current Workspace';
	String get members => 'Members';
	String get teams => 'Teams';
	String get role => 'Role';
	String get owner => 'Owner';
	String get admin => 'Admin';
	String get member => 'Member';
	String get noWorkspaces => 'No Workspaces Found';
	String get noWorkspacesSubtitle => 'You do not belong to any organization yet. Please check your invitation.';
	String get failedToLoad => 'Failed to load workspaces';
}

// Path: superAdmin
class _TranslationsSuperAdminEn {
	_TranslationsSuperAdminEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get controlPlane => 'Control Plane';
	String get dashboardTitle => 'Super Admin Dashboard';
	String get dashboardSubtitle => 'Global platform governance, client organization provisioning, and tenant access.';
	String get paidRevenue => 'Paid Revenue';
	String get erpIncome => 'ERP Income';
	String get clientOrgs => 'Client Orgs';
	String get enterprise => 'Enterprise';
	String get platformUsers => 'Platform Users';
	String get verified => 'Verified';
	String get engineStatus => 'Engine Status';
	String get operational => 'Operational';
	String get activeClientTenants => 'Active Client Tenants';
	String get provisionTenant => 'Provision Tenant';
	String get provisionModalTitle => 'Provision New Enterprise Tenant';
	String get companyName => 'Company / Organization Name';
	String get companyNameHint => 'e.g. Acme Corporation';
	String get primaryAdminName => 'Primary Admin Name';
	String get primaryAdminNameHint => 'e.g. Jane Doe';
	String get adminWorkEmail => 'Admin Work Email';
	String get adminWorkEmailHint => 'admin@acme.com';
	String get tenantResources => 'Tenant Resources & Member Statistics';
	String get totalMembers => 'Total Members';
	String get activeProjects => 'Active Projects';
	String get workTeams => 'Work Teams';
	String get chatChannels => 'Chat Channels';
	String get primaryAdminLead => 'Primary Administrator Lead';
	String get tenantId => 'Tenant ID';
	String get slug => 'slug';
	String get suspendOrg => 'Suspend Organization';
	String get reactivateOrg => 'Reactivate Organization';
	String get deleteOrg => 'Delete Organization';
	String get deleteOrgConfirmTitle => 'Delete Organization?';
	String get deleteOrgConfirmMessage => 'Are you sure you want to permanently delete this client enterprise organization? All associated data, members, projects, and channels will be removed.';
	String get deletePermanently => 'Delete Permanently';
	String get inspectWorkspace => 'Inspect Workspace as Platform Owner →';
	String get orgReactivated => 'Organization reactivated successfully';
	String get orgSuspended => 'Organization suspended successfully';
	String get orgDeleted => 'Organization deleted successfully';
	String get failedToProvision => 'Failed to provision organization';
}

// Path: teams
class _TranslationsTeamsEn {
	_TranslationsTeamsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Teams';
	String get noTeams => 'No Teams Found';
	String get noTeamsSubtitle => 'Organize organization members into functional squads and engineering teams.';
	String get createTeam => 'Create Team';
	String get createFirstTeam => 'Create First Team';
	String get teamName => 'Team Name';
	String get teamNameHint => 'e.g. Core Engineering';
	String get teamDescription => 'Description (Optional)';
	String get teamDescriptionHint => 'Squad purpose and scope';
	String get failedToLoad => 'Failed to load teams';
	String get failedToCreate => 'Failed to create team';
	String get failedToDelete => 'Failed to delete team';
}

// Path: calendar
class _TranslationsCalendarEn {
	_TranslationsCalendarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Calendar';
	String get noMeetings => 'No Meetings Scheduled';
	String get noMeetingsSubtitle => 'Your team calendar is clear. Schedule a sprint sync or architectural review.';
	String get scheduleMeeting => 'Schedule Meeting';
	String get scheduleNewMeeting => 'Schedule New Meeting';
	String get meetingTitle => 'Meeting Title';
	String get meetingTitleHint => 'e.g. Sprint Planning Sync';
	String get meetingUrl => 'Meeting URL / Room Link';
	String get meetingUrlHint => 'https://meet.google.com/...';
	String get failedToLoad => 'Failed to load meetings';
	String get failedToSchedule => 'Failed to schedule meeting';
}

// Path: projects
class _TranslationsProjectsEn {
	_TranslationsProjectsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Projects';
	String get all => 'All Projects';
	String get create => 'New Project';
	String get name => 'Project Name';
	String get description => 'Description';
	String get status => 'Status';
	String get tasksCount => 'tasks';
	String get noProjects => 'No projects found';
	String get noProjectsSubtitle => 'Create a new project to start organizing tasks and teammates.';
	String get projectCreated => 'Project created successfully';
	String get nameRequired => 'Project name is required';
	String get failedToLoad => 'Failed to load projects';
	String get failedToCreate => 'Failed to create project';
	String get nameHint => 'e.g. Website Redesign';
	String get descriptionHint => 'Brief details about the project goals...';
}

// Path: tasks
class _TranslationsTasksEn {
	_TranslationsTasksEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Tasks';
	String get taskDetails => 'Task Details';
	String get myTasks => 'My Tasks';
	String get allTasks => 'All Tasks';
	String get create => 'Create Task';
	String get edit => 'Edit Task';
	String get name => 'Task Title';
	String get description => 'Description';
	String get priority => 'Priority';
	String get dueDate => 'Due Date';
	String get assignee => 'Assignee';
	String get status => 'Status';
	String get todo => 'To Do';
	String get inProgress => 'In Progress';
	String get inReview => 'In Review';
	String get done => 'Done';
	String get priorityLow => 'Low';
	String get priorityMedium => 'Medium';
	String get priorityHigh => 'High';
	String get priorityUrgent => 'Urgent';
	String get noTasks => 'No tasks found';
	String get noTasksSubtitle => 'No tasks match the selected criteria.';
	String get taskCreated => 'Task created successfully';
	String get changeStatus => 'Change Status';
	String get titleRequired => 'Task title is required';
	String get failedToLoad => 'Failed to load tasks';
	String get failedToCreate => 'Failed to create task';
	String get titleHint => 'e.g. Design app bar component';
	String get descriptionHint => 'Add more details about the task...';
}

// Path: channels
class _TranslationsChannelsEn {
	_TranslationsChannelsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Messages';
	String get channels => 'Channels';
	String get directMessages => 'Direct Messages';
	String get typeMessage => 'Type a message...';
	String get noMessages => 'No messages yet';
	String get noChannels => 'No Channels Found';
	String get noChannelsSubtitle => 'There are no active channels in this organization yet.';
	String get startConversation => 'Send a message to start the conversation.';
	String get online => 'Online';
	String get offline => 'Offline';
	String get failedToLoad => 'Failed to load channels';
}

// Path: notifications
class _TranslationsNotificationsEn {
	_TranslationsNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Notifications';
	String get markAllAsRead => 'Mark all as read';
	String get noNotifications => 'No notifications right now';
	String get noNewNotifications => 'No new notifications';
	String get failedToLoad => 'Failed to load notifications';
}

// Path: settings
class _TranslationsSettingsEn {
	_TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get profile => 'Profile';
	String get language => 'Language';
	String get english => 'English';
	String get arabic => 'العربية';
	String get theme => 'Theme';
	String get about => 'About SyncUp';
	String get version => 'Version';
	String get darkModeDesc => 'Active high-contrast dark theme';
	String get lightModeDesc => 'Active daylight theme';
}

// Path: onboarding
class _TranslationsOnboardingEn {
	_TranslationsOnboardingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get sprintsTitle => 'Unified Engineering Sprints';
	String get sprintsSubtitle => 'Track tasks, sprints, code commits and deliverables in one unified dashboard.';
	String get channelsTitle => 'Encrypted Team Channels';
	String get channelsSubtitle => 'Contextual discussions organized by team, project, or feature topic.';
	String get multiTenancyTitle => 'Enterprise Multi-Tenancy';
	String get multiTenancySubtitle => 'Complete isolation of enterprise client data with fine-grained RBAC permissions.';
}

// Path: splash
class _TranslationsSplashEn {
	_TranslationsSplashEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tagline => 'Private B2B SaaS Collaboration Platform';
	String get architecture => 'Isolated Multi-Tenant Architecture';
}

// Path: <root>
class _TranslationsAr implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsAr.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _TranslationsAr _root = this; // ignore: unused_field

	// Translations
	@override String get app_name => 'SyncUp';
	@override late final _TranslationsCommonAr common = _TranslationsCommonAr._(_root);
	@override late final _TranslationsAuthAr auth = _TranslationsAuthAr._(_root);
	@override late final _TranslationsWorkspaceAr workspace = _TranslationsWorkspaceAr._(_root);
	@override late final _TranslationsSuperAdminAr superAdmin = _TranslationsSuperAdminAr._(_root);
	@override late final _TranslationsTeamsAr teams = _TranslationsTeamsAr._(_root);
	@override late final _TranslationsCalendarAr calendar = _TranslationsCalendarAr._(_root);
	@override late final _TranslationsProjectsAr projects = _TranslationsProjectsAr._(_root);
	@override late final _TranslationsTasksAr tasks = _TranslationsTasksAr._(_root);
	@override late final _TranslationsChannelsAr channels = _TranslationsChannelsAr._(_root);
	@override late final _TranslationsNotificationsAr notifications = _TranslationsNotificationsAr._(_root);
	@override late final _TranslationsSettingsAr settings = _TranslationsSettingsAr._(_root);
	@override late final _TranslationsOnboardingAr onboarding = _TranslationsOnboardingAr._(_root);
	@override late final _TranslationsSplashAr splash = _TranslationsSplashAr._(_root);
}

// Path: common
class _TranslationsCommonAr implements _TranslationsCommonEn {
	_TranslationsCommonAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'إلغاء';
	@override String get submit => 'إرسال';
	@override String get save => 'حفظ';
	@override String get delete => 'حذف';
	@override String get edit => 'تعديل';
	@override String get back => 'رجوع';
	@override String get retry => 'إعادة المحاولة';
	@override String get error => 'خطأ';
	@override String get loading => 'جاري التحميل...';
	@override String get success => 'تم بنجاح';
	@override String get search => 'بحث';
	@override String get filter => 'تصفية';
	@override String get noData => 'لا توجد بيانات';
	@override String get seeAll => 'عرض الكل';
	@override String get close => 'إغلاق';
	@override String get confirm => 'تأكيد';
	@override String get skip => 'تخطي';
	@override String get all => 'الكل';
	@override String get manage => 'إدارة';
	@override String get open => 'فتح';
	@override String get status => 'الحالة';
	@override String get name => 'الاسم';
	@override String get description => 'الوصف';
	@override String get email => 'البريد الإلكتروني';
	@override String get actions => 'إجراءات';
	@override String get preferences => 'التفضيلات';
	@override String get account => 'الحساب';
	@override String get getStarted => 'ابدأ الآن';
	@override String get next => 'التالي';
	@override String get activeWorkspace => 'مساحة عمل نشطة';
	@override String get general => 'عام';
	@override String get unassigned => 'غير مسند';
	@override String get darkMode => 'الوضع الداكن';
	@override String get lightMode => 'الوضع الفاتح';
	@override String get photoUrl => 'رابط الصورة الشخصية';
	@override String get avatarUrl => 'رابط صورة الحساب';
}

// Path: auth
class _TranslationsAuthAr implements _TranslationsAuthEn {
	_TranslationsAuthAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login => 'تسجيل الدخول';
	@override String get register => 'إنشاء حساب';
	@override String get email => 'البريد الإلكتروني';
	@override String get password => 'كلمة المرور';
	@override String get confirmPassword => 'تأكيد كلمة المرور';
	@override String get fullName => 'الاسم الكامل';
	@override String get organizationCode => 'رمز المؤسسة';
	@override String get forgotPassword => 'نسيت كلمة المرور؟';
	@override String get logout => 'تسجيل الخروج';
	@override String get welcomeBack => 'مرحباً بعودتك';
	@override String get signInSubtitle => 'سجل الدخول للوصول إلى مساحات العمل والمهام';
	@override String get noAccount => 'ليس لديك حساب؟';
	@override String get haveAccount => 'لديك حساب بالفعل؟';
	@override String get emailRequired => 'البريد الإلكتروني مطلوب';
	@override String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';
	@override String get passwordRequired => 'كلمة المرور مطلوبة';
	@override String get passwordTooShort => 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
	@override String get loginSuccess => 'تم تسجيل الدخول بنجاح';
	@override String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';
	@override String get invitationOnlyNotice => 'SyncUp هي منصة مغلقة تعتمد على الدعوات فقط.';
	@override String get serverConnectionError => 'تعذر الاتصال بخادم الباك اند على:';
	@override String get ensureBackendRunning => 'يرجى التأكد من تشغيل خادم الباك اند.';
	@override String get unexpectedError => 'حدث خطأ غير متوقع';
}

// Path: workspace
class _TranslationsWorkspaceAr implements _TranslationsWorkspaceEn {
	_TranslationsWorkspaceAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مساحات العمل';
	@override String get switchWorkspace => 'تبديل مساحة العمل';
	@override String get current => 'مساحة العمل الحالية';
	@override String get members => 'الأعضاء';
	@override String get teams => 'الفرق';
	@override String get role => 'الدور';
	@override String get owner => 'المالك';
	@override String get admin => 'المسؤول';
	@override String get member => 'عضو';
	@override String get noWorkspaces => 'لا توجد مساحات عمل';
	@override String get noWorkspacesSubtitle => 'أنت لا تنتمي إلى أي مؤسسة بعد. يرجى مراجعة دعوتك.';
	@override String get failedToLoad => 'تعذر تحميل مساحات العمل';
}

// Path: superAdmin
class _TranslationsSuperAdminAr implements _TranslationsSuperAdminEn {
	_TranslationsSuperAdminAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get controlPlane => 'لوحة التحكم';
	@override String get dashboardTitle => 'لوحة تحكم مدير المنصة';
	@override String get dashboardSubtitle => 'إدارة وحوكمة المنصة عالمياً، وتجهيز مؤسسات العملاء، والتحكم بالوصول.';
	@override String get paidRevenue => 'الإيرادات المدفوعة';
	@override String get erpIncome => 'دخل الـ ERP';
	@override String get clientOrgs => 'مؤسسات العملاء';
	@override String get enterprise => 'المؤسسات';
	@override String get platformUsers => 'مستخدمو المنصة';
	@override String get verified => 'تم التحقق';
	@override String get engineStatus => 'حالة النظام';
	@override String get operational => 'يعمل بكفاءة';
	@override String get activeClientTenants => 'المؤسسات النشطة';
	@override String get provisionTenant => 'إنشاء مؤسسة جديدة';
	@override String get provisionModalTitle => 'إنشاء مؤسسة جديدة';
	@override String get companyName => 'اسم الشركة أو المؤسسة';
	@override String get companyNameHint => 'مثال: شركة النصر';
	@override String get primaryAdminName => 'اسم المسؤول الرئيسي';
	@override String get primaryAdminNameHint => 'مثال: أحمد عبد الفتاح';
	@override String get adminWorkEmail => 'بريد عمل المسؤول';
	@override String get adminWorkEmailHint => 'admin@company.com';
	@override String get tenantResources => 'موارد وإحصائيات المؤسسة';
	@override String get totalMembers => 'إجمالي الأعضاء';
	@override String get activeProjects => 'المشاريع النشطة';
	@override String get workTeams => 'فرق العمل';
	@override String get chatChannels => 'قنوات المحادثة';
	@override String get primaryAdminLead => 'المسؤول الرئيسي للمؤسسة';
	@override String get tenantId => 'معرف المؤسسة';
	@override String get slug => 'المعرف';
	@override String get suspendOrg => 'تعليق المؤسسة';
	@override String get reactivateOrg => 'إعادة تفعيل المؤسسة';
	@override String get deleteOrg => 'حذف المؤسسة';
	@override String get deleteOrgConfirmTitle => 'هل تريد حذف المؤسسة؟';
	@override String get deleteOrgConfirmMessage => 'هل أنت متأكد من رغبتك في حذف هذه المؤسسة نهائياً؟ سيتم حذف جميع البيانات والأعضاء والمشاريع والقنوات المرتبطة بها.';
	@override String get deletePermanently => 'حذف نهائي';
	@override String get inspectWorkspace => 'فحص مساحة العمل كمالك للمنصة ←';
	@override String get orgReactivated => 'تمت إعادة تفعيل المؤسسة بنجاح';
	@override String get orgSuspended => 'تم تعليق المؤسسة بنجاح';
	@override String get orgDeleted => 'تم حذف المؤسسة بنجاح';
	@override String get failedToProvision => 'تعذر إنشاء المؤسسة';
}

// Path: teams
class _TranslationsTeamsAr implements _TranslationsTeamsEn {
	_TranslationsTeamsAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'فرق العمل';
	@override String get noTeams => 'لا توجد فرق عمل';
	@override String get noTeamsSubtitle => 'قم بتنظيم أعضاء المؤسسة في فرق عمل ومجموعات متخصصة.';
	@override String get createTeam => 'إنشاء فريق';
	@override String get createFirstTeam => 'إنشاء أول فريق';
	@override String get teamName => 'اسم الفريق';
	@override String get teamNameHint => 'مثال: الفريق الهندسي الرئيسي';
	@override String get teamDescription => 'الوصف (اختياري)';
	@override String get teamDescriptionHint => 'نطاق وهدف الفريق';
	@override String get failedToLoad => 'تعذر تحميل فرق العمل';
	@override String get failedToCreate => 'تعذر إنشاء الفريق';
	@override String get failedToDelete => 'تعذر حذف الفريق';
}

// Path: calendar
class _TranslationsCalendarAr implements _TranslationsCalendarEn {
	_TranslationsCalendarAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'التقويم';
	@override String get noMeetings => 'لا توجد اجتماعات مجدولة';
	@override String get noMeetingsSubtitle => 'جدول مواعيد الفريق فارغ. قم بجدولة اجتماع أو مراجعة برمجية.';
	@override String get scheduleMeeting => 'جدولة اجتماع';
	@override String get scheduleNewMeeting => 'جدولة اجتماع جديد';
	@override String get meetingTitle => 'عنوان الاجتماع';
	@override String get meetingTitleHint => 'مثال: تخطيط السبرنت';
	@override String get meetingUrl => 'رابط الاجتماع / الغرفة';
	@override String get meetingUrlHint => 'https://meet.google.com/...';
	@override String get failedToLoad => 'تعذر تحميل الاجتماعات';
	@override String get failedToSchedule => 'تعذر جدولة الاجتماع';
}

// Path: projects
class _TranslationsProjectsAr implements _TranslationsProjectsEn {
	_TranslationsProjectsAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'المشاريع';
	@override String get all => 'جميع المشاريع';
	@override String get create => 'مشروع جديد';
	@override String get name => 'اسم المشروع';
	@override String get description => 'الوصف';
	@override String get status => 'الحالة';
	@override String get tasksCount => 'مهام';
	@override String get noProjects => 'لا توجد مشاريع';
	@override String get noProjectsSubtitle => 'أنشئ مشروعاً جديداً للبدء في تنظيم المهام وفريق العمل.';
	@override String get projectCreated => 'تم إنشاء المشروع بنجاح';
	@override String get nameRequired => 'اسم المشروع مطلوب';
	@override String get failedToLoad => 'تعذر تحميل المشاريع';
	@override String get failedToCreate => 'تعذر إنشاء المشروع';
	@override String get nameHint => 'مثال: إعادة تصميم الموقع';
	@override String get descriptionHint => 'تفاصيل موجزة عن أهداف المشروع...';
}

// Path: tasks
class _TranslationsTasksAr implements _TranslationsTasksEn {
	_TranslationsTasksAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'المهام';
	@override String get taskDetails => 'تفاصيل المهمة';
	@override String get myTasks => 'مهامي';
	@override String get allTasks => 'جميع المهام';
	@override String get create => 'إنشاء مهمة';
	@override String get edit => 'تعديل المهمة';
	@override String get name => 'عنوان المهمة';
	@override String get description => 'الوصف';
	@override String get priority => 'الأولوية';
	@override String get dueDate => 'تاريخ الاستحقاق';
	@override String get assignee => 'المسؤول';
	@override String get status => 'الحالة';
	@override String get todo => 'قيد الانتظار';
	@override String get inProgress => 'قيد التنفيذ';
	@override String get inReview => 'قيد المراجعة';
	@override String get done => 'مكتملة';
	@override String get priorityLow => 'منخفضة';
	@override String get priorityMedium => 'متوسطة';
	@override String get priorityHigh => 'عالية';
	@override String get priorityUrgent => 'عاجلة';
	@override String get noTasks => 'لا توجد مهام';
	@override String get noTasksSubtitle => 'لا توجد مهام تطابق المعايير المحددة.';
	@override String get taskCreated => 'تم إنشاء المهمة بنجاح';
	@override String get changeStatus => 'تغيير الحالة';
	@override String get titleRequired => 'عنوان المهمة مطلوب';
	@override String get failedToLoad => 'تعذر تحميل المهام';
	@override String get failedToCreate => 'تعذر إنشاء المهمة';
	@override String get titleHint => 'مثال: تصميم شريط التطبيق العلوي';
	@override String get descriptionHint => 'أضف مزيداً من التفاصيل حول المهمة...';
}

// Path: channels
class _TranslationsChannelsAr implements _TranslationsChannelsEn {
	_TranslationsChannelsAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الرسائل';
	@override String get channels => 'القنوات';
	@override String get directMessages => 'الرسائل المباشرة';
	@override String get typeMessage => 'اكتب رسالة...';
	@override String get noMessages => 'لا توجد رسائل بعد';
	@override String get noChannels => 'لا توجد قنوات';
	@override String get noChannelsSubtitle => 'لا توجد قنوات نشطة في هذه المؤسسة بعد.';
	@override String get startConversation => 'أرسل رسالة لبدء المحادثة.';
	@override String get online => 'متصل';
	@override String get offline => 'غير متصل';
	@override String get failedToLoad => 'تعذر تحميل القنوات';
}

// Path: notifications
class _TranslationsNotificationsAr implements _TranslationsNotificationsEn {
	_TranslationsNotificationsAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإشعارات';
	@override String get markAllAsRead => 'تحديد الكل كمقروء';
	@override String get noNotifications => 'لا توجد إشعارات حالياً';
	@override String get noNewNotifications => 'لا توجد إشعارات جديدة';
	@override String get failedToLoad => 'تعذر تحميل الإشعارات';
}

// Path: settings
class _TranslationsSettingsAr implements _TranslationsSettingsEn {
	_TranslationsSettingsAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override String get profile => 'الملف الشخصي';
	@override String get language => 'اللغة';
	@override String get english => 'English';
	@override String get arabic => 'العربية';
	@override String get theme => 'المظهر';
	@override String get about => 'حول SyncUp';
	@override String get version => 'الإصدار';
	@override String get darkModeDesc => 'المظهر الداكن عالي التباين';
	@override String get lightModeDesc => 'المظهر الفاتح النهاري';
}

// Path: onboarding
class _TranslationsOnboardingAr implements _TranslationsOnboardingEn {
	_TranslationsOnboardingAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get sprintsTitle => 'سبرنتات برمجية موحدة';
	@override String get sprintsSubtitle => 'تابع المهام والتسليمات والتحديثات البرمجية في لوحة تحكم واحدة.';
	@override String get channelsTitle => 'قنوات تواصل مشفرة للفرق';
	@override String get channelsSubtitle => 'محادثات منظمة حسب الفريق أو المشروع أو الموضوع.';
	@override String get multiTenancyTitle => 'بنية مؤسسية متعددة المستأجرين';
	@override String get multiTenancySubtitle => 'عزل كامل لبيانات كل شركة مع صلاحيات دقيقة ومحكمة.';
}

// Path: splash
class _TranslationsSplashAr implements _TranslationsSplashEn {
	_TranslationsSplashAr._(this._root);

	@override final _TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'منصة التعاون السحابية الخاصة للشركات';
	@override String get architecture => 'بنية تحتية معزولة متعددة المستأجرين';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app_name': return 'SyncUp';
			case 'common.cancel': return 'Cancel';
			case 'common.submit': return 'Submit';
			case 'common.save': return 'Save';
			case 'common.delete': return 'Delete';
			case 'common.edit': return 'Edit';
			case 'common.back': return 'Back';
			case 'common.retry': return 'Retry';
			case 'common.error': return 'Error';
			case 'common.loading': return 'Loading...';
			case 'common.success': return 'Success';
			case 'common.search': return 'Search';
			case 'common.filter': return 'Filter';
			case 'common.noData': return 'No data available';
			case 'common.seeAll': return 'See All';
			case 'common.close': return 'Close';
			case 'common.confirm': return 'Confirm';
			case 'common.skip': return 'Skip';
			case 'common.all': return 'All';
			case 'common.manage': return 'Manage';
			case 'common.open': return 'Open';
			case 'common.status': return 'Status';
			case 'common.name': return 'Name';
			case 'common.description': return 'Description';
			case 'common.email': return 'Email';
			case 'common.actions': return 'Actions';
			case 'common.preferences': return 'Preferences';
			case 'common.account': return 'Account';
			case 'common.getStarted': return 'Get Started';
			case 'common.next': return 'Next';
			case 'common.activeWorkspace': return 'Active Workspace';
			case 'common.general': return 'General';
			case 'common.unassigned': return 'Unassigned';
			case 'common.darkMode': return 'Dark Mode';
			case 'common.lightMode': return 'Light Mode';
			case 'common.photoUrl': return 'Profile Photo URL';
			case 'common.avatarUrl': return 'Avatar Image URL';
			case 'auth.login': return 'Sign In';
			case 'auth.register': return 'Create Account';
			case 'auth.email': return 'Email Address';
			case 'auth.password': return 'Password';
			case 'auth.confirmPassword': return 'Confirm Password';
			case 'auth.fullName': return 'Full Name';
			case 'auth.organizationCode': return 'Organization Code';
			case 'auth.forgotPassword': return 'Forgot Password?';
			case 'auth.logout': return 'Sign Out';
			case 'auth.welcomeBack': return 'Welcome Back';
			case 'auth.signInSubtitle': return 'Sign in to access your workspaces and team tasks';
			case 'auth.noAccount': return 'Don\'t have an account?';
			case 'auth.haveAccount': return 'Already have an account?';
			case 'auth.emailRequired': return 'Email is required';
			case 'auth.invalidEmail': return 'Please enter a valid email';
			case 'auth.passwordRequired': return 'Password is required';
			case 'auth.passwordTooShort': return 'Password must be at least 6 characters';
			case 'auth.loginSuccess': return 'Signed in successfully';
			case 'auth.logoutConfirm': return 'Are you sure you want to sign out?';
			case 'auth.invitationOnlyNotice': return 'SyncUp is an invitation-only workspace.';
			case 'auth.serverConnectionError': return 'Unable to connect to backend server at:';
			case 'auth.ensureBackendRunning': return 'Please ensure the backend is running.';
			case 'auth.unexpectedError': return 'An unexpected error occurred';
			case 'workspace.title': return 'Workspaces';
			case 'workspace.switchWorkspace': return 'Switch Workspace';
			case 'workspace.current': return 'Current Workspace';
			case 'workspace.members': return 'Members';
			case 'workspace.teams': return 'Teams';
			case 'workspace.role': return 'Role';
			case 'workspace.owner': return 'Owner';
			case 'workspace.admin': return 'Admin';
			case 'workspace.member': return 'Member';
			case 'workspace.noWorkspaces': return 'No Workspaces Found';
			case 'workspace.noWorkspacesSubtitle': return 'You do not belong to any organization yet. Please check your invitation.';
			case 'workspace.failedToLoad': return 'Failed to load workspaces';
			case 'superAdmin.controlPlane': return 'Control Plane';
			case 'superAdmin.dashboardTitle': return 'Super Admin Dashboard';
			case 'superAdmin.dashboardSubtitle': return 'Global platform governance, client organization provisioning, and tenant access.';
			case 'superAdmin.paidRevenue': return 'Paid Revenue';
			case 'superAdmin.erpIncome': return 'ERP Income';
			case 'superAdmin.clientOrgs': return 'Client Orgs';
			case 'superAdmin.enterprise': return 'Enterprise';
			case 'superAdmin.platformUsers': return 'Platform Users';
			case 'superAdmin.verified': return 'Verified';
			case 'superAdmin.engineStatus': return 'Engine Status';
			case 'superAdmin.operational': return 'Operational';
			case 'superAdmin.activeClientTenants': return 'Active Client Tenants';
			case 'superAdmin.provisionTenant': return 'Provision Tenant';
			case 'superAdmin.provisionModalTitle': return 'Provision New Enterprise Tenant';
			case 'superAdmin.companyName': return 'Company / Organization Name';
			case 'superAdmin.companyNameHint': return 'e.g. Acme Corporation';
			case 'superAdmin.primaryAdminName': return 'Primary Admin Name';
			case 'superAdmin.primaryAdminNameHint': return 'e.g. Jane Doe';
			case 'superAdmin.adminWorkEmail': return 'Admin Work Email';
			case 'superAdmin.adminWorkEmailHint': return 'admin@acme.com';
			case 'superAdmin.tenantResources': return 'Tenant Resources & Member Statistics';
			case 'superAdmin.totalMembers': return 'Total Members';
			case 'superAdmin.activeProjects': return 'Active Projects';
			case 'superAdmin.workTeams': return 'Work Teams';
			case 'superAdmin.chatChannels': return 'Chat Channels';
			case 'superAdmin.primaryAdminLead': return 'Primary Administrator Lead';
			case 'superAdmin.tenantId': return 'Tenant ID';
			case 'superAdmin.slug': return 'slug';
			case 'superAdmin.suspendOrg': return 'Suspend Organization';
			case 'superAdmin.reactivateOrg': return 'Reactivate Organization';
			case 'superAdmin.deleteOrg': return 'Delete Organization';
			case 'superAdmin.deleteOrgConfirmTitle': return 'Delete Organization?';
			case 'superAdmin.deleteOrgConfirmMessage': return 'Are you sure you want to permanently delete this client enterprise organization? All associated data, members, projects, and channels will be removed.';
			case 'superAdmin.deletePermanently': return 'Delete Permanently';
			case 'superAdmin.inspectWorkspace': return 'Inspect Workspace as Platform Owner →';
			case 'superAdmin.orgReactivated': return 'Organization reactivated successfully';
			case 'superAdmin.orgSuspended': return 'Organization suspended successfully';
			case 'superAdmin.orgDeleted': return 'Organization deleted successfully';
			case 'superAdmin.failedToProvision': return 'Failed to provision organization';
			case 'teams.title': return 'Teams';
			case 'teams.noTeams': return 'No Teams Found';
			case 'teams.noTeamsSubtitle': return 'Organize organization members into functional squads and engineering teams.';
			case 'teams.createTeam': return 'Create Team';
			case 'teams.createFirstTeam': return 'Create First Team';
			case 'teams.teamName': return 'Team Name';
			case 'teams.teamNameHint': return 'e.g. Core Engineering';
			case 'teams.teamDescription': return 'Description (Optional)';
			case 'teams.teamDescriptionHint': return 'Squad purpose and scope';
			case 'teams.failedToLoad': return 'Failed to load teams';
			case 'teams.failedToCreate': return 'Failed to create team';
			case 'teams.failedToDelete': return 'Failed to delete team';
			case 'calendar.title': return 'Calendar';
			case 'calendar.noMeetings': return 'No Meetings Scheduled';
			case 'calendar.noMeetingsSubtitle': return 'Your team calendar is clear. Schedule a sprint sync or architectural review.';
			case 'calendar.scheduleMeeting': return 'Schedule Meeting';
			case 'calendar.scheduleNewMeeting': return 'Schedule New Meeting';
			case 'calendar.meetingTitle': return 'Meeting Title';
			case 'calendar.meetingTitleHint': return 'e.g. Sprint Planning Sync';
			case 'calendar.meetingUrl': return 'Meeting URL / Room Link';
			case 'calendar.meetingUrlHint': return 'https://meet.google.com/...';
			case 'calendar.failedToLoad': return 'Failed to load meetings';
			case 'calendar.failedToSchedule': return 'Failed to schedule meeting';
			case 'projects.title': return 'Projects';
			case 'projects.all': return 'All Projects';
			case 'projects.create': return 'New Project';
			case 'projects.name': return 'Project Name';
			case 'projects.description': return 'Description';
			case 'projects.status': return 'Status';
			case 'projects.tasksCount': return 'tasks';
			case 'projects.noProjects': return 'No projects found';
			case 'projects.noProjectsSubtitle': return 'Create a new project to start organizing tasks and teammates.';
			case 'projects.projectCreated': return 'Project created successfully';
			case 'projects.nameRequired': return 'Project name is required';
			case 'projects.failedToLoad': return 'Failed to load projects';
			case 'projects.failedToCreate': return 'Failed to create project';
			case 'projects.nameHint': return 'e.g. Website Redesign';
			case 'projects.descriptionHint': return 'Brief details about the project goals...';
			case 'tasks.title': return 'Tasks';
			case 'tasks.taskDetails': return 'Task Details';
			case 'tasks.myTasks': return 'My Tasks';
			case 'tasks.allTasks': return 'All Tasks';
			case 'tasks.create': return 'Create Task';
			case 'tasks.edit': return 'Edit Task';
			case 'tasks.name': return 'Task Title';
			case 'tasks.description': return 'Description';
			case 'tasks.priority': return 'Priority';
			case 'tasks.dueDate': return 'Due Date';
			case 'tasks.assignee': return 'Assignee';
			case 'tasks.status': return 'Status';
			case 'tasks.todo': return 'To Do';
			case 'tasks.inProgress': return 'In Progress';
			case 'tasks.inReview': return 'In Review';
			case 'tasks.done': return 'Done';
			case 'tasks.priorityLow': return 'Low';
			case 'tasks.priorityMedium': return 'Medium';
			case 'tasks.priorityHigh': return 'High';
			case 'tasks.priorityUrgent': return 'Urgent';
			case 'tasks.noTasks': return 'No tasks found';
			case 'tasks.noTasksSubtitle': return 'No tasks match the selected criteria.';
			case 'tasks.taskCreated': return 'Task created successfully';
			case 'tasks.changeStatus': return 'Change Status';
			case 'tasks.titleRequired': return 'Task title is required';
			case 'tasks.failedToLoad': return 'Failed to load tasks';
			case 'tasks.failedToCreate': return 'Failed to create task';
			case 'tasks.titleHint': return 'e.g. Design app bar component';
			case 'tasks.descriptionHint': return 'Add more details about the task...';
			case 'channels.title': return 'Messages';
			case 'channels.channels': return 'Channels';
			case 'channels.directMessages': return 'Direct Messages';
			case 'channels.typeMessage': return 'Type a message...';
			case 'channels.noMessages': return 'No messages yet';
			case 'channels.noChannels': return 'No Channels Found';
			case 'channels.noChannelsSubtitle': return 'There are no active channels in this organization yet.';
			case 'channels.startConversation': return 'Send a message to start the conversation.';
			case 'channels.online': return 'Online';
			case 'channels.offline': return 'Offline';
			case 'channels.failedToLoad': return 'Failed to load channels';
			case 'notifications.title': return 'Notifications';
			case 'notifications.markAllAsRead': return 'Mark all as read';
			case 'notifications.noNotifications': return 'No notifications right now';
			case 'notifications.noNewNotifications': return 'No new notifications';
			case 'notifications.failedToLoad': return 'Failed to load notifications';
			case 'settings.title': return 'Settings';
			case 'settings.profile': return 'Profile';
			case 'settings.language': return 'Language';
			case 'settings.english': return 'English';
			case 'settings.arabic': return 'العربية';
			case 'settings.theme': return 'Theme';
			case 'settings.about': return 'About SyncUp';
			case 'settings.version': return 'Version';
			case 'settings.darkModeDesc': return 'Active high-contrast dark theme';
			case 'settings.lightModeDesc': return 'Active daylight theme';
			case 'onboarding.sprintsTitle': return 'Unified Engineering Sprints';
			case 'onboarding.sprintsSubtitle': return 'Track tasks, sprints, code commits and deliverables in one unified dashboard.';
			case 'onboarding.channelsTitle': return 'Encrypted Team Channels';
			case 'onboarding.channelsSubtitle': return 'Contextual discussions organized by team, project, or feature topic.';
			case 'onboarding.multiTenancyTitle': return 'Enterprise Multi-Tenancy';
			case 'onboarding.multiTenancySubtitle': return 'Complete isolation of enterprise client data with fine-grained RBAC permissions.';
			case 'splash.tagline': return 'Private B2B SaaS Collaboration Platform';
			case 'splash.architecture': return 'Isolated Multi-Tenant Architecture';
			default: return null;
		}
	}
}

extension on _TranslationsAr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app_name': return 'SyncUp';
			case 'common.cancel': return 'إلغاء';
			case 'common.submit': return 'إرسال';
			case 'common.save': return 'حفظ';
			case 'common.delete': return 'حذف';
			case 'common.edit': return 'تعديل';
			case 'common.back': return 'رجوع';
			case 'common.retry': return 'إعادة المحاولة';
			case 'common.error': return 'خطأ';
			case 'common.loading': return 'جاري التحميل...';
			case 'common.success': return 'تم بنجاح';
			case 'common.search': return 'بحث';
			case 'common.filter': return 'تصفية';
			case 'common.noData': return 'لا توجد بيانات';
			case 'common.seeAll': return 'عرض الكل';
			case 'common.close': return 'إغلاق';
			case 'common.confirm': return 'تأكيد';
			case 'common.skip': return 'تخطي';
			case 'common.all': return 'الكل';
			case 'common.manage': return 'إدارة';
			case 'common.open': return 'فتح';
			case 'common.status': return 'الحالة';
			case 'common.name': return 'الاسم';
			case 'common.description': return 'الوصف';
			case 'common.email': return 'البريد الإلكتروني';
			case 'common.actions': return 'إجراءات';
			case 'common.preferences': return 'التفضيلات';
			case 'common.account': return 'الحساب';
			case 'common.getStarted': return 'ابدأ الآن';
			case 'common.next': return 'التالي';
			case 'common.activeWorkspace': return 'مساحة عمل نشطة';
			case 'common.general': return 'عام';
			case 'common.unassigned': return 'غير مسند';
			case 'common.darkMode': return 'الوضع الداكن';
			case 'common.lightMode': return 'الوضع الفاتح';
			case 'common.photoUrl': return 'رابط الصورة الشخصية';
			case 'common.avatarUrl': return 'رابط صورة الحساب';
			case 'auth.login': return 'تسجيل الدخول';
			case 'auth.register': return 'إنشاء حساب';
			case 'auth.email': return 'البريد الإلكتروني';
			case 'auth.password': return 'كلمة المرور';
			case 'auth.confirmPassword': return 'تأكيد كلمة المرور';
			case 'auth.fullName': return 'الاسم الكامل';
			case 'auth.organizationCode': return 'رمز المؤسسة';
			case 'auth.forgotPassword': return 'نسيت كلمة المرور؟';
			case 'auth.logout': return 'تسجيل الخروج';
			case 'auth.welcomeBack': return 'مرحباً بعودتك';
			case 'auth.signInSubtitle': return 'سجل الدخول للوصول إلى مساحات العمل والمهام';
			case 'auth.noAccount': return 'ليس لديك حساب؟';
			case 'auth.haveAccount': return 'لديك حساب بالفعل؟';
			case 'auth.emailRequired': return 'البريد الإلكتروني مطلوب';
			case 'auth.invalidEmail': return 'يرجى إدخال بريد إلكتروني صالح';
			case 'auth.passwordRequired': return 'كلمة المرور مطلوبة';
			case 'auth.passwordTooShort': return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
			case 'auth.loginSuccess': return 'تم تسجيل الدخول بنجاح';
			case 'auth.logoutConfirm': return 'هل أنت متأكد من تسجيل الخروج؟';
			case 'auth.invitationOnlyNotice': return 'SyncUp هي منصة مغلقة تعتمد على الدعوات فقط.';
			case 'auth.serverConnectionError': return 'تعذر الاتصال بخادم الباك اند على:';
			case 'auth.ensureBackendRunning': return 'يرجى التأكد من تشغيل خادم الباك اند.';
			case 'auth.unexpectedError': return 'حدث خطأ غير متوقع';
			case 'workspace.title': return 'مساحات العمل';
			case 'workspace.switchWorkspace': return 'تبديل مساحة العمل';
			case 'workspace.current': return 'مساحة العمل الحالية';
			case 'workspace.members': return 'الأعضاء';
			case 'workspace.teams': return 'الفرق';
			case 'workspace.role': return 'الدور';
			case 'workspace.owner': return 'المالك';
			case 'workspace.admin': return 'المسؤول';
			case 'workspace.member': return 'عضو';
			case 'workspace.noWorkspaces': return 'لا توجد مساحات عمل';
			case 'workspace.noWorkspacesSubtitle': return 'أنت لا تنتمي إلى أي مؤسسة بعد. يرجى مراجعة دعوتك.';
			case 'workspace.failedToLoad': return 'تعذر تحميل مساحات العمل';
			case 'superAdmin.controlPlane': return 'لوحة التحكم';
			case 'superAdmin.dashboardTitle': return 'لوحة تحكم مدير المنصة';
			case 'superAdmin.dashboardSubtitle': return 'إدارة وحوكمة المنصة عالمياً، وتجهيز مؤسسات العملاء، والتحكم بالوصول.';
			case 'superAdmin.paidRevenue': return 'الإيرادات المدفوعة';
			case 'superAdmin.erpIncome': return 'دخل الـ ERP';
			case 'superAdmin.clientOrgs': return 'مؤسسات العملاء';
			case 'superAdmin.enterprise': return 'المؤسسات';
			case 'superAdmin.platformUsers': return 'مستخدمو المنصة';
			case 'superAdmin.verified': return 'تم التحقق';
			case 'superAdmin.engineStatus': return 'حالة النظام';
			case 'superAdmin.operational': return 'يعمل بكفاءة';
			case 'superAdmin.activeClientTenants': return 'المؤسسات النشطة';
			case 'superAdmin.provisionTenant': return 'إنشاء مؤسسة جديدة';
			case 'superAdmin.provisionModalTitle': return 'إنشاء مؤسسة جديدة';
			case 'superAdmin.companyName': return 'اسم الشركة أو المؤسسة';
			case 'superAdmin.companyNameHint': return 'مثال: شركة النصر';
			case 'superAdmin.primaryAdminName': return 'اسم المسؤول الرئيسي';
			case 'superAdmin.primaryAdminNameHint': return 'مثال: أحمد عبد الفتاح';
			case 'superAdmin.adminWorkEmail': return 'بريد عمل المسؤول';
			case 'superAdmin.adminWorkEmailHint': return 'admin@company.com';
			case 'superAdmin.tenantResources': return 'موارد وإحصائيات المؤسسة';
			case 'superAdmin.totalMembers': return 'إجمالي الأعضاء';
			case 'superAdmin.activeProjects': return 'المشاريع النشطة';
			case 'superAdmin.workTeams': return 'فرق العمل';
			case 'superAdmin.chatChannels': return 'قنوات المحادثة';
			case 'superAdmin.primaryAdminLead': return 'المسؤول الرئيسي للمؤسسة';
			case 'superAdmin.tenantId': return 'معرف المؤسسة';
			case 'superAdmin.slug': return 'المعرف';
			case 'superAdmin.suspendOrg': return 'تعليق المؤسسة';
			case 'superAdmin.reactivateOrg': return 'إعادة تفعيل المؤسسة';
			case 'superAdmin.deleteOrg': return 'حذف المؤسسة';
			case 'superAdmin.deleteOrgConfirmTitle': return 'هل تريد حذف المؤسسة؟';
			case 'superAdmin.deleteOrgConfirmMessage': return 'هل أنت متأكد من رغبتك في حذف هذه المؤسسة نهائياً؟ سيتم حذف جميع البيانات والأعضاء والمشاريع والقنوات المرتبطة بها.';
			case 'superAdmin.deletePermanently': return 'حذف نهائي';
			case 'superAdmin.inspectWorkspace': return 'فحص مساحة العمل كمالك للمنصة ←';
			case 'superAdmin.orgReactivated': return 'تمت إعادة تفعيل المؤسسة بنجاح';
			case 'superAdmin.orgSuspended': return 'تم تعليق المؤسسة بنجاح';
			case 'superAdmin.orgDeleted': return 'تم حذف المؤسسة بنجاح';
			case 'superAdmin.failedToProvision': return 'تعذر إنشاء المؤسسة';
			case 'teams.title': return 'فرق العمل';
			case 'teams.noTeams': return 'لا توجد فرق عمل';
			case 'teams.noTeamsSubtitle': return 'قم بتنظيم أعضاء المؤسسة في فرق عمل ومجموعات متخصصة.';
			case 'teams.createTeam': return 'إنشاء فريق';
			case 'teams.createFirstTeam': return 'إنشاء أول فريق';
			case 'teams.teamName': return 'اسم الفريق';
			case 'teams.teamNameHint': return 'مثال: الفريق الهندسي الرئيسي';
			case 'teams.teamDescription': return 'الوصف (اختياري)';
			case 'teams.teamDescriptionHint': return 'نطاق وهدف الفريق';
			case 'teams.failedToLoad': return 'تعذر تحميل فرق العمل';
			case 'teams.failedToCreate': return 'تعذر إنشاء الفريق';
			case 'teams.failedToDelete': return 'تعذر حذف الفريق';
			case 'calendar.title': return 'التقويم';
			case 'calendar.noMeetings': return 'لا توجد اجتماعات مجدولة';
			case 'calendar.noMeetingsSubtitle': return 'جدول مواعيد الفريق فارغ. قم بجدولة اجتماع أو مراجعة برمجية.';
			case 'calendar.scheduleMeeting': return 'جدولة اجتماع';
			case 'calendar.scheduleNewMeeting': return 'جدولة اجتماع جديد';
			case 'calendar.meetingTitle': return 'عنوان الاجتماع';
			case 'calendar.meetingTitleHint': return 'مثال: تخطيط السبرنت';
			case 'calendar.meetingUrl': return 'رابط الاجتماع / الغرفة';
			case 'calendar.meetingUrlHint': return 'https://meet.google.com/...';
			case 'calendar.failedToLoad': return 'تعذر تحميل الاجتماعات';
			case 'calendar.failedToSchedule': return 'تعذر جدولة الاجتماع';
			case 'projects.title': return 'المشاريع';
			case 'projects.all': return 'جميع المشاريع';
			case 'projects.create': return 'مشروع جديد';
			case 'projects.name': return 'اسم المشروع';
			case 'projects.description': return 'الوصف';
			case 'projects.status': return 'الحالة';
			case 'projects.tasksCount': return 'مهام';
			case 'projects.noProjects': return 'لا توجد مشاريع';
			case 'projects.noProjectsSubtitle': return 'أنشئ مشروعاً جديداً للبدء في تنظيم المهام وفريق العمل.';
			case 'projects.projectCreated': return 'تم إنشاء المشروع بنجاح';
			case 'projects.nameRequired': return 'اسم المشروع مطلوب';
			case 'projects.failedToLoad': return 'تعذر تحميل المشاريع';
			case 'projects.failedToCreate': return 'تعذر إنشاء المشروع';
			case 'projects.nameHint': return 'مثال: إعادة تصميم الموقع';
			case 'projects.descriptionHint': return 'تفاصيل موجزة عن أهداف المشروع...';
			case 'tasks.title': return 'المهام';
			case 'tasks.taskDetails': return 'تفاصيل المهمة';
			case 'tasks.myTasks': return 'مهامي';
			case 'tasks.allTasks': return 'جميع المهام';
			case 'tasks.create': return 'إنشاء مهمة';
			case 'tasks.edit': return 'تعديل المهمة';
			case 'tasks.name': return 'عنوان المهمة';
			case 'tasks.description': return 'الوصف';
			case 'tasks.priority': return 'الأولوية';
			case 'tasks.dueDate': return 'تاريخ الاستحقاق';
			case 'tasks.assignee': return 'المسؤول';
			case 'tasks.status': return 'الحالة';
			case 'tasks.todo': return 'قيد الانتظار';
			case 'tasks.inProgress': return 'قيد التنفيذ';
			case 'tasks.inReview': return 'قيد المراجعة';
			case 'tasks.done': return 'مكتملة';
			case 'tasks.priorityLow': return 'منخفضة';
			case 'tasks.priorityMedium': return 'متوسطة';
			case 'tasks.priorityHigh': return 'عالية';
			case 'tasks.priorityUrgent': return 'عاجلة';
			case 'tasks.noTasks': return 'لا توجد مهام';
			case 'tasks.noTasksSubtitle': return 'لا توجد مهام تطابق المعايير المحددة.';
			case 'tasks.taskCreated': return 'تم إنشاء المهمة بنجاح';
			case 'tasks.changeStatus': return 'تغيير الحالة';
			case 'tasks.titleRequired': return 'عنوان المهمة مطلوب';
			case 'tasks.failedToLoad': return 'تعذر تحميل المهام';
			case 'tasks.failedToCreate': return 'تعذر إنشاء المهمة';
			case 'tasks.titleHint': return 'مثال: تصميم شريط التطبيق العلوي';
			case 'tasks.descriptionHint': return 'أضف مزيداً من التفاصيل حول المهمة...';
			case 'channels.title': return 'الرسائل';
			case 'channels.channels': return 'القنوات';
			case 'channels.directMessages': return 'الرسائل المباشرة';
			case 'channels.typeMessage': return 'اكتب رسالة...';
			case 'channels.noMessages': return 'لا توجد رسائل بعد';
			case 'channels.noChannels': return 'لا توجد قنوات';
			case 'channels.noChannelsSubtitle': return 'لا توجد قنوات نشطة في هذه المؤسسة بعد.';
			case 'channels.startConversation': return 'أرسل رسالة لبدء المحادثة.';
			case 'channels.online': return 'متصل';
			case 'channels.offline': return 'غير متصل';
			case 'channels.failedToLoad': return 'تعذر تحميل القنوات';
			case 'notifications.title': return 'الإشعارات';
			case 'notifications.markAllAsRead': return 'تحديد الكل كمقروء';
			case 'notifications.noNotifications': return 'لا توجد إشعارات حالياً';
			case 'notifications.noNewNotifications': return 'لا توجد إشعارات جديدة';
			case 'notifications.failedToLoad': return 'تعذر تحميل الإشعارات';
			case 'settings.title': return 'الإعدادات';
			case 'settings.profile': return 'الملف الشخصي';
			case 'settings.language': return 'اللغة';
			case 'settings.english': return 'English';
			case 'settings.arabic': return 'العربية';
			case 'settings.theme': return 'المظهر';
			case 'settings.about': return 'حول SyncUp';
			case 'settings.version': return 'الإصدار';
			case 'settings.darkModeDesc': return 'المظهر الداكن عالي التباين';
			case 'settings.lightModeDesc': return 'المظهر الفاتح النهاري';
			case 'onboarding.sprintsTitle': return 'سبرنتات برمجية موحدة';
			case 'onboarding.sprintsSubtitle': return 'تابع المهام والتسليمات والتحديثات البرمجية في لوحة تحكم واحدة.';
			case 'onboarding.channelsTitle': return 'قنوات تواصل مشفرة للفرق';
			case 'onboarding.channelsSubtitle': return 'محادثات منظمة حسب الفريق أو المشروع أو الموضوع.';
			case 'onboarding.multiTenancyTitle': return 'بنية مؤسسية متعددة المستأجرين';
			case 'onboarding.multiTenancySubtitle': return 'عزل كامل لبيانات كل شركة مع صلاحيات دقيقة ومحكمة.';
			case 'splash.tagline': return 'منصة التعاون السحابية الخاصة للشركات';
			case 'splash.architecture': return 'بنية تحتية معزولة متعددة المستأجرين';
			default: return null;
		}
	}
}
