import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocode/geocode.dart';
import 'package:pickme/global/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newGoogleMapController;
  LatLng? pickLocation;
  List<LatLng> polyCoordinate = [];

  Set<Polyline> polyLineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = "";
  String userEmail = "";

  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  bool openNavigationDrawer = true;
  bool activeDriver = false;
  late bool servicePermission = false;

  BitmapDescriptor? activeDriverIcon;
  LocationData? _currentLocation;
  String? _currentAddress;

  static const CameraPosition sourcePosition =
      CameraPosition(target: LatLng(37.4220604, -122.0852343), zoom: 13.5);

  checkLocationPermission() async {
    Location location = Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  getCurrentLocation() async {
    Location location = Location();
    location.enableBackgroundMode(enable: true);

    location.getLocation().then((location) {
      _currentLocation = location;

      LatLng latLngPosition = LatLng(location.latitude!, location.longitude!);

      newGoogleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLngPosition,
            zoom: 13.5,
          ),
        ),
      );
      userName = userModelCurrentInfo!.name!;
      userEmail = userModelCurrentInfo!.email!;
      setState(() {});
    });

    // GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) async {
      _currentLocation = newLoc;

      LatLng latlngLocation = LatLng(newLoc.latitude!, newLoc.longitude!);
      DatabaseReference ref = FirebaseDatabase.instance.ref("users");

      await ref.set({
        "lat": _currentLocation!.latitude,
        "long": _currentLocation!.longitude,
      });

      setState(() {});
    });
  }

  void submit() async {}

  Future<String> _getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "cuaks";

    GeoCode geoCode = GeoCode();
    Address address = await geoCode.reverseGeocoding(
        latitude: _currentLocation!.latitude!,
        longitude: _currentLocation!.longitude!);
    setState(() {
      _currentAddress = "${address.streetAddress}, ${address.city}";
    });
    return "${address.streetAddress}, ${address.city}, ${address.countryName}";
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: sourcePosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markerSet,
            polylines: polyLineSet,
            circles: circleSet,
            padding: EdgeInsets.only(top: 40.0, bottom: 240.0),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;

              setState(() {});

              getCurrentLocation();
            },
            onCameraMove: (CameraPosition? position) {
              if (pickLocation != position!.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              _getAddress(
                  _currentLocation!.latitude, _currentLocation!.longitude);
            },
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
                child: Icon(
                  Icons.location_on,
                ),
                onTap: () {
                  setState(() {
                    // _getAddress(
                    //     pickLocation!.latitude, pickLocation!.longitude);
                  });
                }),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.amber.shade400,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From',
                                        style: TextStyle(
                                            color: Colors.amber.shade400,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _currentAddress != null
                                            ? _currentAddress!
                                                    .substring(0, 24) +
                                                "..."
                                            : "Lokasi jemput",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      )
                                    ],
                                  )
                                ]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.amber.shade400,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Row(children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.amber.shade400,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'From',
                                          style: TextStyle(
                                              color: Colors.amber.shade400,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _currentAddress != null
                                              ? _currentAddress!
                                                      .substring(0, 24) +
                                                  "..."
                                              : "Lokasi jemput",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        )
                                      ],
                                    )
                                  ]),
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
