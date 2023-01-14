import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  Set<Marker> _makers = {};
  LatLng _center = const LatLng(20.5937, 78.9629);
  final double zoomLevel = 18;
  String drive = "sedan";
  Uint8List? markIcons;

  @override
  void initState() {
    super.initState();
    Permission.location.request();
  }

  void getCurrentLocation() async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    CameraPosition _home = CameraPosition(
        target:
            LatLng(location.latitude as double, location.longitude as double),
        zoom: zoomLevel);

    mapController.animateCamera(CameraUpdate.newCameraPosition(_home));

    setTheMarkers(location);
  }

  void setTheMarkers(LocationData location) async {
    Set<Marker> values = {};
    double diff = 0.001000;
    markIcons = await getImages('assets/images/${drive}.png', 300);

    for (int i = 0; i < 2; i++) {
      Marker tmpMarker = Marker(
        markerId: MarkerId("Car ${i + 1}"),
        position: LatLng((location.latitude! + diff) as double,
            (location.longitude! + diff) as double),
        infoWindow: InfoWindow(title: "Car ${i + 1}", snippet: "Book the car"),
        icon: BitmapDescriptor.fromBytes(markIcons!),
      );

      values.add(tmpMarker);
      debugPrint(
          "${location.latitude! + diff} , ${location.longitude! + diff}");
      diff -= 0.000500;
    }
    setState(() {
      _makers = values;
    });
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: zoomLevel,
              ),
              markers: _makers, //MARKERS IN MAP
            ),
            Positioned(
              top: 10,
              right: 15,
              left: 15,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            hintText: "PICKUP LOCATION"),
                    ),
                  ],
                ),
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.35,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            child: Row(
                              children: [
                                Flexible(
                                  child: RadioListTile(
                                      value: "micro",
                                      title: Text("Micro",
                                      style: TextStyle(fontSize: 10),),
                                      groupValue: drive,
                                      onChanged: (val) {
                                        setState(() {
                                          drive = val as String;
                                        });
                                      }),
                                ),
                                Flexible(
                                  child: RadioListTile(
                                      value: "mini",
                                      title: Text("Mini",
                                      style: TextStyle(fontSize: 10),),
                                      groupValue: drive,
                                      onChanged: (val) {
                                        setState(() {
                                          drive = val as String;
                                        });
                                      }),
                                ),
                                Flexible(
                                  child: RadioListTile(
                                      value: "sedan",
                                      title: Text("Sedan",
                                      style: TextStyle(fontSize: 10),),
                                      groupValue: drive,
                                      onChanged: (val) {
                                        setState(() {
                                          drive = val as String;
                                        });
                                      }),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      color: Colors.grey[300],
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            splashColor: Colors.grey,
                                            icon: Icon(Icons.search),
                                            onPressed: () {},
                                          ),
                                          Expanded(
                                            child: TextField(
                                              cursorColor: Colors.black,
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.go,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 15),
                                                  hintText: "Search Your Destination"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        splashColor: Colors.grey,
                                        icon: Icon(Icons.home,color: Colors.deepPurple,),
                                        onPressed: () {},
                                      ),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: (){

                                          },
                                          child: Text("ADD YOUR HOME ADDRESS",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.black),),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        splashColor: Colors.grey,
                                        icon: Icon(Icons.warehouse_rounded,color: Colors.deepPurple,),
                                        onPressed: () {},
                                      ),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: (){

                                          },
                                          child: Text("ADD YOUR WORK/OFFICE ADDRESS",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.black),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5,)
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
