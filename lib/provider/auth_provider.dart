import 'package:flutter/material.dart';

import '../models/user.dart' as AppUser;

class AuthProvider extends ChangeNotifier {
  AppUser.User user;
  String displayName;
  String photoUrl;
  String email;

  login(String displayName, String photoUrl, String email) async {
    this.displayName = displayName;
    this.photoUrl = photoUrl;
    this.email = email;
    notifyListeners();
  }

  void addUserToProvider(AppUser.User user) {
    this.user = user;
    notifyListeners();
  }
}
