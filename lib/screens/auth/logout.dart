import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/screens/auth/loggin_screen.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});
  static String path = '/logout';

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      context.go(LogginScreen.path);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/notes');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return user != null ? Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBack(context),
        ),
        title: const Text('Аккаунт'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline, color: Colors.black),
                SizedBox(width: 8),
                Text('Ваша почта:'),
              ],
            ),
            const SizedBox(height: 8),
            Text(user.email ?? 'Неизвестный пользователь'),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _signOut(context),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ) 
    ) : Scaffold(
      appBar: AppBar(
        title: Text('Аккаунт'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Вы не авторизовались!'),
            Text('Пожалуйста, войдите'),
            TextButton(
              onPressed: () => context.go(LogginScreen.path),
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
