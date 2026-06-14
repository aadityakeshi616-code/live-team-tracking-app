import 'package:flutter/material.dart';

void showMessage(
    BuildContext context,
    String message,
    ) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(

      content: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),

      backgroundColor: Colors.green,

      behavior: SnackBarBehavior.floating,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      margin: const EdgeInsets.all(15),

      duration: const Duration(seconds: 2),
    ),
  );
}