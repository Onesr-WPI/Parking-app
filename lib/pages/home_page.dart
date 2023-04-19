import 'package:flutter/material.dart';
import 'package:parking/pages/find_parking_page.dart';
import 'package:parking/pages/enter_destination_page.dart';
import 'package:parking/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String findSpotName = "Find a Spot";
    String addParkingName = "Add a Parking Spot Location";
    String logOutName = "Log Out";
    double headerHeight = 56;
    double paddingAmount = 5;
    double boxWidth = MediaQuery.of(context).size.width * 0.9;
    double boxHeight = (MediaQuery.of(context).size.height -
            headerHeight -
            24 -
            6 * paddingAmount) *
        0.3;
    double logoutWidth = MediaQuery.of(context).size.width * 0.3;
    double logOutHeight = (MediaQuery.of(context).size.height -
            headerHeight -
            24 -
            6 * paddingAmount) *
        0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", textAlign: TextAlign.center),
        toolbarHeight: headerHeight,
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
                            return const EnterDestinationPage();
                          }));
                        },
                        child: Text(
                          findSpotName,
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
                            return const FindParkingPage(
                                latitude: 42.276299225733396,
                                longitude: -71.79985474457845,
                                relation: "from you");
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const MyApp();
                      }));
                    },
                    child: Text(
                      logOutName,
                      style: TextStyle(fontSize: (logoutWidth) / 7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
