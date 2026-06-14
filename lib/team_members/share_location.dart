import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking_project/team_members/team_mem_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareLocation extends StatefulWidget{
  final String memberId;
  const ShareLocation({super.key, required this.memberId});

  @override
  State<StatefulWidget> createState() {
    return ShareLocationState();
  }
}

class ShareLocationState extends State<ShareLocation> {

  Future<void> showLogoutDialog() async {

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {

      await stopSharing();
      final prefs =
      await SharedPreferences.getInstance();

      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MemberLoginScreen(),
        ),
            (route) => false,
      );
    }
  }

  GoogleMapController? mapController;

  LatLng currentPosition =
  const LatLng(30.0881966, 78.2677254);

  bool isSharing = false;
  String memberName = "";
  String teamCode = "";

  StreamSubscription<Position>? positionStream;

  Set<Marker> markers = {};


  Future<bool> requestLocationPermission() async {

    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Turn ON GPS"),
        ),
      );
      return false;
    }
    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> startSharing() async {

    bool granted =
    await requestLocationPermission();

    if (!granted) return;

    setState(() {
      isSharing = true;
    });

    await FirebaseFirestore.instance
        .collection("members")
        .doc(widget.memberId)
        .update({
      "online": true,
    });

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 10,
          ),
        ).listen((Position position) async {

          currentPosition = LatLng(
            position.latitude,
            position.longitude,
          );

          markers.clear();

          markers.add(
            Marker(
              markerId: const MarkerId("me"),
              position: currentPosition,
              infoWindow:
              const InfoWindow(title: "My Location"),
            ),
          );

          setState(() {});

          mapController?.animateCamera(
            CameraUpdate.newLatLng(currentPosition),
          );

          await FirebaseFirestore.instance
              .collection("members")
              .doc(widget.memberId)
              .update({
            "lat": position.latitude,
            "longi": position.longitude,
            "online": true,

          });
        });
  }

  Future<void> stopSharing() async {

    await positionStream?.cancel();

    await FirebaseFirestore.instance
        .collection("members")
        .doc(widget.memberId)
        .update({
      "online": false,
    });

    setState(() {
      isSharing = false;
    });
  }

  Future<void> loadMemberData() async {

    final doc = await FirebaseFirestore.instance
        .collection("members")
        .doc(widget.memberId)
        .get();


    if(doc.exists){
      final data = doc.data()!;
      setState(() {
        memberName = data["name"] ?? "";
        teamCode = data["team_code"] ?? "";
      });

    }
  }


  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    loadMemberData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff0F9D58),
                      Color(0xff1DB954),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),

                child: Column(
                  children: [

                    const SizedBox(height: 20),

                    const Text(
                      "Share Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [

                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                memberName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                "Team Code : $teamCode",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            isSharing
                                ? "Live"
                                : "Ready",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        IconButton(
                          onPressed: () {
                            showLogoutDialog();
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),


              ////////GoogLE cARD
              Container(
                margin: const EdgeInsets.all(20),
                height: 300,

                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(25),
                ),

                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(25),
                  child: GoogleMap(
                    initialCameraPosition:
                    CameraPosition(
                      target: currentPosition,
                      zoom: 16,
                    ),
                    markers: markers,
                    myLocationEnabled: true,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                ),
              ),



              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20),

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20),

                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    )
                  ],
                ),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

                  children: [

                    Column(
                      children: [
                        const Icon(
                          Icons.gps_fixed,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 5),
                        const Text("GPS"),
                        const Text(
                          "ON",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),

                    Column(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 5),
                        const Text("Sharing"),
                        Text(
                          isSharing
                              ? "ACTIVE"
                              : "STOPPED",
                          style: TextStyle(
                            color: isSharing
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////////
              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSharing ? Colors.red : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {

                      if (isSharing) {
                        stopSharing();
                      } else {
                        startSharing();
                      }
                    },

                    icon: Icon(
                      isSharing
                          ? Icons.location_off
                          : Icons.location_searching,
                      color: Colors.white,
                    ),

                    label: Text(
                      isSharing
                          ? "Stop Sharing Location"
                          : "Start Sharing Location",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
              ///////////////////////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}
