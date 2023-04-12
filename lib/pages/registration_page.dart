import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
                  title: const Text("Registration Page"),
                ),
                body: Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "First Name",
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Last Name",
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: const InputDecoration(
                            hintText: "Email Address",
                          ),
                        ),
                        const TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Username",
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
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
                              final userCredential = FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((value) {
                                print(value);
                              });
                              // send username and password to firebase and log in the user
                            },
                            child: const Text("Register"))
                      ],
                    ),
                  ),
                ),
              );
            default:
              return const Text("Loading...");
          }
        });
  }
}
