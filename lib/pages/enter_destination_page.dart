import 'package:flutter/material.dart';
import 'package:parking/pages/home_page.dart';
import 'package:parking/pages/find_parking_page.dart';

class EnterDestinationPage extends StatelessWidget {
  const EnterDestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    String Address = "";
    String City = "";
    String State = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Destination", textAlign: TextAlign.center),
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
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Address",
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
                  Address = value;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "City",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0))),
                      onChanged: (value) {
                        City = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "State",
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0))),
                      onChanged: (value) {
                        State = value;
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    // send username and password to firebase and log in the user
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const FindParkingPage(
                          latitude: 42.276299225733396,
                          longitude: -71.79985474457845);
                    }));
                  },
                  child: const Text("Enter")),
              ElevatedButton(
                  onPressed: () {
                    // send username and password to firebase and log in the user
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const HomePage();
                    }));
                  },
                  child: const Text("Enter Using Google Maps")),
            ],
          ),
        ),
      ),
    );
  }
}
