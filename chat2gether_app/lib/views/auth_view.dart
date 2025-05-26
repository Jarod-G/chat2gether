import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthView extends StatefulWidget {
  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _auth = FirebaseAuth.instance;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLogin = true;

  void _submit() async {
    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: emailCtrl.text, password: passCtrl.text);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: emailCtrl.text, password: passCtrl.text);
      }
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: _submit, child: Text(isLogin ? 'Se connecter' : 'Créer un compte')),
            TextButton(
              child: Text(isLogin ? 'Créer un compte' : 'Se connecter'),
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
