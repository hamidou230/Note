// ─────────────────────────────────────────────
//  LOCATION SERVICE
//  flutter pub add geolocator
// ─────────────────────────────────────────────

class LocationService {
  // Simulé - à remplacer par geolocator en production

  static Future<Map<String, double>> getCurrentPosition() async {
    await Future.delayed(const Duration(seconds: 1));
    // En production : Geolocator.getCurrentPosition()
    return {'lat': 18.0735, 'lng': -15.9582}; // Nouakchott par défaut
  }

  static Future<bool> requestPermission() async {
    // En production : Geolocator.requestPermission()
    return true;
  }

  // ── Recherche de lieu (Nominatim OpenStreetMap) ──
  static Future<List<Map<String, dynamic>>> searchPlace(String query) async {
    // En production : appel HTTP à Nominatim
    // GET https://nominatim.openstreetmap.org/search?q={query}&format=json&limit=5
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'name': '$query - Résultat 1', 'lat': 18.0740, 'lng': -15.9590},
      {'name': '$query - Résultat 2', 'lat': 18.0720, 'lng': -15.9570},
    ];
  }

  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Calcul simple de distance en km
    const double earthRadius = 6371;
    double dLat = (lat2 - lat1) * (3.14159 / 180);
    double dLng = (lng2 - lng1) * (3.14159 / 180);
    double a = dLat * dLat + dLng * dLng;
    return earthRadius * (2 * (a < 0 ? -a : a));
  }
}
