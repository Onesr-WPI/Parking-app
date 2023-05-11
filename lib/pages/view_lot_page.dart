import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/MapUtils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ViewLotPage extends StatefulWidget {
  const ViewLotPage({
    super.key,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationAddress,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.spots,

    /*required this.address*/
  });
  final String destinationAddress;
  final double destinationLatitude;
  final double destinationLongitude;
  final double latitude;
  final double longitude;
  final int spots; //TODO add addresses to firebase and this constructor
  final String name;

  @override
  State<ViewLotPage> createState() => ViewLotPageState();
}

class ViewLotPageState extends State<ViewLotPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Response<dynamic>? _response;
  Map<String, dynamic>? _map;

  void _getDistanceMatrix() async {
    try {
      await Dio()
          .get(
              'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${widget.destinationLatitude},${widget.destinationLongitude}&origins=${widget.latitude},${widget.longitude}&mode=walking&key=AIzaSyCuN01Q_4_MWNXISWiPR_hOVnLfeMDzopE')
          .then(
        (Response<dynamic> response) {
          setState(() {
            _map = jsonDecode('$response');
            _response = response;
          });
        },
      );
    } catch (e) {
      print('$e');
    }
  }

  String? _currentAddress;
  late GoogleMapController mapController;

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
      debugPrint('$e');
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLngDouble(widget.latitude, widget.longitude);
    _getDistanceMatrix;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng _center = LatLng(widget.latitude, widget.longitude);
    final Set<Marker> _marker = {
      Marker(markerId: MarkerId(widget.name), position: _center)
    };
    double mapWidth = MediaQuery.of(context).size.width * 0.9;
    double mapHeight = MediaQuery.of(context).size.height * 0.5;
    double infoWidth = MediaQuery.of(context).size.width * 0.9;
    double infoHeight = MediaQuery.of(context).size.height * 0.3;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: mapHeight,
              width: mapWidth,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                markers: _marker,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 18.0,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  MapUtils.openMap(widget.latitude, widget.longitude);
                },
                child: Text("Open in Maps")),
            SizedBox(
              height: infoHeight,
              width: infoWidth,

              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.values[5],
                      children: [
                        Text(
                          "Destination Address: ${widget.destinationAddress}",
                          style: TextStyle(fontSize: 20),
                        ),
                        // if (_currentAddress != null)
                        Text(
                          "Parking Lot Address: $_currentAddress",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Total # Of Spots: ${widget.spots}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Time for Walking: ${_map?['rows'][0]['elements'][0]['duration']['text']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //   ),
                  // ),
                ],
              ),
              // Text("Destination Coordinates: ${widget.destinationLatitude},${widget.destinationLongitude} Destination Address: ${widget.destinationAddress} Parking Lot Coordinates: ${widget.latitude},${widget.longitude} Parking Lot Address: ${_currentAddress} Spots: ${widget.spots} "), //TODO add formatting, google maps, address
            ),
          ],
        ),
      ),
    );
  }
}
