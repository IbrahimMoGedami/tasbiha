import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbiha/main.dart';
import 'package:tasbiha/storage/shared_preferences_helper.dart';

void main() {
  testWidgets('Tasbiha counter increments from tap target', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreferencesHelper.init();

    await tester.pumpWidget(const TasbihaApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byKey(const Key('tasbiha_tap')));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Total: 1'), findsOneWidget);
  });
}
