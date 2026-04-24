class Note {
  final String id;
  String titre;
  String contenu;
  String couleur;
  DateTime dateCreation;
  DateTime? dateModification;

  Note({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.couleur,
    required this.dateCreation,
    this.dateModification,
  });

  Note copyWith({
    String? titre,
    String? contenu,
    String? couleur,
    DateTime? dateModification,
  }) {
    return Note(
      id: id,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      couleur: couleur ?? this.couleur,
      dateCreation: dateCreation,
      dateModification: dateModification ?? this.dateModification,
    );
  }
}
