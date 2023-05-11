import 'package:flutter/material.dart';
import 'package:parking/pages/find_parking_page.dart';
import 'package:parking/main.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _currentAddress;
  Position? _currentPosition;
  String address = "";
  String city = "";
  String state = "";

  double latitude = 0.0;
  double longitude = 0.0;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _getAddressFromLatLng(position);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return FindParkingPage(
            latitude: position.latitude,
            longitude: position.longitude,
            address: _currentAddress!,
            relation: "from you");
      }));
    }).catchError((e) {
      debugPrint(e);
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
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                  const Text(
                      'Location services are currently disabled. Please activate location services if you would like to use this feature.'),
                ],
              ),
            );
          });
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLngDouble(
      double latitude, double longitude) async {
    await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    String findSpotName = "Find a Spot";
    String addParkingName = "Add a Parking Spot Location";
    String logOutName = "Log Out";
    double headerHeight = 56;
    double paddingAmount = 5;
    double boxWidth = MediaQuery.of(context).size.width * 0.6;
    double boxHeight = (MediaQuery.of(context).size.height -
            headerHeight -
            24 -
            6 * paddingAmount) *
        0.2;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                child: Text(
                  "Where would you like to go today?",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Address",
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 32.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  onChanged: (value) {
                    address = value;
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "City",
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 32.0),
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0))),
                      onChanged: (value) {
                        city = value;
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
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
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                      onChanged: (value) {
                        state = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    List<Location> locations =
                        await locationFromAddress("$address, $city").catchError(
                      (e) {
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
                                        Navigator.of(context).pop();
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                  Text('$e'),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );

                    await _getAddressFromLatLngDouble(
                        locations[0].latitude, locations[0].longitude);
                    // send username and password to firebase and log in the user
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return FindParkingPage(
                            latitude: locations[0].latitude,
                            longitude: locations[0].longitude,
                            address: _currentAddress!,
                            relation: "from your destination",
                          );
                        },
                      ),
                    );
                  },
                  child: const Text("Enter Destination"),
                ),
                ElevatedButton(
                    onPressed: _getCurrentPosition,
                    child: const Text("Current Location")),
              ],
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context)
            //           .push(MaterialPageRoute(builder: (BuildContext context) {
            //         return const HomePage();
            //       }));
            //     },
            //     child: const Text("Use Google Maps"),),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
            //   child: SizedBox(
            //     width: boxWidth,
            //     height: boxHeight,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // Navigator.of(context).push(
            //         //   MaterialPageRoute(
            //         //     builder: (BuildContext context) {
            //         //       return const FindParkingPage(
            //         //           latitude: 42.276299225733396,
            //         //           longitude: -71.79985474457845,
            //         //           relation: "from you");
            //         //     },
            //         //   ),
            //         // );
            //       },
            //       child: Align(
            //         alignment: Alignment.center,
            //         child: Text(
            //           addParkingName,
            //           style: TextStyle(fontSize: boxWidth / 10),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, paddingAmount, 0, paddingAmount),
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
    );
  }
}
