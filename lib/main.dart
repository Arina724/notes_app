import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_app/core/services/auth_service.dart';
import 'package:notes_app/core/services/note_service.dart';
import 'package:notes_app/cubits/auth_cubit.dart/auth_cubit.dart';
import 'package:notes_app/cubits/auth_cubit.dart/auth_state.dart';
import 'package:notes_app/cubits/notes_cubit/notes_cubit.dart';

import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/auth/loggin_screen.dart';
import 'package:notes_app/screens/auth/logout.dart';
import 'package:notes_app/screens/auth/register_screen.dart';
import 'package:notes_app/screens/notes/notes_list_screen.dart';

import 'package:notes_app/screens/notes/drawing_screen.dart' as drawing_screen;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService();
  final noteService = NoteService();

  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (authState is AuthAuthenticated) {
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
      GoRoute(path: NoteListScreen.path, builder: (context, state) => const NoteListScreen()),

      GoRoute(
        path: '/drawing',
        builder: (context, state) {
          final initialDrawing = state.extra as List<ColoredStroke>? ?? [];
          return drawing_screen.DrawingScreen(initialDrawing: initialDrawing);
        },
      ),
    ],
  );

  runApp(NotesApp(
    router: router,
    authService: authService,
    noteService: noteService,
  ));
}

class NotesApp extends StatelessWidget {
  final GoRouter router;
  final AuthService authService;
  final NoteService noteService;

  const NotesApp({
    super.key,
    required this.router,
    required this.authService,
    required this.noteService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(authService)..checkAuthStatus(),
        ),
        BlocProvider<NotesCubit>(
          create: (_) => NotesCubit(noteService),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: router,
      ),
    );
  }
}
