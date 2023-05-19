import "package:flutter/material.dart";
import "package:parking/main.dart";
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
    // needed for firebase
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // needed for firebase
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          // initialize firebase with page so that it loads with the page
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Registration Page"),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
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
                                      FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              // creates a user in firebase using username and password credentials
                                              email: email,
                                              password: password)
                                          .then(
                                        (value) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return const MyApp(); // navigates back to main page
                                              },
                                            ),
                                          );
                                        },
                                      ).catchError((e) {
                                        // pop up in case of error with registration
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Stack(
                                                children: <Widget>[
                                                  Positioned(
                                                    right: -40.0,
                                                    top: -40.0,
                                                    child: InkResponse(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        child:
                                                            Icon(Icons.close),
                                                      ),
                                                    ),
                                                  ),
                                                  Text('$e'),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                    },
                                    child: const Text("Register")),
                              ),
                            ),
                          ],
                        ),
                      ),
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
