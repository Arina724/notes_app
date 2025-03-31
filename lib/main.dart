import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/screens/auth/loggin_screen.dart';
import 'package:notes_app/screens/auth/logout.dart';
import 'package:notes_app/screens/auth/register_screen.dart';
import 'package:notes_app/screens/notes/drawing_screen.dart';
import 'firebase_options.dart';
import 'screens/notes/notes_list_screen.dart';
import 'models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return const NoteListScreen();
              } else {
                return const LogginScreen();
              }
            },
          );
        },
      ),
      GoRoute(path: '/loggin', builder: (context, state) => const LogginScreen()),
      GoRoute(path: '/reg', builder: (context, state) => const RegScreen()),
      GoRoute(path: '/logout', builder: (context, state) => const LogoutScreen()),
      GoRoute(path: NoteListScreen.path,
      builder: (context, state) => const NoteListScreen(),
),
      GoRoute(
        path: '/drawing',
        builder: (context, state) {
          final note = state.extra as Note?;
          if (note == null) {
            return const Scaffold(
              body: Center(child: Text('Ошибка: нет заметки')),
            );
          }
          return DrawingScreen(note: note);
        },
      ),
    ],
  );

  runApp(NotesApp(router: router));
}

class NotesApp extends StatelessWidget {
  final GoRouter router;

  const NotesApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
    );
  }
}
