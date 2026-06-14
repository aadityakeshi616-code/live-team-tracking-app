import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_side/login.dart';
import 'admin_side/dashboard.dart';
import 'team_members/share_location.dart';
import 'team_members/team_mem_login.dart';

class SessionChecker extends StatefulWidget {
  const SessionChecker({super.key});

  @override
  State<SessionChecker> createState() =>
      _SessionCheckerState();
}

class _SessionCheckerState
    extends State<SessionChecker> {

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {

    final prefs =
    await SharedPreferences.getInstance();

    String? userType =
    prefs.getString("user_type");

    if (userType == "admin") {

      String? teamCode =
      prefs.getString("team_code");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(
            teamCode: teamCode!,
          ),
        ),
      );

    } else if (userType == "member") {

      String? memberId =
      prefs.getString("member_id");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ShareLocation(
            memberId: memberId!,
          ),
        ),
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}