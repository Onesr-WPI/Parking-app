import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking/pages/home_page.dart';
import 'package:firebase_database/firebase_database.dart';

class FindParkingPage extends StatefulWidget {
  const FindParkingPage(
      {super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  State<FindParkingPage> createState() => FindParkingState();
}

class FindParkingState extends State<FindParkingPage> {
  Future<List<Widget>> spots() async {
    List<Widget> list = [];
    await FirebaseFirestore.instance
        .collection("lots_garages")
        .get()
        .then((value) {
      for (var result in value.docs) {
        list.add(
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.15,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const HomePage();
                  }));
                },
                child: Text(result.get("Name"))),
          ),
        );
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spotList = <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.15,
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const HomePage();
              }));
            },
            child: Text("Hello")),
      ),
    ];
    spots().then((value) => {spotList = value});
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Find Parking, Test Coordinates: ${widget.latitude},${widget.longitude}",
            textAlign: TextAlign.center),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: spotList,
                ),
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   height: MediaQuery.of(context).size.height * 0.15,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.of(context).push(
              //             MaterialPageRoute(builder: (BuildContext context) {
              //           return const HomePage();
              //         }));
              //       },
              //       child: Text("Lot 1 At ___")),
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   height: MediaQuery.of(context).size.height * 0.15,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.of(context).push(
              //             MaterialPageRoute(builder: (BuildContext context) {
              //           return const HomePage();
              //         }));
              //       },
              //       child: Text("Lot 2 At ___")),
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   height: MediaQuery.of(context).size.height * 0.15,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.of(context).push(
              //             MaterialPageRoute(builder: (BuildContext context) {
              //           return const HomePage();
              //         }));
              //       },
              //       child: Text("Lot 3 At ___")),
              // ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
