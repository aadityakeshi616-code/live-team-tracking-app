import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_tracking_project/admin_side/login.dart';
import 'package:live_tracking_project/admin_side/register.dart';
import 'package:live_tracking_project/routes.dart';
import 'package:live_tracking_project/session_checker.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
     );
  runApp(const ProjectApp());
}

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Live Tracking",
      debugShowCheckedModeBanner: false,
      home: const SessionChecker(),
      onGenerateRoute: AppRoute.onGenerateRoute,
    );
  }
}
