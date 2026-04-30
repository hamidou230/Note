import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../app/routes.dart';

// ─────────────────────────────────────────────
//  OTP SCREEN
//  Sur Web → affiche message d'info
//  Sur Android → vrai SMS Firebase
// ─────────────────────────────────────────────

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _secondsLeft = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
        }
      });
      return _secondsLeft > 0;
    });
  }

  void _verify() async {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length < 6) {
      _showError('Entrez le code complet à 6 chiffres');
      return;
    }

    // ── Sur Web → pas de vrai SMS ──
    if (kIsWeb) {
      _showWebWarning();
      return;
    }

    // ── Sur Android → vrai Firebase ──
    setState(() => _isLoading = true);
    try {
      // TODO: Connecter avec AuthService.verifyOtp()
      // final result = await AuthService.verifyOtp(code: otp, ...);
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.clientHome);
    } catch (e) {
      _showError('Code incorrect. Réessayez.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.kError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showWebWarning() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('Mode Web', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Le SMS OTP ne fonctionne pas sur navigateur Web.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text('Pour tester le vrai SMS :'),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.android, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text('Utilise un téléphone Android'),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.phone_android, color: AppTheme.kBlueLight, size: 18),
                SizedBox(width: 6),
                Text('flutter run -d android'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // En mode web on laisse passer pour tester l'interface
              Navigator.pushReplacementNamed(context, AppRoutes.clientHome);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.kBlue),
            child: const Text(
              'Continuer quand même (test)',
              style: TextStyle(color: AppTheme.kWhite),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      backgroundColor: AppTheme.kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.kBlueDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Icône SMS
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppTheme.kBlue, AppTheme.kBlueDark]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.kBlue.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8))
                ],
              ),
              child: const Icon(Icons.sms, color: AppTheme.kWhite, size: 44),
            ),
            const SizedBox(height: 24),

            const Text('Vérification SMS',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.kBlueDark)),
            const SizedBox(height: 8),
            Text(
              'Un code à 6 chiffres a été envoyé\nau numéro +222 $phone',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.kGrey, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Avertissement Web
            if (kIsWeb)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mode Web : Aucun SMS envoyé.\nUtilise Android pour le vrai SMS.',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Champs OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) => _buildOtpBox(i)),
            ),
            const SizedBox(height: 24),

            // Timer
            if (!_canResend)
              Text(
                'Renvoyer le code dans $_secondsLeft secondes',
                style: const TextStyle(color: AppTheme.kGrey, fontSize: 13),
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() {
                    _canResend = false;
                    _secondsLeft = 60;
                  });
                  _startTimer();
                },
                child: const Text(
                  'Renvoyer le code',
                  style: TextStyle(
                      color: AppTheme.kBlueLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
            const SizedBox(height: 24),

            CustomButton(
              label: kIsWeb ? 'Continuer (test Web)' : 'Vérifier',
              onPressed: _verify,
              isLoading: _isLoading,
              icon: Icons.check_circle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48, height: 56,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.kBlueDark),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppTheme.kWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            BorderSide(color: AppTheme.kBlue.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: AppTheme.kBlue, width: 2),
          ),
        ),
        onChanged: (val) {
          if (val.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}