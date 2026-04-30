import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Collections ──
  static const String users = 'users';
  static const String drivers = 'drivers';
  static const String rides = 'rides';

  // ════════════════════════════════════════
  //  CLIENTS
  // ════════════════════════════════════════

  // Récupérer tous les clients
  static Stream<QuerySnapshot> getClients() {
    return _db.collection(users)
        .where('role', isEqualTo: 'client')
        .snapshots();
  }

  // Activer/Désactiver client
  static Future<void> toggleClientStatus(String docId, bool isActive) async {
    await _db.collection(users).doc(docId).update({'isActive': isActive});
  }

  // Supprimer client
  static Future<void> deleteClient(String docId) async {
    await _db.collection(users).doc(docId).delete();
  }

  // ════════════════════════════════════════
  //  CHAUFFEURS
  // ════════════════════════════════════════

  // Récupérer tous les chauffeurs
  static Stream<QuerySnapshot> getDrivers() {
    return _db.collection(drivers).snapshots();
  }

  // Approuver chauffeur
  static Future<void> approveDriver(String docId) async {
    await _db.collection(drivers).doc(docId).update({
      'status': 'approuve',
      'isActive': true,
    });
  }

  // Suspendre/Réactiver chauffeur
  static Future<void> toggleDriverStatus(String docId, bool isActive) async {
    await _db.collection(drivers).doc(docId).update({'isActive': isActive});
  }

  // Supprimer chauffeur
  static Future<void> deleteDriver(String docId) async {
    await _db.collection(drivers).doc(docId).delete();
  }

  // Chauffeur en ligne/hors ligne
  static Future<void> setDriverOnline(String docId, bool isOnline) async {
    await _db.collection(drivers).doc(docId).update({'isOnline': isOnline});
  }

  // ════════════════════════════════════════
  //  COURSES
  // ════════════════════════════════════════

  // Créer une course
  static Future<String> createRide({
    required String clientId,
    required String clientName,
    required String pickup,
    required String destination,
    required double distanceKm,
    required double price,
  }) async {
    DocumentReference ref = await _db.collection(rides).add({
      'clientId': clientId,
      'clientName': clientName,
      'driverId': '',
      'driverName': '',
      'pickup': pickup,
      'destination': destination,
      'distanceKm': distanceKm,
      'price': price,
      'status': 'en_attente',
      'date': DateTime.now().toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  // Récupérer toutes les courses
  static Stream<QuerySnapshot> getRides() {
    return _db.collection(rides)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Accepter une course (chauffeur)
  static Future<void> acceptRide({
    required String rideId,
    required String driverId,
    required String driverName,
  }) async {
    await _db.collection(rides).doc(rideId).update({
      'driverId': driverId,
      'driverName': driverName,
      'status': 'en_cours',
    });
  }

  // Terminer une course
  static Future<void> completeRide(String rideId) async {
    await _db.collection(rides).doc(rideId).update({'status': 'termine'});
  }

  // Annuler une course
  static Future<void> cancelRide(String rideId) async {
    await _db.collection(rides).doc(rideId).update({'status': 'annule'});
  }

  // ════════════════════════════════════════
  //  STATS ADMIN
  // ════════════════════════════════════════

  static Future<Map<String, dynamic>> getStats() async {
    final clientsSnap = await _db.collection(users).where('role', isEqualTo: 'client').get();
    final driversSnap = await _db.collection(drivers).where('status', isEqualTo: 'approuve').get();
    final pendingSnap = await _db.collection(drivers).where('status', isEqualTo: 'en_attente').get();
    final ridesSnap = await _db.collection(rides).where('status', isEqualTo: 'termine').get();

    double totalGains = 0;
    for (var doc in ridesSnap.docs) {
      totalGains += (doc.data() as Map)['price'] ?? 0;
    }

    return {
      'totalClients': clientsSnap.docs.length,
      'totalDrivers': driversSnap.docs.length,
      'pendingDrivers': pendingSnap.docs.length,
      'totalGains': totalGains,
    };
  }
}