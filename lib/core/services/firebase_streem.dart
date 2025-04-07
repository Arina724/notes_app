
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/notes/notes_list_screen.dart';

class FirebaseStreem extends StatelessWidget {
  const FirebaseStreem({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Что-то пошло не так'),
            ),
          );
        } else {
          return const NoteListScreen();
        
        }
      },
    );
  }
}
