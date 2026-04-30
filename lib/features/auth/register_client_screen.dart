import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../core/utils/validators.dart';
import '../../app/routes.dart';

class RegisterClientScreen extends StatefulWidget {
  @override
  State<RegisterClientScreen> createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _passVisible = false;
  bool _confirmVisible = false;
  bool _isLoading = false;

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Passer à l'écran OTP avec le numéro
      Navigator.pushNamed(context, AppRoutes.otp, arguments: _phoneCtrl.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.kBlueDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Inscription Client', style: TextStyle(color: AppTheme.kBlueDark, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône
                Center(
                  child: Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppTheme.kBlue, AppTheme.kBlueDark]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_add, color: AppTheme.kWhite, size: 36),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text('Créer votre compte',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.kBlueDark)),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text('Un code SMS sera envoyé pour vérifier\nvotre numéro de téléphone',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.kGrey, fontSize: 12)),
                ),
                const SizedBox(height: 24),

                // Nom
                CustomTextField(
                  controller: _nameCtrl,
                  label: 'Nom complet',
                  icon: Icons.person_outline,
                  validator: Validators.name,
                ),
                const SizedBox(height: 14),

                // Téléphone
                CustomTextField(
                  controller: _phoneCtrl,
                  label: 'Numéro de téléphone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                const SizedBox(height: 14),

                // Confirmation
                CustomTextField(
                  controller: _confirmCtrl,
                  label: 'Confirmer le mot de passe',
                  icon: Icons.lock_person_outlined,
                  isPassword: true,
                  isVisible: _confirmVisible,
                  onToggleVisibility: () => setState(() => _confirmVisible = !_confirmVisible),
                  validator: (val) => Validators.confirmPassword(val, _passwordCtrl.text),
                ),
                const SizedBox(height: 24),

                // Info SMS
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.sms, color: AppTheme.kBlueLight, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Un code de vérification sera envoyé par SMS à votre numéro',
                          style: TextStyle(color: AppTheme.kBlueDark, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                CustomButton(
                  label: 'Recevoir le code SMS',
                  onPressed: _sendOtp,
                  isLoading: _isLoading,
                  icon: Icons.sms,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
