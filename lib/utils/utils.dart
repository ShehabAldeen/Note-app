import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/models/user.dart' as AppUser;

import '../authantication/login_screen.dart';
import '../authantication/register.dart';

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

void showMessage(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          content: Text(message),
        );
      });
}

BoxDecoration get customBoxDecoration {
  return BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
        image: AssetImage(
          'assets/images/SIGN IN – 1.png',
        ),
        fit: BoxFit.cover,
      ));
}

AppBar customAppbar(String title, bool automaticallyLeading) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: automaticallyLeading,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
  );
}

Padding customPaddingOfElevatedButton({String buttonText}) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          buttonText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Icon(
          Icons.arrow_right,
          size: 30,
        ),
      ],
    ),
  );
}

Future<void> addUserToFireStore(AppUser.User user) {
  return AppUser.User.withConverter().doc(user.id).set(user);
}

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 12,
              ),
              Text('Loading...')
            ],
          ),
        );
      },
      barrierDismissible: false);
}

void hideLoading(BuildContext context) {
  Navigator.pop(context);
}

String isUserHaveAccount() {
  if (FirebaseAuth.instance.currentUser != null) {
    return LoginScreen.routeName;
  }
  return Registerscreen.routeName;
}

Future<AppUser.User> getUserById(String id) async {
  DocumentSnapshot<AppUser.User> result =
      await AppUser.User.withConverter().doc(id).get();
  return result.data();
}
