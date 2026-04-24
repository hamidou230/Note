import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Note? note;

  const CreateNotePage({super.key, this.note});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late TextEditingController _titreController;
  late TextEditingController _contenuController;
  String _couleurSelectionnee = '#FFE082';

  final List<String> _couleurs = [
    '#FFE082',
    '#EF9A9A',
    '#A5D6A7',
    '#90CAF9',
    '#CE93D8',
    '#FFCC80',
  ];

  bool get _estModeModification => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(
      text: _estModeModification ? widget.note!.titre : '',
    );
    _contenuController = TextEditingController(
      text: _estModeModification ? widget.note!.contenu : '',
    );
    if (_estModeModification) {
      _couleurSelectionnee = widget.note!.couleur;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  void _sauvegarder() {
    if (_titreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le titre ne peut pas être vide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Note note;
    if (_estModeModification) {
      note = widget.note!.copyWith(
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateModification: DateTime.now(),
      );
    } else {
      note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateCreation: DateTime.now(),
      );
    }

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_estModeModification ? 'Modifier la note' : 'Nouvelle Note'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _sauvegarder,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titreController,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Titre de la note',
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contenuController,
              minLines: 4,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Contenu',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Couleur :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: _couleurs.map((couleur) {
                final bool selectionne = couleur == _couleurSelectionnee;
                return GestureDetector(
                  onTap: () => setState(() => _couleurSelectionnee = couleur),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _hexToColor(couleur),
                      shape: BoxShape.circle,
                      border: selectionne
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: selectionne
                        ? const Icon(Icons.check, size: 20, color: Colors.black)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sauvegarder,
                icon: const Icon(Icons.save),
                label: Text(_estModeModification ? 'Modifier' : 'Sauvegarder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
