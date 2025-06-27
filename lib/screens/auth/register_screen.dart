import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/screens/auth/loggin_screen.dart';
import 'package:notes_app/screens/notes/notes_list_screen.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});
  static String path = '/reg';

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  bool passView = true;
  bool passView2 = true;
  final keys = GlobalKey<FormState>();

  @override
  void dispose() {
    login.dispose();
    pass.dispose();
    pass2.dispose();
    super.dispose();
  }

  void switchViewPass() {
    setState(() {
      passView = !passView;
    });
  }

  void switchViewPass2() {
    setState(() {
      passView2 = !passView2;
    });
  }

  Future<void> signup() async {
    final isValid = keys.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (pass.text != pass2.text) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Пароли должны совпадать'),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: login.text.trim(),
        password: pass.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        //error
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Почта уже используется'),
          backgroundColor: Colors.orange,
        ));
      }
      return;
    }
    context.go(NoteListScreen.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(LogginScreen.path),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Регистрация'),
      ),
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
                  validator: (email) => email != null && !EmailValidator.validate(email) ? 'Введите email правильно' : null,
                  decoration: const InputDecoration(
                    hintText: 'Введите email',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: TextFormField(
                  autocorrect: false,
                  controller: pass,
                  obscureText: passView,
                  validator: (password) => password != null && password.length < 6 ? 'Пароль должен быть не короче 6 символов' : null,
                  decoration: InputDecoration(
                    hintText: 'Введите пароль',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.brown,
                    ),
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
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: TextFormField(
                  autocorrect: false,
                  controller: pass2,
                  obscureText: passView2,
                  validator: (password) => password != null && password.length < 6 ? 'Пароль должен быть не короче 6 символов' : null,
                  decoration: InputDecoration(
                    hintText: 'Введите пароль ещё раз',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.brown,
                    ),
                    suffix: InkWell(
                      onTap: switchViewPass2,
                      child: Icon(
                        passView2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 30,
              ),
              ElevatedButton(onPressed: signup, child: const Text('Зарегистрироваться')),
              Container(
                height: 30,
              ),
              TextButton(onPressed: () => context.go(LogginScreen.path), child: const Text('Вход'))
            ],
          ),
        ),
      ),
    );
  }
}
