import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_todo/authantication/register.dart';
import 'package:new_todo/models/user.dart' as AppUser;
import 'package:new_todo/provider/auth_provider.dart';
import 'package:new_todo/screens/notes/note_list.dart';
import 'package:new_todo/screens/profile/profile_utils.dart';
import 'package:new_todo/screens/widgets/profile/image_profile.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
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
          title: const Text('Profile'),
          leading: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => NoteList()));
              },
              child: const Icon(Icons.arrow_back_ios)),
          actions: [
            GestureDetector(
              onTap: () async {
                ProfileUtils().logOutMessage(context,
                    title: 'Please Confirm',
                    content: 'Are you sure you want to log out', onPressed: () {
                  // deleteUserFromFireAuth();
                  // deleteUser(provider.user);
                  currentAccountLogOut();
                  prefs.setString('email', '');
                  prefs.setString('displayName', '');
                  prefs.setString('photoUrl', '');
                  prefs.setString('imagePath', '');
                });
              },
              child: const Padding(
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
              ImageProfile(),
              SizedBox(height: size.height * 0.04),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 28,
                ),
                title: Text(
                  'Name',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                ),
                subtitle: Text(
                  prefs.getString('displayName'),
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.email,
                  size: 28,
                ),
                title: Text(
                  'Email',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                ),
                subtitle: Text(
                  prefs.getString('email'),
                  style: const TextStyle(color: Colors.black, fontSize: 17),
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
    } on FirebaseAuthException catch (e) {
      showMessage(e.code, context);
    }
  }

  void deleteUser(AppUser.User user) async {
    CollectionReference collectionReference = AppUser.User.withConverter();
    DocumentReference itemDec = collectionReference.doc(user.id);
    await itemDec.delete();
  }

  void deleteUserFromFireAuth() async {
    try {
      await FirebaseAuth.instance.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showMessage(
            'The user must reauthenticate before this operation can be executed.',
            context);
      }
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
