import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});
  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  // VAR
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try{ // Login user or create account
      if(isLogin){
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }else{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      }
    }
    catch(e){ // Error while trying to login or signup
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : ${e.toString()}")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text("Authentification")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? 'Se connecter' : 'Créer un compte'),
            ),
            TextButton(
                onPressed: () => setState(() {
                  isLogin = !isLogin;
                }),
                child: Text(isLogin
                    ? 'Créer un compte'
                    : 'Déjà un compte ? Se connecter'),)
              ]
            ),
      ),
    );
  }
}