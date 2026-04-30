import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String? _verificationId;
  static String? _currentRole;

  static String? get currentRole => _currentRole;
  static User? get currentUser => _auth.currentUser;

  // ── Envoyer OTP SMS ──
  static Future<bool> sendOtp(String phone) async {
    bool sent = false;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+222$phone',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('OTP Error: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          sent = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
      await Future.delayed(const Duration(seconds: 3));
      return sent || _verificationId != null;
    } catch (e) {
      print('SendOTP Error: $e');
      return false;
    }
  }

  // ── Vérifier OTP ──
  static Future<Map<String, dynamic>> verifyOtp({
    required String code,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      if (_verificationId == null) return {'success': false, 'error': 'Code expiré'};

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      // Sauvegarder dans Firestore
      await _db.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'name': name,
        'phone': phone,
        'role': 'client',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentRole = 'client';
      return {'success': true, 'role': 'client'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ── Connexion chauffeur/client (mot de passe) ──
  static Future<Map<String, dynamic>> loginWithPhone({
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      // Chercher dans Firestore
      String collection = role == 'driver' ? 'drivers' : 'users';
      QuerySnapshot snap = await _db
          .collection(collection)
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) {
        return {'success': false, 'error': 'Numéro introuvable'};
      }

      Map<String, dynamic> userData = snap.docs.first.data() as Map<String, dynamic>;

      // Vérifier mot de passe (en production utiliser bcrypt)
      if (userData['password'] != password) {
        return {'success': false, 'error': 'Mot de passe incorrect'};
      }

      // Vérifier si chauffeur approuvé
      if (role == 'driver' && userData['status'] == 'en_attente') {
        return {'success': false, 'error': 'Votre compte est en attente d\'approbation'};
      }

      if (userData['isActive'] == false) {
        return {'success': false, 'error': 'Votre compte est désactivé'};
      }

      _currentRole = role;
      return {'success': true, 'role': role, 'data': userData};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ── Inscription chauffeur ──
  static Future<Map<String, dynamic>> registerDriver({
    required String name,
    required String phone,
    required String carModel,
    required String carColor,
    required String licensePlate,
    required String password,
  }) async {
    try {
      // Vérifier si numéro existe déjà
      QuerySnapshot existing = await _db
          .collection('drivers')
          .where('phone', isEqualTo: phone)
          .get();

      if (existing.docs.isNotEmpty) {
        return {'success': false, 'error': 'Ce numéro est déjà utilisé'};
      }

      // Ajouter dans Firestore
      await _db.collection('drivers').add({
        'name': name,
        'phone': phone,
        'carModel': carModel,
        'carColor': carColor,
        'licensePlate': licensePlate,
        'password': password,
        'status': 'en_attente',
        'isOnline': false,
        'isActive': true,
        'rating': 0.0,
        'totalRides': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ── Admin login ──
  static Future<Map<String, dynamic>> adminLogin({
    required String email,
    required String password,
  }) async {
    if (email == 'papa_sidi' && password == '19632222') {
      _currentRole = 'admin';
      return {'success': true, 'role': 'admin'};
    }
    return {'success': false, 'error': 'Identifiants admin incorrects'};
  }

  // ── Déconnexion ──
  static Future<void> logout() async {
    await _auth.signOut();
    _currentRole = null;
    _verificationId = null;
  }
}