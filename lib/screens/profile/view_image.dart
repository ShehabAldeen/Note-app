import 'package:flutter/material.dart';
import 'package:new_todo/screens/profile/profile_utils.dart';

class ViewProfileImage extends StatefulWidget {
  static const routeName = 'view-profile';

  @override
  State<ViewProfileImage> createState() => _ViewProfileImageState();
}

class _ViewProfileImageState extends State<ViewProfileImage> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Profile photo'),
        actions: [
          InkWell(
              onTap: () {
                ProfileUtils.bottomSheet(context);
              },
              child: Icon(Icons.edit)),
          SizedBox(
            width: 11,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: ProfileUtils.getProfile(context,
            width: double.infinity,
            height: size.height * .7,
            iconSize: 50,
            paddingSize: 18),
      ),
    );
  }
}
