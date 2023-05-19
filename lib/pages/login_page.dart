// This page is not used --> integrated into main.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking/pages/home_page.dart';
import '../firebase_options.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(
                title: const Text("Login Page"),
              ),
              body: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: const InputDecoration(
                          hintText: "Email Address",
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        obscureText: true,
                        controller: _password,
                        decoration: const InputDecoration(
                          hintText: "Password",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final email = _email.text;
                          final password = _password.text;
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password)
                              .then((value) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const HomePage();
                            }));
                          });
                        },
                        child: const Text("Log In"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          default:
            return const Text("Loading...");
        }
      },
    );
  }
}
