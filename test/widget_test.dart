// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:books_manager/main.dart';
import 'package:books_manager/services/api_service.dart';
import 'package:books_manager/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialiser sqflite_ffi pour les tests
  setUpAll(() {
    // Initialiser FFI
    sqfliteFfiInit();
    // Définir la factory de base de données
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    final databaseService = DatabaseService();
    await databaseService.init();
    final apiService = ApiService();

    await tester.pumpWidget(
      MyApp(databaseService: databaseService, apiService: apiService),
    );

    // Verify that the app title is displayed
    expect(find.text('Book Finder'), findsOneWidget);
  });
}
