import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/authantication/register.dart';
import 'package:new_todo/authantication/reset_password.dart';
import 'package:new_todo/provider/auth_provider.dart';
import 'package:new_todo/screens/notes/note_list.dart';
import 'package:new_todo/screens/profile/profile.dart';
import 'package:new_todo/screens/profile/view_image.dart';
import 'package:new_todo/utils/utils.dart';
import 'package:provider/provider.dart';

import 'authantication/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<AuthProvider>(
      create: (buildContext) => AuthProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      routes: {
        Registerscreen.routeName: (context) => Registerscreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        NoteList.routeName: (context) => NoteList(),
        Profile.routeName: (context) => Profile(),
        ViewProfileImage.routeName: (context) => ViewProfileImage(),
        ResetPassword.routeName: (context) => ResetPassword(),
      },
      initialRoute: isUserHaveAccount(),
    );
  }
}

