import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {

  String generateTeamCode(){
    Random random = Random();
    int number = 1000 + random.nextInt(9000);
    return "TRK-$number";
  }

  void register()async{
    if (_formkey.currentState!.validate()) {

      bool exists =
          await checkUserByMobile(mobile.text.trim());

      if (exists) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("Mobile Number Already Exists"),
            backgroundColor: Colors.red,
          ),
        );
      } else {

        String teamCode = generateTeamCode();

        await FirebaseFirestore.instance
            .collection('team_admin')
            .add({
          "ad_name": name.text.trim(),
          "mobile_no": mobile.text.trim(),
          "password": password.text.trim(),
          "team_code": teamCode,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
              teamCode: teamCode,
            ),
          ),
        );
      }
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();

  // Check Existing User
  Future<bool> checkUserByMobile(String mobile) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('team_admin')
        .where('mobile_no', isEqualTo: mobile)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4FFF6),
      body: Container(

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png', height: 200,
                ),
                const SizedBox(height: 30),

                const Text(
                  "Register Admin",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 30),
                //// Name Field
                CustomTextFormField(
                  controller: name,
                  hintText: "Enter Name",
                  icon: Icons.person,
                  keyboardType: TextInputType.name,

                  validator: (value) {

                    if (value == null || value.isEmpty) {
                      return "Please Enter Name";
                    }

                    if (value.length < 3) {
                      return "Name must be at least 3 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Mobile Field
                CustomTextFormField(
                  controller: mobile,
                  hintText: "Enter Mobile Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Mobile Number";
                    }
                    if (value.length != 10) {
                      return "Mobile number must be 10 digits";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Password Field
                CustomTextFormField(
                  controller: password,
                  hintText: "Enter Password",
                  icon: Icons.lock,
                  obscureText: true,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Password";
                    }

                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: register,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================
// Custom TextFormField
// =======================

class CustomTextFormField extends StatelessWidget {

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,

      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(

        hintText: hintText,

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.green,
        ),

        filled: true,
        fillColor: const Color(0xffF7F7F7),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}