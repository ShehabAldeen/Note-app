import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class ProfileUtils {
  static File image;

  static String getGoogleAccountDisplayName(BuildContext context) {
    if (Provider.of<AuthProvider>(context).displayName != null) {
      return Provider.of<AuthProvider>(context).displayName;
    }
    return '';
  }

  static String getGoogleAccountPhotoUrl(BuildContext context) {
    if (Provider.of<AuthProvider>(context).photoUrl != null) {
      return Provider.of<AuthProvider>(context).photoUrl;
    }
    return '';
  }

  static String getGoogleAccountEmail(BuildContext context) {
    if (Provider.of<AuthProvider>(context).email != null) {
      return Provider.of<AuthProvider>(context).email;
    }
    return '';
  }

  static Future getImage(ImageSource source) async {
    final image = await ImagePicker().getImage(source: source);
    ProfileUtils.image = File(image.path);
  }

  static Widget getFirebaseImage(
      {double width,
      double height,
      double paddingSize,
      double iconSize,
      BoxShape shape}) {
    return Container(
      width: width,
      height: height,
      child: ClipOval(
        child: ProfileUtils.image != null
            ? Image.file(ProfileUtils.image,
                width: width, height: height, fit: BoxFit.cover)
            : Container(
                padding: EdgeInsets.all(paddingSize),
                color: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: iconSize,
                )),
      ),
    );
  }

  static void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (buildContext) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Choose Profile photo",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          logOutMessage(context,
                              title: '',
                              content: 'Remove profile photo?', onPressed: () {
                            image = null;
                            Navigator.pop(context);
                          });
                        },
                        child: image != null ? Icon(Icons.delete) : Container())
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton.icon(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        label: Text("Camera"),
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        label: Text("Gallery"),
                      ),
                    ])
              ],
            ),
          );
        });
  }

  static Widget getGoogleAccountImage(BuildContext context,
      {double width, double height, double iconSize, BoxShape shape}) {
    return ProfileUtils.image != null
        ? Container(
            width: width,
            height: height,
            child: ClipOval(
              child: Image.file(ProfileUtils.image,
                  width: width, height: height, fit: BoxFit.cover),
            ),
          )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: NetworkImage(getGoogleAccountPhotoUrl(context)),
                  fit: BoxFit.fill),
            ),
          );
  }

  static Widget getProfile(BuildContext context,
      {double width, double height, double paddingSize, double iconSize}) {
    if (Provider.of<AuthProvider>(context).user != null) {
      return getFirebaseImage(
          width: width,
          height: height,
          paddingSize: paddingSize,
          iconSize: iconSize);
    } else if (ProfileUtils.getGoogleAccountEmail(context) != '') {
      return getGoogleAccountImage(context,
          width: width, height: height, iconSize: iconSize);
    }
    return null;
  }

  static String getDisplayNameOfCurrentAccount(BuildContext context) {
    if (Provider.of<AuthProvider>(context).user != null) {
      return Provider.of<AuthProvider>(context).user.userName;
    } else if (ProfileUtils.getGoogleAccountEmail(context) != '') {
      return ProfileUtils.getGoogleAccountDisplayName(context);
    }
    return '';
  }

  static String getEmailOfCurrentAccount(BuildContext context) {
    if (Provider.of<AuthProvider>(context).user != null) {
      return Provider.of<AuthProvider>(context).user.email;
    } else if (ProfileUtils.getGoogleAccountEmail(context) != '') {
      return ProfileUtils.getGoogleAccountEmail(context);
    }
    return '';
  }

  static void logOutMessage(BuildContext context,
      {String title, String content, Function() onPressed}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              // The "Yes" button
              TextButton(onPressed: onPressed, child: const Text('OK')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'))
            ],
          );
        });
  }
}
