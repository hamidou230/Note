import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ─────────────────────────────────────────────
//  PAGE CLIENT - LMESSAR
//  Ajouter dans pubspec.yaml :
//  flutter_map: ^6.0.0
//  latlong2: ^0.9.0
// ─────────────────────────────────────────────

class ClientHomeScreen extends StatefulWidget {
  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  static const kBlue = Color(0xFF1565C0);
  static const kBlueLight = Color(0xFF1E88E5);
  static const kBlueDark = Color(0xFF0D47A1);
  static const kWhite = Color(0xFFFFFFFF);
  static const kGrey = Color(0xFF90A4AE);
  static const kBg = Color(0xFFF0F4FF);

  final MapController _mapController = MapController();
  LatLng _myPosition = const LatLng(18.0735, -15.9582); // Nouakchott
  LatLng? _destination;
  double _distanceKm = 0;
  double _prixMRU = 0;
  bool _taxiCommande = false;
  bool _chauffeurEnRoute = false;

  final _destinationCtrl = TextEditingController();

  final List<Map<String, dynamic>> _chauffeurs = [
    {
      'nom': 'Ahmed Ould Salem',
      'note': 4.8,
      'voiture': 'Toyota Corolla - Blanc',
      'temps': '3 min',
      'position': LatLng(18.0780, -15.9600),
    },
    {
      'nom': 'Mohamed Lemine',
      'note': 4.6,
      'voiture': 'Hyundai Accent - Gris',
      'temps': '5 min',
      'position': LatLng(18.0700, -15.9550),
    },
  ];

  void _calculerPrix() {
    if (_destination != null) {
      final distance = const Distance();
      _distanceKm =
          distance(_myPosition, _destination!) / 1000;
      _prixMRU = _distanceKm * 40;
      setState(() {});
    }
  }

  void _commanderTaxi() {
    setState(() {
      _taxiCommande = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _chauffeurEnRoute = true;
        });
      }
    });
  }

  void _annuler() {
    setState(() {
      _taxiCommande = false;
      _chauffeurEnRoute = false;
      _destination = null;
      _distanceKm = 0;
      _prixMRU = 0;
      _destinationCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // ── CARTE ──
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _myPosition,
              initialZoom: 14,
              onTap: (_, point) {
                setState(() {
                  _destination = point;
                });
                _calculerPrix();
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.lmessar.app',
              ),
              MarkerLayer(
                markers: [
                  // Ma position
                  Marker(
                    point: _myPosition,
                    width: 60,
                    height: 60,
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kBlue,
                            shape: BoxShape.circle,
                            border:
                            Border.all(color: kWhite, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: kBlue.withOpacity(0.4),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: const Icon(Icons.person,
                              color: kWhite, size: 22),
                        ),
                      ],
                    ),
                  ),
                  // Destination
                  if (_destination != null)
                    Marker(
                      point: _destination!,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 44),
                    ),
                  // Chauffeurs proches
                  ..._chauffeurs.map((c) => Marker(
                    point: c['position'] as LatLng,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.local_taxi,
                        color: kBlueLight, size: 36),
                  )),
                ],
              ),
            ],
          ),

          // ── TOP BAR ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [kBlueDark, kBlue]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kBlue.withOpacity(0.4),
                            blurRadius: 12,
                          )
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.local_taxi,
                              color: kWhite, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Lmessar',
                            style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: kBlue),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.person_outline,
                            color: kBlue),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── BOTTOM PANEL ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _taxiCommande
                ? _buildChauffeurPanel()
                : _buildSearchPanel(),
          ),

          // ── Bouton recentrer ──
          Positioned(
            right: 16,
            bottom: _taxiCommande ? 280 : 320,
            child: FloatingActionButton.small(
              onPressed: () {
                _mapController.move(_myPosition, 15);
              },
              backgroundColor: kWhite,
              child: const Icon(Icons.my_location, color: kBlue),
            ),
          ),
        ],
      ),
    );
  }

  // ── PANEL RECHERCHE ──
  Widget _buildSearchPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          )
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Où allez-vous ? 🗺️',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: kBlueDark,
            ),
          ),
          const SizedBox(height: 16),

          // Champ destination
          TextField(
            controller: _destinationCtrl,
            style: const TextStyle(color: kBlueDark),
            decoration: InputDecoration(
              hintText: 'Entrez votre destination...',
              hintStyle: const TextStyle(color: kGrey),
              prefixIcon:
              const Icon(Icons.search, color: kBlueLight),
              filled: true,
              fillColor: kBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),

          // Info : cliquer sur la carte
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.touch_app, color: kBlueLight, size: 18),
                SizedBox(width: 8),
                Text(
                  'Ou appuyez sur la carte pour choisir',
                  style: TextStyle(color: kGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Prix estimé
          if (_destination != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [kBlueDark, kBlueLight]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Distance estimée',
                        style:
                        TextStyle(color: kWhite, fontSize: 12),
                      ),
                      Text(
                        '${_distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          color: kWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Prix estimé (40 MRU/km)',
                        style:
                        TextStyle(color: kWhite, fontSize: 12),
                      ),
                      Text(
                        '${_prixMRU.toStringAsFixed(0)} MRU',
                        style: const TextStyle(
                          color: kWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bouton commander
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kBlueDark, kBlueLight],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kBlue.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _commanderTaxi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.local_taxi,
                      color: kWhite),
                  label: const Text(
                    'Commander un Taxi',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── PANEL CHAUFFEUR EN ROUTE ──
  Widget _buildChauffeurPanel() {
    final chauffeur = _chauffeurs[0];
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          )
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _chauffeurEnRoute
                  ? Colors.green[50]
                  : Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _chauffeurEnRoute
                      ? Icons.check_circle
                      : Icons.access_time,
                  color: _chauffeurEnRoute
                      ? Colors.green
                      : Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _chauffeurEnRoute
                      ? 'Chauffeur en route !'
                      : 'Recherche d\'un chauffeur...',
                  style: TextStyle(
                    color: _chauffeurEnRoute
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_chauffeurEnRoute) ...[
            // Info chauffeur
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [kBlueDark, kBlueLight]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person,
                      color: kWhite, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chauffeur['nom'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kBlueDark,
                        ),
                      ),
                      Text(
                        chauffeur['voiture'] as String,
                        style: const TextStyle(
                            color: kGrey, fontSize: 13),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                          Text(
                            ' ${chauffeur['note']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kBlueDark,
                            ),
                          ),
                          const Text(' • ',
                              style: TextStyle(color: kGrey)),
                          Text(
                            chauffeur['temps'] as String,
                            style: const TextStyle(
                                color: kBlueLight,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Appel
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.phone,
                        color: Colors.green),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Prix final
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.route,
                          color: kBlueLight, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${_distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(
                            color: kBlueDark,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined,
                          color: kBlueLight, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${_prixMRU.toStringAsFixed(0)} MRU',
                        style: const TextStyle(
                          color: kBlueDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            const LinearProgressIndicator(
              backgroundColor: kBg,
              color: kBlueLight,
            ),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 16),

          // Bouton annuler
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _annuler,
              icon: const Icon(Icons.cancel_outlined,
                  color: Colors.red),
              label: const Text(
                'Annuler la course',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}