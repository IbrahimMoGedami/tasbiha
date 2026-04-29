import 'package:flutter/material.dart';
import 'package:tasbiha/screens/tasbiha_home_screen.dart';
import 'package:tasbiha/storage/shared_preferences_helper.dart';
import 'package:tasbiha/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(const TasbihaApp());
}

class TasbihaApp extends StatelessWidget {
  const TasbihaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasbiha',
      debugShowCheckedModeBanner: false,
      theme: TasbihaTheme.light(),
      home: const TasbihaHomeScreen(),
    );
  }
}
