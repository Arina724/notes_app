import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/screens/auth/register_screen.dart';
import 'package:notes_app/screens/notes/notes_list_screen.dart';

class LogginScreen extends StatefulWidget {
  const LogginScreen({super.key});
  static const path = '/loggin';

  @override
  State<LogginScreen> createState() => _LogginScreenState();
}

class _LogginScreenState extends State<LogginScreen> {
  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool passView = true;
  final keys = GlobalKey<FormState>();

  @override
  void dispose() {
    login.dispose();
    pass.dispose();
    super.dispose();
  }

  void switchViewPass() {
    setState(() {
      passView = !passView;
    });
  }

  Future<void> signin() async {
    final isValid = keys.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: login.text.trim(),
        password: pass.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Неверные почта или пароль'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }
    if (mounted) context.go(NoteListScreen.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: keys,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: login,
                  validator:
                      (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Введите email правильно'
                              : null,
                  decoration: const InputDecoration(hintText: 'Введите email'),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: TextFormField(
                  autocorrect: false,
                  controller: pass,
                  obscureText: passView,
                  validator:
                      (password) =>
                          password != null && password.length < 6
                              ? 'Пароль должен быть не короче 6 символов'
                              : null,
                  decoration: InputDecoration(
                    hintText: 'Введите пароль',
                    suffix: InkWell(
                      onTap: switchViewPass,
                      child: Icon(
                        passView ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 30),
              ElevatedButton(onPressed: signin, child: const Text('Войти')),
              Container(height: 30),
              TextButton(
                onPressed: () => context.go(RegScreen.path),
                child: const Text('Регистрация'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
