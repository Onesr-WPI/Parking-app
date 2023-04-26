import 'package:flutter/material.dart';
import 'package:parking/pages/home_page.dart';
import 'package:parking/pages/find_parking_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class EnterDestinationPage extends StatefulWidget {
  const EnterDestinationPage({super.key});

  @override
  State<EnterDestinationPage> createState() => _EnterDestinationPageState();
}

class _EnterDestinationPageState extends State<EnterDestinationPage> {
  @override
  Widget build(BuildContext context) {
    String? _currentAddress;
    Position? _currentPosition;

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

    Future<void> _getCurrentPosition() async {
      final hasPermission = await _handleLocationPermission();

      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currentPosition = position);
        _getAddressFromLatLng(_currentPosition!);
      }).catchError((e) {
        debugPrint(e);
      });
    }

    String address = "";
    String city = "";
    String state = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Destination", textAlign: TextAlign.center),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
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
                  address = value;
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
                        state = value;
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    List<Location> locations =
                        await locationFromAddress("$address, $city");
                    // send username and password to firebase and log in the user
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return FindParkingPage(
                        latitude: locations[0].latitude,
                        longitude: locations[0].longitude,
                        relation: "from your destination",
                      );
                    }));
                  },
                  child: const Text("Enter")),
              ElevatedButton(
                  onPressed: () {
                    // send username and password to firebase and log in the user
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const FindParkingPage(
                          latitude: 42.276299225733396,
                          longitude: -71.79985474457845,
                          relation: "from you");
                    }));
                  },
                  child: const Text("Use Current Location")),
              ElevatedButton(
                  onPressed: () {
                    // send username and password to firebase and log in the user
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const HomePage();
                    }));
                  },
                  child: const Text("Use Google Maps")),
            ],
          ),
        ),
      ),
    );
  }
}
