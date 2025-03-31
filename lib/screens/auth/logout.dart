import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/screens/auth/loggin_screen.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});
  static String path = '/logout';

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      context.go(LogginScreen.path);
    } on FirebaseAuthException catch (e) {
      print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Аккаунт'),
        actions: [
          IconButton(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            onPressed: signOut,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mail_outline,
                  color: Colors.black,
                ),
                Text('Ваша почта: '),
              ],
            ),
            Text('${user?.email}'),
            TextButton(onPressed: signOut, child: const Text('Выйти')),
          ],
        ),
      ),
    );
  }
}
