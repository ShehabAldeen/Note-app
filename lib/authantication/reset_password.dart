import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/authantication/login_screen.dart';
import 'package:new_todo/utils/utils.dart';

class ResetPassword extends StatelessWidget {
  static const routeName = 'reset password';
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reset Page',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Enter Your Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                resetPasswordFirebase(context);
              },
              child: Text(
                'Reset password',
              ))
        ],
      ),
    );
  }

  Future<void> resetPasswordFirebase(BuildContext context) async {
    return await FirebaseAuth.instance
        .sendPasswordResetEmail(email: controller.text)
        .then((value) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }).onError((error, stackTrace) {
      showMessage(
        error.toString(),
        context,
      );
    });
  }
}
