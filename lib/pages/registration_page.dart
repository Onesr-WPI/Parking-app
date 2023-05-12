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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FractionallySizedBox(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                              child: Text(
                                "Register an account here:",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: "First Name",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: "Last Name",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _email,
                            decoration: const InputDecoration(
                              hintText: "Email Address",
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "Username",
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            enableSuggestions: false,
                            obscureText: true,
                            controller: _password,
                            decoration: const InputDecoration(
                              hintText: "Password",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 120),
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: ElevatedButton(
                                onPressed: () {
                                  final email = _email.text;
                                  final password = _password.text;
                                  final userCredential = FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password)
                                      .then((value) {});
                                },
                                child: const Text("Register")),
                          ),
                        )
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
