import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking/pages/view_lot_page.dart';

class FindParkingPage extends StatefulWidget {
  const FindParkingPage(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.relation});

  final String address; //info about destination or current location
  final double latitude;
  final double longitude;
  final String
      relation; //"from you" or "from your destination", depending on how you reach the page

  @override
  State<FindParkingPage> createState() => FindParkingState();
}

class FindParkingState extends State<FindParkingPage> {
  double paddingAmount = 10;
  Future<List<Widget>> spots() async {
    //function to pull from firebase
    List<Widget> list = []; //final return
    Map<double, Widget> distMap = {}; //entries to be added for sorting
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
                      //unique button created for each database document
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ViewLotPage(
                            destinationLatitude: widget.latitude,
                            destinationLongitude: widget.longitude,
                            destinationAddress: widget.address,
                            latitude: latitude,
                            longitude: longitude,
                            name: name,
                            spots: spots,
                          );
                        }));
                      },
                      child: Text(
                          "$name\n ${distance.toStringAsFixed(2)} miles ${widget.relation}")),
                ),
              ));
    }
    List<double> keys = distMap.keys.toList();
    keys.sort(); //creates a sorted keylist
    for (double key in keys) {
      list.add(
          distMap[key] as Widget); // Adds values to list in order of sorting
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spotList = List.empty();
    spots().then((value) => {spotList = value}); //run pull function
    return FutureBuilder<List<Widget>>(
      future: spots(),
      builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.hasData) {
          //if data, show list
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
                          children:
                              spotList, //display spot widgets in scrollable view
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator(
            color: Color.fromARGB(
                255, 255, 255, 255), //if no data, show loading wheel
          );
        }
      },
    );
  }
}
