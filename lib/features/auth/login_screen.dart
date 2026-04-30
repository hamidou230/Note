import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/constants.dart';
import '../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _passVisible = false;
  bool _isLoading = false;
  String _selectedRole = 'client';

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Admin login par email spécial
      if (_phoneCtrl.text.trim() == AppConstants.adminEmail &&
          _passwordCtrl.text.trim() == AppConstants.adminPassword) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
        return;
      }

      if (_selectedRole == 'client') {
        Navigator.pushReplacementNamed(context, AppRoutes.clientHome);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBg,
      body: Stack(
        children: [
          // Cercles décoratifs
          Positioned(top: -80, right: -80,
            child: Container(width: 280, height: 280,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.kBlue.withOpacity(0.08)))),
          Positioned(top: -40, left: -60,
            child: Container(width: 180, height: 180,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.kBlueLight.withOpacity(0.10)))),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Bon retour ! 👋',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.kBlueDark)),
                          const SizedBox(height: 4),
                          const Text('Connectez-vous à votre compte',
                            style: TextStyle(color: AppTheme.kGrey, fontSize: 13)),
                          const SizedBox(height: 24),

                          // Téléphone ou email admin
                          CustomTextField(
                            controller: _phoneCtrl,
                            label: 'Numéro de téléphone',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              // Permettre email admin
                              if (val == AppConstants.adminEmail) return null;
                              return Validators.phone(val);
                            },
                          ),
                          const SizedBox(height: 14),

                          // Mot de passe
                          CustomTextField(
                            controller: _passwordCtrl,
                            label: 'Mot de passe',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            isVisible: _passVisible,
                            onToggleVisibility: () => setState(() => _passVisible = !_passVisible),
                            validator: Validators.password,
                          ),
                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Mot de passe oublié ?',
                                style: TextStyle(color: AppTheme.kBlueLight, fontSize: 12)),
                            ),
                          ),

                          // Rôle
                          const Text('Je suis :',
                            style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.kBlueDark, fontSize: 14)),
                          const SizedBox(height: 10),
                          _buildRoleSelector(),
                          const SizedBox(height: 20),

                          CustomButton(
                            label: 'Se connecter',
                            onPressed: _login,
                            isLoading: _isLoading,
                            icon: Icons.login,
                          ),
                          const SizedBox(height: 16),

                          // Liens inscription
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Pas de compte ? ", style: TextStyle(color: AppTheme.kGrey, fontSize: 13)),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  _selectedRole == 'client'
                                      ? AppRoutes.registerClient
                                      : AppRoutes.driverRegister,
                                ),
                                child: const Text("S'inscrire",
                                  style: TextStyle(color: AppTheme.kBlueLight, fontWeight: FontWeight.w700, fontSize: 13)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 85, height: 85,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppTheme.kBlue, AppTheme.kBlueDark]),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: AppTheme.kBlue.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: const Icon(Icons.local_taxi, color: AppTheme.kWhite, size: 44),
        ),
        const SizedBox(height: 14),
        const Text('Lmessar',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppTheme.kBlueDark, letterSpacing: 1.5)),
        const Text('Votre taxi en ligne en Mauritanie',
          style: TextStyle(fontSize: 12, color: AppTheme.kGrey)),
      ],
    );
  }

  Widget _buildRoleSelector() {
    final roles = [
      {'id': 'client', 'label': 'Client', 'icon': Icons.person},
      {'id': 'driver', 'label': 'Chauffeur', 'icon': Icons.drive_eta},
    ];
    return Row(
      children: roles.map((role) {
        final isSelected = _selectedRole == role['id'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedRole = role['id'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: role['id'] == 'client' ? const EdgeInsets.only(right: 8) : const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? const LinearGradient(colors: [AppTheme.kBlue, AppTheme.kBlueLight]) : null,
                color: isSelected ? null : Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? AppTheme.kBlue : Colors.grey[300]!, width: 1.5),
              ),
              child: Column(
                children: [
                  Icon(role['icon'] as IconData, color: isSelected ? AppTheme.kWhite : AppTheme.kGrey, size: 24),
                  const SizedBox(height: 4),
                  Text(role['label'] as String,
                    style: TextStyle(color: isSelected ? AppTheme.kWhite : AppTheme.kGrey, fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
