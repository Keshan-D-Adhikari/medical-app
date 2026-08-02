import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medical_app/main.dart';
import 'package:medical_app/pages/index.dart';
import 'package:medical_app/pages/login_page.dart';
import 'package:medical_app/pages/signup_page.dart';
import 'package:medical_app/pages/start_page.dart';

void main() {
  testWidgets('app opens on the start page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(StartPage), findsOneWidget);
    expect(find.text('Find Your Specialist'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Get Started navigates to the login page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('DoctApp'), findsOneWidget);
  });

  testWidgets('login validates an empty form without calling the API',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    // Still on the login page — nothing was submitted.
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('login rejects a malformed email', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('signup requires matching passwords', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupPage()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ada');
    await tester.enterText(fields.at(1), 'Lovelace');
    await tester.enterText(fields.at(2), 'ada@example.com');
    await tester.enterText(fields.at(4), 'secret123');
    await tester.enterText(fields.at(5), 'different');

    await tester.ensureVisible(find.text('Create an account'));
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('home tab shows every specialty and filters on search',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Index()));
    await tester.pumpAndSettle();

    for (final specialty in kSpecialties) {
      expect(find.text(specialty.label), findsOneWidget);
    }

    await tester.enterText(find.byType(TextField).first, 'card');
    await tester.pumpAndSettle();

    expect(find.text('Cardiology'), findsOneWidget);
    expect(find.text('Neurology'), findsNothing);
  });

  testWidgets('bottom navigation switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Index()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();

    expect(find.text('Profile is not built yet'), findsOneWidget);
  });
}
