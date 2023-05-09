import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/MapUtils.dart';

class ViewLotPage extends StatefulWidget {
  const ViewLotPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.spots,
    /*required this.address*/
  });

  final double latitude;
  final double longitude;
  final int spots; //TODO add addresses to firebase and this constructor
  final String name;
  //final String address;

  @override
  State<ViewLotPage> createState() => ViewLotPageState();
}

class ViewLotPageState extends State<ViewLotPage> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

              child: Text(
                  "Coordinates ${widget.latitude},${widget.longitude} Spots: ${widget.spots}"), //TODO add formatting, google maps, address
            ),
          ],
        ),
      ),
    );
  }
}
