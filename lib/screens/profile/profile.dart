import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_todo/authantication/register.dart';
import 'package:new_todo/provider/auth_provider.dart';
import 'package:new_todo/screens/notes/note_list.dart';
import 'package:new_todo/screens/profile/profile_utils.dart';
import 'package:new_todo/screens/profile/view_image.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class Profile extends StatefulWidget {
  static const routeName = 'profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthProvider provider;
  Size size;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          leading: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => NoteList()));
              },
              child: Icon(Icons.arrow_back_ios)),
          actions: [
            GestureDetector(
              onTap: () async {
                ProfileUtils.logOutMessage(context,
                    title: 'Please Confirm',
                    content: 'Are you sure you want to log out', onPressed: () {
                  currentAccountLogOut();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),
              Stack(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ViewProfileImage.routeName);
                      },
                      child: ProfileUtils.getProfile(context,
                          width: size.width * .48,
                          height: size.height * .24,
                          iconSize: 50,
                          paddingSize: 18)),
                  Positioned(
                      top: size.height * .17,
                      left: size.width * .33,
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          ProfileUtils.bottomSheet(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(70)),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 28,
                              color: Colors.white,
                            )),
                      )),
                ],
              ),
              SizedBox(height: size.height * 0.04),
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: 28,
                ),
                title: Text(
                  'Name',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                ),
                subtitle: Text(
                  ProfileUtils.getDisplayNameOfCurrentAccount(context),
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.email,
                  size: 28,
                ),
                title: Text(
                  'Email',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                ),
                subtitle: Text(
                  ProfileUtils.getEmailOfCurrentAccount(context),
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ],
          ),
        ));
  }

  signOutFirebase(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      navigatorThenMessage();
      provider.user = null;
    } on FirebaseAuthException catch (e) {
      showMessage(e.message, context);
      throw e;
    }
  }

  currentAccountLogOut() async {
    if (provider.user != null) {
      await signOutFirebase(context);
    } else {
      logOutFromGoogleAccount();
    }
  }

  logOutFromGoogleAccount() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      navigatorThenMessage();
      provider.email = null;
    } on FirebaseAuthException catch (e) {
      showMessage(e.code, context);
    }
  }

  void navigatorThenMessage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Registerscreen.routeName,
      (route) => false,
    );
    showMessage('You logged out from your account', context);
  }
}
