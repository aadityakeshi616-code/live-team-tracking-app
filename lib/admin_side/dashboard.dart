import 'package:flutter/material.dart';
import 'package:live_tracking_project/admin_side/team_track.dart';
import 'invite_team.dart';

class Dashboard extends StatefulWidget {

  final String teamCode;

  const Dashboard({
    super.key,
    required this.teamCode,
  });

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    List pages = [

      TeamTrackerScreen(
        teamCode: widget.teamCode,
      ),

      InviteTeamScreen(
        teamCode: widget.teamCode,
      ),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(

        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,

          selectedItemColor: Colors.green,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: "Tracker",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.group_add),
              label: "Invite",
            ),
          ],
        ),
      ),
    );
  }
}