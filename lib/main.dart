import 'package:flutter/material.dart';
import 'app/smartsit_theme.dart';
import 'screens/auth_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartSitApp());
}

class SmartSitApp extends StatelessWidget {
  const SmartSitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSit',
      debugShowCheckedModeBanner: false,
      theme: SmartSitTheme.light,
      home: const SignInScreen(),
    );
  }
}
