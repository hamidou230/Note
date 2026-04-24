import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/note_service.dart';

// ============================================================
//  PARTIE 1 — setState & Navigation
//  Décommentez les lignes ci-dessous pour la Partie 1
// ============================================================
// import 'pages/home_page.dart';

// ============================================================
//  PARTIE 2 — Provider & Gestion d'État Global
//  Décommentez les lignes ci-dessous pour la Partie 2
// ============================================================
import 'pages/home_page_provider.dart';

void main() {
  runApp(const BlocNotesApp());
}

class BlocNotesApp extends StatelessWidget {
  const BlocNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    //  PARTIE 1 — Retirer le ChangeNotifierProvider
    //  et remplacer HomePageProvider() par HomePage()
    // ============================================================

    // ============================================================
    //  PARTIE 2 — Garder le ChangeNotifierProvider
    // ============================================================
    return ChangeNotifierProvider(
      create: (_) => NoteService(),
      child: MaterialApp(
        title: 'Bloc-Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePageProvider(), // Partie 2
        // home: const HomePage(),      // Partie 1 (décommenter)
      ),
    );
  }
}
