import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user.dart' as AppUser;

class AuthProvider extends ChangeNotifier {
  AppUser.User user;
  String displayName = '';
  String photoUrl = '';
  String email = '';
  String imagePath = '';

  login(String displayName, String photoUrl, String email) async {
    this.displayName = displayName;
    this.photoUrl = photoUrl;
    this.email = email;
    prefs.setString('email', this.email);
    prefs.setString('displayName', this.displayName);
    prefs.setString('photoUrl', this.photoUrl);

    notifyListeners();
  }

  void addUserToProvider(AppUser.User user) async {
    this.user = user;
    prefs.setString('email', this.user.email);
    prefs.setString('displayName', this.user.userName);
    notifyListeners();
  }

  cameraImage(String imagePath) {
    this.imagePath = imagePath;
    prefs.setString('photoUrl', '');
    prefs.setString('imagePath', imagePath);
    notifyListeners();
  }
}
