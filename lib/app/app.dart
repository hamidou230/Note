import 'package:flutter/material.dart';
import 'routes.dart';
import '../shared/theme/app_theme.dart';
import '../features/auth/login_screen.dart';

class LmessarApp extends StatelessWidget {
  const LmessarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lmessar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: LoginScreen(),
      routes: AppRoutes.routes,
    );
  }
}
