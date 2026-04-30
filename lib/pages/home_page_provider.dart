// ============================================================
// PARTIE 2 — inchangé
// PARTIE 3 — Étapes 22 & 23 :
//   - icône statut connexion dans AppBar
//   - si connecté : ouvre ApiNotesPage
//   - si non connecté : affiche un message
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../services/connectivity_service.dart';
import 'create_page.dart';
import 'detail_page.dart';
import 'api_notes_page.dart';

class HomePageProvider extends StatelessWidget {
  const HomePageProvider({super.key});

  Future<void> _naviguerVersCreation(BuildContext context) async {
    final Note? note = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateNotePage()),
    );
    if (note != null) {
      context.read<NoteService>().addNote(note);
    }
  }

  Future<void> _naviguerVersDetail(BuildContext context, Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailNotePage(note: note)),
    );
    if (result is Note) {
      context.read<NoteService>().updateNote(result);
    } else if (result == 'deleted') {
      context.read<NoteService>().deleteNote(note.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _HomePageBody(
      onCreer: () => _naviguerVersCreation(context),
      onDetail: (note) => _naviguerVersDetail(context, note),
    );
  }
}

class _HomePageBody extends StatefulWidget {
  final VoidCallback onCreer;
  final Function(Note) onDetail;

  const _HomePageBody({required this.onCreer, required this.onDetail});

  @override
  State<_HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<_HomePageBody> {
  String _query = '';

  // ── PARTIE 3 : état de la connexion ──────────────────────
  bool _isConnected = false;
  late StreamSubscription<bool> _connectivitySub;

  @override
  void initState() {
    super.initState();
    final connSvc = ConnectivityService();

    // Vérification initiale au démarrage
    connSvc.isConnected().then((v) {
      if (mounted) setState(() => _isConnected = v);
    });

    // Écoute les changements en temps réel
    _connectivitySub = connSvc.onConnectivityChanged.listen((online) {
      if (mounted) setState(() => _isConnected = online);
    });
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    super.dispose();
  }

  // ── Étape 23 : comportement du bouton cloud ───────────────
  void _onCloudPressed() {
    if (_isConnected) {
      // Connecté → ouvre la page API
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ApiNotesPage()),
      );
    } else {
      // Non connecté → affiche un message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.orange),
              SizedBox(width: 8),
              Text('Hors ligne'),
            ],
          ),
          content: const Text(
            'Vous êtes hors ligne.\n'
            'La synchronisation API n\'est pas disponible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<NoteService>();
    final notes = _query.isEmpty ? service.notes : service.search(_query);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Mes Notes'),
        actions: [
          // ── Étape 22 : icône statut connexion ─────────────
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Tooltip(
              message: _isConnected ? 'En ligne' : 'Hors ligne',
              child: Icon(
                _isConnected ? Icons.wifi : Icons.wifi_off,
                color: _isConnected ? Colors.greenAccent : Colors.orange,
                size: 22,
              ),
            ),
          ),
          // ── Étape 23 : bouton cloud avec logique connecté/hors ligne
          IconButton(
            icon: const Icon(Icons.cloud),
            tooltip: 'Notes API',
            onPressed: _onCloudPressed,
          ),
          // Compteur
          Consumer<NoteService>(
            builder: (_, svc, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Chip(
                label: Text(
                  '${svc.count}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.blue[800],
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          // Menu tri
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Trier',
            onSelected: (option) {
              context.read<NoteService>().setSortOption(option);
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: SortOption.dateRecent,
                checked: service.sortOption == SortOption.dateRecent,
                child: const Text('Date (récent d\'abord)'),
              ),
              CheckedPopupMenuItem(
                value: SortOption.dateAncien,
                checked: service.sortOption == SortOption.dateAncien,
                child: const Text('Date (ancien d\'abord)'),
              ),
              CheckedPopupMenuItem(
                value: SortOption.titreAZ,
                checked: service.sortOption == SortOption.titreAZ,
                child: const Text('Titre (A → Z)'),
              ),
              CheckedPopupMenuItem(
                value: SortOption.titreZA,
                checked: service.sortOption == SortOption.titreZA,
                child: const Text('Titre (Z → A)'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Rechercher une note...',
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blue[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
            ),
          ),
        ),
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.note_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _query.isEmpty ? 'Aucune note' : 'Aucun résultat',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _query.isEmpty
                        ? 'Appuyez sur + pour créer une note'
                        : 'Essayez un autre mot-clé',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () => widget.onDetail(note),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(
                            color: _hexToColor(note.couleur),
                            width: 5,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.titre,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note.contenu.length > 30
                                ? '${note.contenu.substring(0, 30)}...'
                                : note.contenu,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(note.dateCreation),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onCreer,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
