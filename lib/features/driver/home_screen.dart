import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ─────────────────────────────────────────────
//  PAGE CHAUFFEUR - LMESSAR
// ─────────────────────────────────────────────

class DriverHomeScreen extends StatefulWidget {
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  static const kBlue = Color(0xFF1565C0);
  static const kBlueLight = Color(0xFF1E88E5);
  static const kBlueDark = Color(0xFF0D47A1);
  static const kWhite = Color(0xFFFFFFFF);
  static const kGrey = Color(0xFF90A4AE);
  static const kBg = Color(0xFFF0F4FF);

  final MapController _mapController = MapController();
  final LatLng _myPosition = const LatLng(18.0780, -15.9600);

  bool _isOnline = false;
  bool _hasRequest = false;
  bool _courseAcceptee = false;
  int _coursesAujourdhui = 5;
  double _gainsAujourdhui = 1250;

  // Demande de course simulée
  final Map<String, dynamic> _demandeClient = {
    'nom': 'Fatima Mint Ahmed',
    'distance': 4.2,
    'prix': 168.0,
    'pickup': 'Marché Capitale, Nouakchott',
    'destination': 'Université de Nouakchott',
    'position': LatLng(18.0735, -15.9582),
  };

  void _toggleOnline() {
    setState(() {
      _isOnline = !_isOnline;
      if (_isOnline) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isOnline) {
            setState(() => _hasRequest = true);
          }
        });
      } else {
        _hasRequest = false;
        _courseAcceptee = false;
      }
    });
  }

  void _accepterCourse() {
    setState(() {
      _hasRequest = false;
      _courseAcceptee = true;
    });
  }

  void _refuserCourse() {
    setState(() => _hasRequest = false);
  }

  void _terminerCourse() {
    setState(() {
      _courseAcceptee = false;
      _coursesAujourdhui++;
      _gainsAujourdhui += _demandeClient['prix'] as double;
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
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.lmessar.app',
              ),
              MarkerLayer(
                markers: [
                  // Ma position (chauffeur)
                  Marker(
                    point: _myPosition,
                    width: 60,
                    height: 60,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isOnline ? kBlue : kGrey,
                        shape: BoxShape.circle,
                        border: Border.all(color: kWhite, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: (_isOnline ? kBlue : kGrey)
                                .withOpacity(0.4),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Icon(Icons.local_taxi,
                          color: kWhite, size: 26),
                    ),
                  ),
                  // Position client (si course acceptée)
                  if (_courseAcceptee)
                    Marker(
                      point: _demandeClient['position'] as LatLng,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.person_pin_circle,
                          color: Colors.red, size: 44),
                    ),
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
                          Icon(Icons.drive_eta,
                              color: kWhite, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Chauffeur',
                            style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Switch online/offline
                    GestureDetector(
                      onTap: _toggleOnline,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: _isOnline
                              ? Colors.green
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (_isOnline
                                  ? Colors.green
                                  : Colors.grey)
                                  .withOpacity(0.4),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isOnline
                                  ? Icons.wifi
                                  : Icons.wifi_off,
                              color: kWhite,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isOnline ? 'En ligne' : 'Hors ligne',
                              style: const TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── STATS BAR ──
          Positioned(
            top: 90,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.route,
                      label: 'Courses',
                      value: '$_coursesAujourdhui',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.payments,
                      label: 'Gains',
                      value:
                      '${_gainsAujourdhui.toStringAsFixed(0)} MRU',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.star,
                      label: 'Note',
                      value: '4.8 ⭐',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── BOTTOM PANEL ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _courseAcceptee
                ? _buildCourseEnCoursPanel()
                : _buildStatusPanel(),
          ),

          // ── POPUP DEMANDE DE COURSE ──
          if (_hasRequest)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: _buildDemandePopup(),
                ),
              ),
            ),

          // Bouton recentrer
          Positioned(
            right: 16,
            bottom: 200,
            child: FloatingActionButton.small(
              onPressed: () => _mapController.move(_myPosition, 15),
              backgroundColor: kWhite,
              child: const Icon(Icons.my_location, color: kBlue),
            ),
          ),
        ],
      ),
    );
  }

  // ── STAT CARD ──
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlue.withOpacity(0.08),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: kBlueLight, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: kBlueDark,
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: kGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ── STATUS PANEL ──
  Widget _buildStatusPanel() {
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
          const SizedBox(height: 20),

          // Status icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _isOnline ? Colors.green[50] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isOnline ? Icons.wifi : Icons.wifi_off,
              color: _isOnline ? Colors.green : kGrey,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            _isOnline
                ? 'Vous êtes en ligne 🟢'
                : 'Vous êtes hors ligne 🔴',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kBlueDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isOnline
                ? 'En attente d\'une demande de course...'
                : 'Appuyez sur "En ligne" pour recevoir des courses',
            textAlign: TextAlign.center,
            style: const TextStyle(color: kGrey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          if (_isOnline)
            const LinearProgressIndicator(
              backgroundColor: kBg,
              color: kBlueLight,
            ),

          const SizedBox(height: 20),

          // Bouton toggle
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isOnline
                      ? [Colors.red[700]!, Colors.red[400]!]
                      : [kBlueDark, kBlueLight],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (_isOnline ? Colors.red : kBlue)
                        .withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _toggleOnline,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  _isOnline ? Icons.wifi_off : Icons.wifi,
                  color: kWhite,
                ),
                label: Text(
                  _isOnline
                      ? 'Passer hors ligne'
                      : 'Passer en ligne',
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── POPUP DEMANDE ──
  Widget _buildDemandePopup() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kBlue.withOpacity(0.2),
            blurRadius: 30,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_active,
                    color: Colors.orange, size: 18),
                SizedBox(width: 6),
                Text(
                  'Nouvelle demande !',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Client
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [kBlueDark, kBlueLight]),
                  shape: BoxShape.circle,
                ),
                child:
                const Icon(Icons.person, color: kWhite, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _demandeClient['nom'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kBlueDark,
                        fontSize: 16,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star,
                            color: Colors.amber, size: 14),
                        Text(' 4.7',
                            style: TextStyle(
                                color: kGrey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [kBlueDark, kBlueLight]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(_demandeClient['prix'] as double).toStringAsFixed(0)} MRU',
                  style: const TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Trajet
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle,
                        color: Colors.green, size: 12),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _demandeClient['pickup'] as String,
                        style: const TextStyle(
                            color: kBlueDark, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: SizedBox(
                    height: 20,
                    child: VerticalDivider(color: kGrey),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_pin,
                        color: Colors.red, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _demandeClient['destination'] as String,
                        style: const TextStyle(
                            color: kBlueDark, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.route, color: kBlueLight, size: 16),
              Text(
                '  ${_demandeClient['distance']} km  •  40 MRU/km',
                style: const TextStyle(color: kGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Boutons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _refuserCourse,
                  style: OutlinedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Refuser',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [kBlueDark, kBlueLight]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: kBlue.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _accepterCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Accepter ✓',
                      style: TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── COURSE EN COURS ──
  Widget _buildCourseEnCoursPanel() {
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

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_car,
                    color: Colors.green, size: 16),
                SizedBox(width: 6),
                Text(
                  'Course en cours 🚕',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [kBlueDark, kBlueLight]),
                  shape: BoxShape.circle,
                ),
                child:
                const Icon(Icons.person, color: kWhite, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _demandeClient['nom'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kBlueDark,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _demandeClient['destination'] as String,
                      style:
                      const TextStyle(color: kGrey, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Distance',
                        style:
                        TextStyle(color: kGrey, fontSize: 12)),
                    Text(
                      '${_demandeClient['distance']} km',
                      style: const TextStyle(
                        color: kBlueDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 30, color: kGrey),
                Column(
                  children: [
                    const Text('Tarif',
                        style:
                        TextStyle(color: kGrey, fontSize: 12)),
                    Text(
                      '${(_demandeClient['prix'] as double).toStringAsFixed(0)} MRU',
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
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.green, Color(0xFF66BB6A)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _terminerCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.check_circle, color: kWhite),
                label: const Text(
                  'Terminer la course',
                  style: TextStyle(
                    color: kWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
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