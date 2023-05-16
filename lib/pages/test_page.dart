import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Response<dynamic>? _response;
  Map<String, dynamic>? _map;

  void _getDistanceMatrix() async {
    try {
      await Dio()
          .get(
              'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=40.659569,-73.933783&origins=40.6655101,-73.89188969999998&mode=walking&key=AIzaSyCuN01Q_4_MWNXISWiPR_hOVnLfeMDzopE')
          .then(
        (Response<dynamic> response) {
          setState(() {
            _map = jsonDecode('$response');
            _response = response;
          });
        },
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body:
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         mainAxisSize: MainAxisSize.min,
          //         children: [Text('Monthly Membership'), Text('Subscription')],
          //       ),
          //     ),
          //     IntrinsicWidth(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text(
          //             '+100',
          //             maxLines: 1,
          //             softWrap: false,
          //             overflow: TextOverflow.fade,
          //           ),
          //           Text(
          //             '18 Sept 2021',
          //             maxLines: 1,
          //             softWrap: false,
          //             overflow: TextOverflow.fade,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

          SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              Text('google maps: $_response'),
              Text(
                  'google maps 2: ${_map?['rows'][0]['elements'][0]['duration']['text']}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getDistanceMatrix,
                child: const Text("Get Current Location"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
