// ============================================================
// PARTIE 1 — setState & Navigation
// ============================================================
// Pour utiliser cette page :
//   Dans main.dart, importez ce fichier et utilisez HomePage()
// ============================================================

import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _naviguerVersCreation() async {
    final Note? note = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateNotePage()),
    );
    if (note != null) {
      setState(() => _notes.add(note));
    }
  }

  Future<void> _naviguerVersDetail(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailNotePage(note: _notes[index]),
      ),
    );
    if (result == null) return;

    if (result is Note) {
      setState(() => _notes[index] = result);
    } else if (result == 'deleted') {
      setState(() => _notes.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune note',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour créer une note',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () => _naviguerVersDetail(index),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _naviguerVersCreation,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
