import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking/pages/view_lot_page.dart';

class FindParkingPage extends StatefulWidget {
  const FindParkingPage(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.relation});

  final double latitude;
  final double longitude;
  final String relation;

  @override
  State<FindParkingPage> createState() => FindParkingState();
}

class FindParkingState extends State<FindParkingPage> {
  double paddingAmount = 10;
  Future<List<Widget>> spots() async {
    List<Widget> list = [];
    Map<double, Widget> distMap = {};
    var snapshot =
        await FirebaseFirestore.instance.collection("lots_garages").get();
    for (var result in snapshot.docs) {
      double latitude = double.parse(result.get("Lat"));
      double longitude = double.parse(result.get("Long"));
      int spots = int.parse(result.get("Total Spots"));
      String name = result.get("Name") as String;
      double distance = acos(
              sin(widget.latitude * pi / 180) * sin(latitude * pi / 180) +
                  cos(widget.latitude * pi / 180) *
                      cos(latitude * pi / 180) *
                      cos((longitude - widget.longitude) * pi / 180)) *
          3958.8; //Conversion from lat/long to distance, according to google
      distMap.putIfAbsent(
          //enters distance and corresponding widget w/data into hashmap
          distance,
          () => Padding(
                padding:
                    EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ViewLotPage(
                              latitude: latitude,
                              longitude: longitude,
                              name: name,
                              spots: spots);
                        }));
                      },
                      child: Text(
                          "$name\n ${distance.toStringAsFixed(2)} miles ${widget.relation}")),
                ),
              ));
    }
    List<double> keys = distMap.keys.toList();
    keys.sort();
    for (double key in keys) {
      list.add(distMap[key]
          as Widget); // sorts keys and adds to list in order of sorting
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spotList = List.empty();
    spots().then((value) => {spotList = value});
    return FutureBuilder<List<Widget>>(
        future: spots(),
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Find Parking", textAlign: TextAlign.center),
              ),
              body: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: spotList,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else {
            return const CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 255, 255),
            );
          }
        });
  }
}
