import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_todo/models/user.dart' as AppUser;
import 'package:new_todo/provider/auth_provider.dart';
import 'package:new_todo/screens/notes/note_list.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class Registerscreen extends StatefulWidget {
  static final routeName = 'register screen';

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  String firstName = ' ';

  String lastName = ' ';

  String userName = ' ';

  String email = ' ';

  String password = ' ';

  var formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context);

    return Container(
      decoration: customBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: customAppbar('Create an account', false),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                    onChanged: (text) {
                      if (firstName == null) {
                        firstName = ' ';
                      } else {
                        firstName = text;
                      }
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                    onChanged: (text) {
                      if (lastName == null) {
                        lastName = ' ';
                      } else {
                        lastName = text;
                      }
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'User Name',
                    ),
                    onChanged: (text) {
                      if (userName == null) {
                        userName = ' ';
                      } else {
                        userName = text;
                      }
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (text) {
                      if (email == null) {
                        email = ' ';
                      } else {
                        email = text;
                      }
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter email';
                      }
                      if (!isValidEmail(email)) {
                        return 'characters@characters.com';
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
                      if (password == null) {
                        password = ' ';
                      } else {
                        password = text;
                      }
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
                        signUpFirebaseAuth();
                      }
                    },
                    child: customPaddingOfElevatedButton(
                        buttonText: 'CREATE ACCOUNT'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  customSignInButton("Sign up with Google", Buttons.Google),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpFirebaseAuth() async {
    try {
      showLoading(context);
      var credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      hideLoading(context);
      if (credential.user != null) {
        AppUser.User myUser = AppUser.User(
            id: credential.user.uid,
            firstName: firstName,
            lastName: lastName,
            userName: userName,
            email: email,
            password: password);
        addUserToFireStore(myUser).then((value) async {
          provider.addUserToProvider(myUser);
          Navigator.pushNamedAndRemoveUntil(
            context,
            NoteList.noteListRoute,
            (route) => false,
          );
          showMessage('user registered successfully', context);
        }).onError((error, stackTrace) {
          showMessage(error.toString(), context);
        });
      }
    } on FirebaseAuthException catch (e) {
      hideLoading(context);
      showMessage(e.code, context);
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      provider.login(googleSignInAccount.displayName,
          googleSignInAccount.photoUrl, googleSignInAccount.email);
    } on FirebaseAuthException catch (e) {
      showMessage(e.message, context);
      throw e;
    }
  }

  Widget customSignInButton(String text, Buttons buttons) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: double.infinity,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: SignInButton(
          buttons,
          elevation: 5,
          text: text,
          onPressed: () {
            signInWithGoogle();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NoteList()));
          },
        ));
  }
}
