import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  // Login Function
  Future<void> loginAdmin() async {

    setState(() {
      isLoading = true;
    });

    try {

      final querySnapshot = await FirebaseFirestore.instance
          .collection('team_admin')
          .where('mobile_no', isEqualTo: mobile.text.trim())
          .where('password', isEqualTo: password.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String teamCode =
        querySnapshot.docs.first['team_code'];

        final prefs =
        await SharedPreferences.getInstance();

        await prefs.setString(
          "user_type",
          "admin",
        );

        await prefs.setString(
          "team_code",
          teamCode,
        );

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
              teamCode: teamCode,
            ),
          ),
            (route)=> false,
        );
      } else {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("Invalid Mobile or Password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', height: 200,
              ),
              const Text(
                "Admin Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 40),
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
                    return "Enter Valid Mobile Number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

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

                  onPressed: () {

                    if (_formkey.currentState!.validate()) {
                      loginAdmin();
                    }
                  },

                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  const Text(
                    "Don't have an account?",
                  ),

                  TextButton(
                    onPressed: () {
                    Navigator.pushNamed(context, '/register');


                    },

                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/memberlogin');
                },
                child: Text("Login as Team Member",style: TextStyle(color: Colors.green),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// =========================
// Custom TextFormField
// =========================

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