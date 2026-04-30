import 'package:flutter/material.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_client_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/driver_register_screen.dart';
import '../features/client/home_screen.dart';
import '../features/driver/home_screen.dart';
import '../features/admin/dashboard_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const registerClient = '/register-client';
  static const otp = '/otp';
  static const driverRegister = '/driver-register';
  static const clientHome = '/client-home';
  static const driverHome = '/driver-home';
  static const adminHome = '/admin-home';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => LoginScreen(),
    registerClient: (_) => RegisterClientScreen(),
    otp: (_) => OtpScreen(),
    driverRegister: (_) => DriverRegisterScreen(),
    clientHome: (_) => ClientHomeScreen(),
    driverHome: (_) => DriverHomeScreen(),
    adminHome: (_) => AdminDashboardScreen(),
  };
}
