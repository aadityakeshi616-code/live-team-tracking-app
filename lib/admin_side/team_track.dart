import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking_project/admin_side/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamTrackerScreen extends StatefulWidget {
  final String teamCode;

  const TeamTrackerScreen({
    super.key,
    required this.teamCode,
  });

  @override
  State<TeamTrackerScreen> createState() =>
      _TeamTrackerScreenState();
}

class _TeamTrackerScreenState
    extends State<TeamTrackerScreen> {

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

      final prefs =
      await SharedPreferences.getInstance();

      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const Login(),
        ),
            (route) => false,
      );
    }
  }

  GoogleMapController? mapController;

  Set<Marker> markers = {};

  int totalMembers = 0;
  int onlineMembers = 0;
  int offlineMembers = 0;

  void loadMembers() {

    FirebaseFirestore.instance
        .collection("members")
        .where(
      "team_code",
      isEqualTo: widget.teamCode,
    )
        .snapshots()
        .listen((snapshot) {
      markers.clear();
      totalMembers = snapshot.docs.length;
      onlineMembers = 0;
      offlineMembers = 0;

      for (var doc in snapshot.docs) {

        final data = doc.data();
        bool online =
            data["online"] ?? false;

        if (online) {
          onlineMembers++;
        } else {
          offlineMembers++;
        }
        double lat =
            (data["lat"] as num?)?.toDouble() ?? 0.0;

        double longi =
            (data["longi"] as num?)?.toDouble() ?? 0.0;

        if (lat != 0.0 && longi != 0.0) {

          markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(lat, longi),

              icon: BitmapDescriptor.defaultMarkerWithHue(
                online
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueRed,
              ),

              infoWindow: InfoWindow(
                title: data["name"],
                snippet: online ? "Online" : "Offline",
              ),
            ),
          );
        }
      }


      if (snapshot.docs.isNotEmpty) {

        final first = snapshot.docs.first.data();

        double lat =
            (first["lat"] as num?)?.toDouble() ?? 0.0;

        double longi =
            (first["longi"] as num?)?.toDouble() ?? 0.0;

        if (lat != 0.0 && longi != 0.0) {

          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(lat, longi),
              14,
            ),
          );
        }
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    loadMembers();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff0F9D58),
                      Color(0xff16A34A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [

                    const SizedBox(height: 10),

                    Row(
                      children: [

                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 35,
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Team Tracker",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              Text(
                                "Live Location Tracking",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                            BorderRadius.circular(18),
                          ),

                          child: Column(
                            children: [

                              const Text(
                                "Team Code",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),

                              Text(
                                widget.teamCode,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// STATS
              Container(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

                  children: [

                    _statItem(
                      Icons.groups,
                      totalMembers.toString(),
                      "Members",
                      Colors.green,
                    ),

                    _divider(),

                    _statItem(
                      Icons.check_circle,
                      onlineMembers.toString(),
                      "Online",
                      Colors.green,
                    ),

                    _divider(),

                    _statItem(
                      Icons.cancel,
                      offlineMembers.toString(),
                      "Offline",
                      Colors.red,
                    ),

                    _divider(),

                    _statItem(
                      Icons.access_time,
                      "Now",
                      "Updated",
                      Colors.blue,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// MAP CARD
              Container(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                height: 350,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(25),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: GoogleMap(
                    initialCameraPosition:
                    const CameraPosition(
                      target: LatLng(
                        28.6139,
                        77.2090,
                      ),
                      zoom: 12,
                    ),
                  
                    markers: markers,
                  
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                )
              ),

              const SizedBox(height: 20),

              //////LIST CARDS///////////////
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Team Members",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("members")
                          .where(
                        "team_code",
                        isEqualTo: widget.teamCode,
                      )
                          .snapshots(),

                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),

                          itemCount: snapshot.data!.docs.length,

                          itemBuilder: (context, index) {

                            final data =
                            snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                            bool online =
                                data["online"] ?? false;

                            double lat =
                                (data["lat"] as num?)?.toDouble() ?? 0.0;

                            double longi =
                                (data["longi"] as num?)?.toDouble() ?? 0.0;

                            return Card(
                              elevation: 0,

                              child: ListTile(

                                leading: CircleAvatar(
                                  backgroundColor: online
                                      ? Colors.green
                                      : Colors.red,

                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),

                                title: Text(
                                  data["name"] ?? "",
                                ),

                                subtitle: Text(
                                  online
                                      ? "Online"
                                      : "Offline",
                                ),

                                trailing: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),

                                onTap: () {

                                  if (lat != 0.0 &&
                                      longi != 0.0) {

                                    mapController?.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(lat, longi),
                                        18,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 45,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _statItem(
      IconData icon,
      String value,
      String title,
      Color color,
      ) {
    return Column(
      children: [

        Icon(
          icon,
          color: color,
          size: 28,
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}