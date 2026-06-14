import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_tracking_project/team_members/share_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberLoginScreen extends StatefulWidget {
  const MemberLoginScreen({super.key});


  @override
  State<MemberLoginScreen> createState() => _MemberLoginScreenState();
}

class _MemberLoginScreenState extends State<MemberLoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController teamCodeController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  bool isLoading = false;
  Future<void> joinTeam() async {

    setState(() {
      isLoading = true;
    });

    try {

      final teamSnapshot = await FirebaseFirestore.instance
          .collection('team_admin')
          .where(
        'team_code',
        isEqualTo: teamCodeController.text.trim(),
      )
          .limit(1)
          .get();

      if (teamSnapshot.docs.isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Team Code"),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          isLoading = false;
        });

        return;
      }

      final existingMember = await FirebaseFirestore.instance
          .collection('members')
          .where(
        'mobile_no',
        isEqualTo: mobileController.text.trim(),
      )
          .where(
        'team_code',
        isEqualTo: teamCodeController.text.trim(),
      )
          .limit(1)
          .get();

      if (existingMember.docs.isNotEmpty) {

        String memberId =
            existingMember.docs.first.id;
        final prefs =
        await SharedPreferences.getInstance();

        await prefs.setString(
          "user_type",
          "member",
        );

        await prefs.setString(
          "member_id",
          memberId,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Welcome Back"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ShareLocation(
              memberId: memberId,
            ),
          ),
            (route)=>false,
        );

        setState(() {
          isLoading = false;
        });

        return;
      }


      final docRef= await FirebaseFirestore.instance
          .collection('members')
          .add({

        "name": nameController.text.trim(),
        "team_code": teamCodeController.text.trim(),
        "mobile_no": mobileController.text.trim(),
        "lat": 0.0,
        "longi": 0.0,
        "online": false,
        "join_at": FieldValue.serverTimestamp(),

      });
      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        "user_type",
        "member",
      );

      await prefs.setString(
        "member_id",
        docRef.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Team Joined Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ShareLocation(
            memberId: docRef.id,
          ),
        ),
          (route)=>false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4FFF6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Design
            Container(
              height: 260,
              width: double.infinity,
              decoration: const BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    Color(0xff16A34A),
                    Color(0xff22C55E),
                  ],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,

                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Team Member Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Join your team and share location",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    // Name Field
                    CustomTextField(
                      controller: nameController,
                      hintText: "Enter Your Name",
                      icon: Icons.person,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Please Enter Name";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    // Team Code
                    CustomTextField(
                      controller: teamCodeController,
                      hintText: "Enter Team Code",
                      icon: Icons.group,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Please Enter Team Code";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    //Mobile No
                    CustomTextField(
                      controller: mobileController,
                      hintText: "Enter Mobile Number",
                      icon: Icons.phone,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Please Enter Mobile Number";
                        }

                        if(value.length != 10){
                          return "Enter Valid Mobile Number";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Ask your admin for the unique team code to join the organization.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Join Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {

                          if(_formKey.currentState!.validate()){
                            joinTeam();
                          }
                        },

                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Join Team",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Need help? Contact your admin",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// =======================
// CUSTOM TEXTFIELD
// =======================

class CustomTextField extends StatelessWidget {

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      controller: controller,
      validator: validator,

      style: const TextStyle(
        fontSize: 16,
      ),

      decoration: InputDecoration(

        hintText: hintText,

        prefixIcon: Icon(
          icon,
          color: Colors.green,
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}