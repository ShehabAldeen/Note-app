import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/authantication/register.dart';
import 'package:new_todo/authantication/reset_password.dart';
import 'package:new_todo/provider/auth_provider.dart';
import 'package:new_todo/screens/notes/note_list.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = 'login screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String id = '';

  String firstName = '';

  String lastName = '';

  String userName = '';

  String email = '';

  String password = '';

  AuthProvider provider;
  var formKey = GlobalKey<FormState>();
  TextStyle textStyle =
      TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context);
    return Container(
      decoration: customBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: customAppbar('Login', true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (text) {
                      email = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter email';
                      }
                      if (!isValidEmail(email)) {
                        return 'invalid email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onChanged: (text) {
                      password = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter password';
                      }
                      if (text.length < 6) {
                        return 'should be at least 6 character';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState.validate() == true) {
                        loginWithFirebaseAuth();
                      }
                    },
                    child: customPaddingOfElevatedButton(buttonText: 'LOG IN'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, ResetPassword.routeName);
                    },
                    child: Container(
                        width: double.infinity,
                        child: Text(
                          'Reset password',
                          style: TextStyle(color: Colors.green, fontSize: 19),
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    '-OR-',
                    style: textStyle,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registerscreen()));
                      },
                      child: Text(
                        'Create an account !',
                        style: textStyle,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginWithFirebaseAuth() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        var fireStoreUser = await getUserById(userCredential.user.uid);
        provider.addUserToProvider(fireStoreUser);
        Navigator.pushNamed(context, NoteList.routeName);
      }
    } on FirebaseAuthException catch (e) {
      showMessage(e.code, context);
    }
  }
}
