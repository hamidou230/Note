import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailNotePage extends StatefulWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _formatDateComplete(DateTime date) {
    const mois = [
      '',
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${mois[date.month]} ${date.year} à $h:$m';
  }

  Future<void> _modifierNote() async {
    final Note? noteModifiee = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateNotePage(note: _note)),
    );
    if (noteModifiee != null) {
      setState(() => _note = noteModifiee);
      if (mounted) Navigator.pop(context, _note);
    }
  }

  void _supprimerNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la note'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette note ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, 'deleted');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final couleurNote = _hexToColor(_note.couleur);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Note'),
        backgroundColor: couleurNote,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _modifierNote,
            tooltip: 'Modifier',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _supprimerNote,
            tooltip: 'Supprimer',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: couleurNote.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _note.titre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Créée le ${_formatDateComplete(_note.dateCreation)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            if (_note.dateModification != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.edit_calendar,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Modifiée le ${_formatDateComplete(_note.dateModification!)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Text(
              _note.contenu.isEmpty ? '(Aucun contenu)' : _note.contenu,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
