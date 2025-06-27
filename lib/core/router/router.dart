import 'package:notes_app/screens/notes/notes_list_screen.dart';
import 'package:notes_app/screens/auth/loggin_screen.dart';
import 'package:notes_app/screens/auth/logout.dart';
import 'package:notes_app/screens/auth/register_screen.dart';
import 'package:go_router/go_router.dart';

class Routers1 {
  static final GoRouter router = GoRouter(initialLocation: NoteListScreen.path, routes: [
    GoRoute(
      path: NoteListScreen.path,
      builder: (context, state) => const NoteListScreen(),
    ),
    GoRoute(
      path: LogginScreen.path,
      builder: (context, state) => const LogginScreen(),
    ),
    GoRoute(
      path: LogoutScreen.path,
      builder: (context, state) => const LogoutScreen(),
    ),
    GoRoute(
      path: RegScreen.path,
      builder: (context, state) => const RegScreen(),
    ),
  ]);
}
