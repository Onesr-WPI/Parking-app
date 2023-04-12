import 'package:flutter/material.dart';
import 'package:parking/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String findSpotHereName = "Find a Spot from Your Current Location";
    String findSpotThereName = "Find a Spot from a Destination";
    String addParkingName = "Add a Parking Spot Location";
    String logOutName = "Log Out";
    double boxWidth = MediaQuery.of(context).size.width * 0.9;
    double boxHeight = (MediaQuery.of(context).size.height - 115) * 0.30;
    double logoutWidth = MediaQuery.of(context).size.width * 0.3;
    double logOutHeight = MediaQuery.of(context).size.height * 0.05;
    double paddingAmount = ((MediaQuery.of(context).size.height - 115) -
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const MyApp();
                          },
                        ),
                      );
                    },
                    child: Text(
                      findSpotHereName,
                      style: TextStyle(fontSize: boxWidth / 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const MyApp();
                          },
                        ),
                      );
                    },
                    child: Text(
                      findSpotThereName,
                      style: TextStyle(fontSize: boxWidth / 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const MyApp();
                          },
                        ),
                      );
                    },
                    child: Text(
                      addParkingName,
                      style: TextStyle(fontSize: boxWidth / 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
                child: SizedBox(
                  width: logoutWidth,
                  height: logOutHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const MyApp();
                          },
                        ),
                      );
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
