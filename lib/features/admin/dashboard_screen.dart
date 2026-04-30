import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/theme/app_theme.dart';
import '../../app/routes.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const kBlue = Color(0xFF1565C0);
  static const kBlueLight = Color(0xFF1E88E5);
  static const kBlueDark = Color(0xFF0D47A1);
  static const kWhite = Color(0xFFFFFFFF);
  static const kGrey = Color(0xFF90A4AE);
  static const kBg = Color(0xFFF0F4FF);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: kBlueDark,
    ));
  }

  void _confirmDelete({required String titre, required String nom, required VoidCallback onConfirm}) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(titre, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: Text('Voulez-vous vraiment supprimer $nom ?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(
          onPressed: () { Navigator.pop(context); onConfirm(); },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Supprimer', style: TextStyle(color: kWhite)),
        ),
      ],
    ));
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 60, color: kGrey.withOpacity(0.4)),
      const SizedBox(height: 16),
      Text(message, style: TextStyle(color: kGrey, fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      const Text('Les données apparaîtront ici automatiquement', style: TextStyle(color: AppTheme.kGrey, fontSize: 12)),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        _buildTopBar(),
        _buildStats(),
        _buildTabBar(),
        Expanded(child: TabBarView(controller: _tabController, children: [
          _buildClientsTab(),
          _buildChauffeursTab(),
          _buildCoursesTab(),
        ])),
      ]),
    );
  }

  Widget _buildTopBar() {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [kBlueDark, kBlue], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Row(children: [
          Container(width: 45, height: 45,
              decoration: BoxDecoration(color: kWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.admin_panel_settings, color: kWhite, size: 26)),
          const SizedBox(width: 12),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tableau de Bord', style: TextStyle(color: kWhite, fontSize: 20, fontWeight: FontWeight.w800)),
            Text('Administration Lmessar', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
          const Spacer(),
          IconButton(icon: const Icon(Icons.logout, color: kWhite),
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login)),
        ]),
      )),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [kBlueDark, kBlue], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('drivers').snapshots(),
        builder: (context, driverSnap) {
          return StreamBuilder<QuerySnapshot>(
            stream: _db.collection('users').where('role', isEqualTo: 'client').snapshots(),
            builder: (context, clientSnap) {
              int totalClients = clientSnap.data?.docs.length ?? 0;
              int totalDrivers = driverSnap.data?.docs.where((d) => (d.data() as Map)['status'] == 'approuve').length ?? 0;
              int enAttente = driverSnap.data?.docs.where((d) => (d.data() as Map)['status'] == 'en_attente').length ?? 0;
              return Row(children: [
                _statBox('Clients', '$totalClients', Icons.people, kWhite),
                _statBox('Chauffeurs', '$totalDrivers', Icons.drive_eta, kWhite),
                _statBox('En attente', '$enAttente', Icons.pending, Colors.amber),
                _statBox('Tarif', '40 MRU', Icons.payments, Colors.greenAccent),
              ]);
            },
          );
        },
      ),
    );
  }

  Widget _statBox(String label, String value, IconData icon, Color color) {
    return Expanded(child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: kWhite.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ]),
    ));
  }

  Widget _buildTabBar() {
    return Container(color: kWhite, child: TabBar(
      controller: _tabController,
      labelColor: kBlue, unselectedLabelColor: kGrey, indicatorColor: kBlue,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      tabs: const [
        Tab(icon: Icon(Icons.people, size: 18), text: 'Clients'),
        Tab(icon: Icon(Icons.drive_eta, size: 18), text: 'Chauffeurs'),
        Tab(icon: Icon(Icons.route, size: 18), text: 'Courses'),
      ],
    ));
  }

  // ── CLIENTS ──
  Widget _buildClientsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('users').where('role', isEqualTo: 'client').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('Aucun client inscrit', Icons.people_outline);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, i) {
            final doc = snapshot.data!.docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final isActive = data['isActive'] ?? true;
            final name = data['name'] ?? 'Sans nom';
            final phone = data['phone'] ?? '-';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: kBlue.withOpacity(0.07), blurRadius: 12)]),
              child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                Row(children: [
                  Container(width: 48, height: 48,
                      decoration: const BoxDecoration(gradient: LinearGradient(colors: [kBlueDark, kBlueLight]), shape: BoxShape.circle),
                      child: Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(color: kWhite, fontWeight: FontWeight.w800, fontSize: 20)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w800, color: kBlueDark, fontSize: 15)),
                    Text('📞 $phone', style: const TextStyle(color: kGrey, fontSize: 12)),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: isActive ? Colors.green[50] : Colors.red[50], borderRadius: BorderRadius.circular(10)),
                      child: Text(isActive ? 'Actif' : 'Inactif',
                          style: TextStyle(color: isActive ? Colors.green : Colors.red, fontWeight: FontWeight.w700, fontSize: 11))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () async {
                      await _db.collection('users').doc(doc.id).update({'isActive': !isActive});
                      _showSnack(isActive ? '🚫 Client désactivé' : '✅ Client activé');
                    },
                    icon: Icon(isActive ? Icons.block : Icons.check_circle, size: 16),
                    label: Text(isActive ? 'Désactiver' : 'Activer', style: const TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: isActive ? Colors.orange : Colors.green,
                        side: BorderSide(color: isActive ? Colors.orange : Colors.green),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(titre: 'Supprimer le client ?', nom: name,
                        onConfirm: () async { await _db.collection('users').doc(doc.id).delete(); _showSnack('🗑️ Client supprimé'); }),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Supprimer', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  )),
                ]),
              ])),
            );
          },
        );
      },
    );
  }

  // ── CHAUFFEURS ──
  Widget _buildChauffeursTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('drivers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('Aucun chauffeur inscrit', Icons.drive_eta);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, i) {
            final doc = snapshot.data!.docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'en_attente';
            final isActive = data['isActive'] ?? false;
            final name = data['name'] ?? 'Sans nom';
            final phone = data['phone'] ?? '-';
            final carModel = data['carModel'] ?? '-';
            final carColor = data['carColor'] ?? '-';
            final enAttente = status == 'en_attente';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(18),
                  border: enAttente ? Border.all(color: Colors.amber, width: 1.5) : null,
                  boxShadow: [BoxShadow(color: kBlue.withOpacity(0.07), blurRadius: 12)]),
              child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                if (enAttente) Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 6),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(8)),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.pending_actions, color: Colors.amber, size: 16), SizedBox(width: 6),
                      Text('En attente d\'approbation', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700, fontSize: 12)),
                    ])),
                Row(children: [
                  Container(width: 48, height: 48,
                      decoration: BoxDecoration(gradient: LinearGradient(
                          colors: status == 'approuve' ? [kBlueDark, kBlueLight] : [Colors.grey[400]!, Colors.grey[300]!]),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.drive_eta, color: kWhite, size: 24)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w800, color: kBlueDark, fontSize: 15)),
                    Text('🚗 $carModel - $carColor', style: const TextStyle(color: kGrey, fontSize: 12)),
                    Text('📞 $phone', style: const TextStyle(color: kGrey, fontSize: 12)),
                  ])),
                ]),
                const SizedBox(height: 12),
                if (enAttente)
                  Row(children: [
                    Expanded(child: ElevatedButton.icon(
                      onPressed: () async {
                        await _db.collection('drivers').doc(doc.id).update({'status': 'approuve', 'isActive': true});
                        _showSnack('✅ Chauffeur approuvé !');
                      },
                      icon: const Icon(Icons.check_circle, size: 16, color: kWhite),
                      label: const Text('Approuver', style: TextStyle(color: kWhite, fontSize: 12)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton.icon(
                      onPressed: () => _confirmDelete(titre: 'Refuser ?', nom: name,
                          onConfirm: () async { await _db.collection('drivers').doc(doc.id).delete(); _showSnack('❌ Refusé'); }),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Refuser', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    )),
                  ])
                else
                  Row(children: [
                    Expanded(child: OutlinedButton.icon(
                      onPressed: () async {
                        await _db.collection('drivers').doc(doc.id).update({'isActive': !isActive});
                        _showSnack(isActive ? '🚫 Suspendu' : '✅ Réactivé');
                      },
                      icon: Icon(isActive ? Icons.block : Icons.check_circle, size: 16),
                      label: Text(isActive ? 'Suspendre' : 'Réactiver', style: const TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: isActive ? Colors.orange : Colors.green,
                          side: BorderSide(color: isActive ? Colors.orange : Colors.green),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton.icon(
                      onPressed: () => _confirmDelete(titre: 'Supprimer ?', nom: name,
                          onConfirm: () async { await _db.collection('drivers').doc(doc.id).delete(); _showSnack('🗑️ Supprimé'); }),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Supprimer', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    )),
                  ]),
              ])),
            );
          },
        );
      },
    );
  }

  // ── COURSES ──
  Widget _buildCoursesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('rides').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('Aucune course encore', Icons.route);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, i) {
            final data = snapshot.data!.docs[i].data() as Map<String, dynamic>;
            final status = data['status'] ?? 'en_attente';
            Color statusColor = status == 'termine' ? Colors.green : status == 'en_cours' ? kBlueLight : Colors.red;
            String statusLabel = status == 'termine' ? 'Terminée' : status == 'en_cours' ? 'En cours' : 'Annulée';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: kBlue.withOpacity(0.07), blurRadius: 12)]),
              child: Column(children: [
                Row(children: [
                  Container(padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.route, color: statusColor, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Client: ${data['clientName'] ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w800, color: kBlueDark, fontSize: 14)),
                    Text('Chauffeur: ${data['driverName'] ?? '-'}', style: const TextStyle(color: kGrey, fontSize: 12)),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text(statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12))),
                ]),
                const SizedBox(height: 10),
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(10)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('${((data['distanceKm'] ?? 0.0) as num).toStringAsFixed(1)} km', style: const TextStyle(color: kBlueDark, fontWeight: FontWeight.w700)),
                      Text('${((data['price'] ?? 0.0) as num).toStringAsFixed(0)} MRU', style: const TextStyle(color: kBlueDark, fontWeight: FontWeight.w800, fontSize: 15)),
                    ])),
              ]),
            );
          },
        );
      },
    );
  }
}