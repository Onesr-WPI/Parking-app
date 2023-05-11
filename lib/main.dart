import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking/pages/test_page.dart';
import 'package:parking/pages/home_page.dart';
import 'package:parking/pages/registration_page.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor createMaterialColor(Color color) {
      List strengths = <double>[.05];
      Map<int, Color> swatch = {};
      final int r = color.red, g = color.green, b = color.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      for (var strength in strengths) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      }
      return MaterialColor(color.value, swatch);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF7D2029)),
      ),
      home: const MyHomePage(title: 'Parking Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    String registrationName = "Register Instead";
    String loginName = "Log In";

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Please log in to use the app."),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: const InputDecoration(
                          hintText: "Email Address",
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _password,
                        decoration: const InputDecoration(
                          hintText: "Password",
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const RegistrationPage();
                            }));
                          },
                          child: Text(registrationName),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return const HomePage();
                                  },
                                ),
                              );
                            },
                            child: const Text("Continue As Guest")),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const TestPage();
                            }));
                          },
                          child: Text("test"),
                        ),
                      ],
                    )
                  ],
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
