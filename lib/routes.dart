import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_tracking_project/admin_side/invite_team.dart';
import 'package:live_tracking_project/admin_side/login.dart';
import 'package:live_tracking_project/admin_side/register.dart';
import 'package:live_tracking_project/team_members/share_location.dart';
import 'package:live_tracking_project/team_members/team_mem_login.dart';

import 'admin_side/dashboard.dart';

class AppRoute{
  static Route<dynamic> onGenerateRoute(RouteSettings route){
    switch(route.name){
      case "/login": return MaterialPageRoute(builder: (_)=> const Login());
      case "/register": return MaterialPageRoute(builder: (_)=> const Register());
      case "/memberlogin": return MaterialPageRoute(builder: (_)=> const MemberLoginScreen());
      case "/invite_team":
        final teamCode = route.arguments as String;
        return MaterialPageRoute(
            builder: (_)=> InviteTeamScreen(teamCode: teamCode ));
      default: return MaterialPageRoute(builder: (_) => const Text("Page Not Found"));
    }
  }
}