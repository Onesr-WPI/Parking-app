import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
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
      ;
      return MaterialColor(color.value, swatch);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFF7D2029)),
      ),
      home: const MyStartPage(title: 'Parking Start Page'),
    );
  }
}

class MyStartPage extends StatefulWidget {
  const MyStartPage({super.key, required this.title});

  final String title;

  @override
  State<MyStartPage> createState() => _MyStartPageState();
}

class _MyStartPageState extends State<MyStartPage> {
  @override
  Widget build(BuildContext context) {
    String registrationName = "Registration";
    String loginName = "Log In";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, textAlign: TextAlign.center),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loginName = "Logged In";
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const LogInPage();
                      }));
                    });
                  },
                  child: Text(loginName)),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      registrationName = "Registered";
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const RegistrationPage();
                      }));
                    });
                  },
                  child: Text(registrationName))
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In Page", textAlign: TextAlign.center),
      ),
      body: Center(
          child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 32.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0))),
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 32.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0))),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // send username and password to firebase, then log in the user
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const HomePage();
                        }));
                      },
                      child: const Text("Log In"))
                ],
              ))),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";
    String email = "";
    String FirstName = "";
    String LastName = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page", textAlign: TextAlign.center),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "First Name",
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 32.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                      onChanged: (value) {
                        FirstName = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Last Name",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0))),
                      onChanged: (value) {
                        LastName = value;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Email Address",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0))),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0))),
                onChanged: (value) {
                  username = value;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0))),
                onChanged: (value) {
                  password = value;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    // send username and password to firebase and log in the user
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const HomePage();
                    }));
                  },
                  child: const Text("Log In"))
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String findSpotHereName = "Find a Spot from Your Current Location";
    String findSpotThereName = "Find a Spot from a Destination";
    String addParkingName = "Add a Parking Spot Location";
    String logOutName = "Log Out";
    double boxWidth = MediaQuery.of(context).size.width * 0.9;
    double boxHeight = (MediaQuery.of(context).size.height - 56) * 0.30;
    double logoutWidth = MediaQuery.of(context).size.width * 0.3;
    double logOutHeight = MediaQuery.of(context).size.height * 0.05;
    double paddingAmount = ((MediaQuery.of(context).size.height - 56) -
            3 * (boxHeight) -
            logOutHeight) /
        8;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", textAlign: TextAlign.center),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                  child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const MyStartPage(
                                title: "Parking Start Page");
                          }));
                        },
                        child: Text(
                          findSpotHereName,
                          style: TextStyle(fontSize: boxWidth / 20),
                        ),
                      ))),
              Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                  child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const MyStartPage(
                                title: "Parking Start Page");
                          }));
                        },
                        child: Text(
                          findSpotThereName,
                          style: TextStyle(fontSize: boxWidth / 20),
                        ),
                      ))),
              Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                  child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const MyStartPage(
                                title: "Parking Start Page");
                          }));
                        },
                        child: Text(
                          addParkingName,
                          style: TextStyle(fontSize: boxWidth / 20),
                        ),
                      ))),
              Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                  child: SizedBox(
                      width: logoutWidth,
                      height: logOutHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const MyStartPage(
                                title: "Parking Start Page");
                          }));
                        },
                        child: Text(
                          logOutName,
                          style: TextStyle(fontSize: (logoutWidth) / 7),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
