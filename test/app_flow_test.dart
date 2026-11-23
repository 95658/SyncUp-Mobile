import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncup/app/features/auth/presentation/screens/login_screen.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  testWidgets('App Flow Sample: Renders Login Screen, validates input fields, and checks buttons',
      (WidgetTester tester) async {
    // 1. Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // 2. Build the LoginScreen inside ProviderScope
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 3. Verify Initial State & UI Elements
    expect(find.text('SyncUp'), findsOneWidget);
    expect(find.text('Sign In'), findsNWidgets(1));
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // 4. Try submitting with empty fields -> Triggers validation errors
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    // 5. Enter invalid email
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'invalid-email');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);

    // 6. Enter valid format email and short password
    await tester.enterText(emailField, 'ahmed@syncup.com');
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(passwordField, '123');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    // 7. Enter valid credentials format and validate
    await tester.enterText(passwordField, 'StrongPassword123!');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Verify error messages disappear
    expect(find.text('Password must be at least 6 characters'), findsNothing);
  });
}
