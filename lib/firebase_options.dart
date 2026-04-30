import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  // ── Web ──
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCdEPVoP9mcOb_4vfv5oDks6WQS_74g7hw',
    authDomain: 'lmessar.firebaseapp.com',
    projectId: 'lmessar',
    storageBucket: 'lmessar.firebasestorage.app',
    messagingSenderId: '639825183447',
    appId: '1:639825183447:web:6dc38f8b59d90856ae6692',
    measurementId: 'G-9N968V45F8',
  );

  // ── Android ──
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdEPVoP9mcOb_4vfv5oDks6WQS_74g7hw',
    appId: '1:639825183447:android:c76465c097db5d03ae6692',
    messagingSenderId: '639825183447',
    projectId: 'lmessar',
    storageBucket: 'lmessar.firebasestorage.app',
  );

  // ── iOS ──
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdEPVoP9mcOb_4vfv5oDks6WQS_74g7hw',
    appId: '1:639825183447:ios:lmessar',
    messagingSenderId: '639825183447',
    projectId: 'lmessar',
    storageBucket: 'lmessar.firebasestorage.app',
    iosBundleId: 'com.sidi.test22',
  );
}