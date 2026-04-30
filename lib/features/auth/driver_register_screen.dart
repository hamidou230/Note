import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/constants.dart';

class DriverRegisterScreen extends StatefulWidget {
  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _carModelCtrl = TextEditingController();
  final _carColorCtrl = TextEditingController();
  final _licensePlateCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _passVisible = false;
  bool _confirmVisible = false;
  bool _isLoading = false;
  bool _formSent = false; // ← afficher message de succès

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _formSent = true; // ← afficher le message succès
      });
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
        title: const Text('Inscription Chauffeur',
          style: TextStyle(color: AppTheme.kBlueDark, fontWeight: FontWeight.w800)),
      ),
      body: _formSent ? _buildSuccessScreen() : _buildForm(),
    );
  }

  // ── ÉCRAN SUCCÈS ──
  Widget _buildSuccessScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône succès
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
            ),
            const SizedBox(height: 24),

            const Text('Formulaire envoyé ! ✅',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.kBlueDark)),
            const SizedBox(height: 12),

            const Text(
              'Votre demande a été bien reçue.\nNous allons l\'examiner.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.kGrey, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // ── MESSAGE WHATSAPP ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contactez-nous sur WhatsApp',
                              style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.kBlueDark, fontSize: 15)),
                            Text('Pour accélérer votre approbation',
                              style: TextStyle(color: AppTheme.kGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📱 Notre numéro WhatsApp :',
                          style: TextStyle(color: AppTheme.kGrey, fontSize: 12)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Text(
                              '+222 ${AppConstants.whatsappNumber}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF25D366),
                                letterSpacing: 1,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(const ClipboardData(text: AppConstants.whatsappNumber));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Numéro copié !')),
                                );
                              },
                              icon: const Icon(Icons.copy, color: AppTheme.kBlueLight, size: 20),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 4),
                        const Text('💬 Message à envoyer :',
                          style: TextStyle(color: AppTheme.kGrey, fontSize: 12)),
                        const SizedBox(height: 6),
                        const Text(
                          'Bonjour Lmessar, j\'ai soumis mon formulaire d\'inscription comme chauffeur. Je voudrais savoir le statut de ma demande.',
                          style: TextStyle(color: AppTheme.kBlueDark, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Bouton WhatsApp
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Ouvrir WhatsApp (avec url_launcher en production)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ouvre WhatsApp et contacte le +222 36400042')),
                        );
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text('Ouvrir WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info attente admin
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber[300]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vous pourrez vous connecter normalement une fois que l\'administrateur aura approuvé votre compte.',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                side: const BorderSide(color: AppTheme.kBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Retour à la connexion',
                style: TextStyle(color: AppTheme.kBlue, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ── FORMULAIRE ──
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.kBlueDark, AppTheme.kBlue]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.drive_eta, color: AppTheme.kWhite, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Devenir Chauffeur Lmessar',
                          style: TextStyle(color: AppTheme.kWhite, fontWeight: FontWeight.w800, fontSize: 16)),
                        Text('Remplissez le formulaire ci-dessous',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('👤 Informations personnelles'),
                  const SizedBox(height: 14),

                  CustomTextField(
                    controller: _nameCtrl,
                    label: 'Nom complet',
                    icon: Icons.person_outline,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 12),

                  CustomTextField(
                    controller: _phoneCtrl,
                    label: 'Numéro de téléphone',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('🚗 Informations du véhicule'),
                  const SizedBox(height: 14),

                  CustomTextField(
                    controller: _carModelCtrl,
                    label: 'Modèle de voiture (ex: Toyota Corolla)',
                    icon: Icons.directions_car_outlined,
                    validator: Validators.carModel,
                  ),
                  const SizedBox(height: 12),

                  CustomTextField(
                    controller: _carColorCtrl,
                    label: 'Couleur du véhicule',
                    icon: Icons.color_lens_outlined,
                    validator: (val) => val == null || val.isEmpty ? 'Couleur obligatoire' : null,
                  ),
                  const SizedBox(height: 12),

                  CustomTextField(
                    controller: _licensePlateCtrl,
                    label: 'Numéro de plaque d\'immatriculation',
                    icon: Icons.badge_outlined,
                    validator: Validators.licensePlate,
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('🔐 Mot de passe'),
                  const SizedBox(height: 14),

                  CustomTextField(
                    controller: _passwordCtrl,
                    label: 'Mot de passe',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isVisible: _passVisible,
                    onToggleVisibility: () => setState(() => _passVisible = !_passVisible),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 12),

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

                  CustomButton(
                    label: 'Envoyer ma demande',
                    onPressed: _submitForm,
                    isLoading: _isLoading,
                    icon: Icons.send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
      style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.kBlueDark, fontSize: 15));
  }
}
