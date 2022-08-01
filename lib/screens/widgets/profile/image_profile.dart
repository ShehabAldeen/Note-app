import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_todo/main.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../utils/utils.dart';

class ImageProfile extends StatefulWidget {
  ImageProfile({Key key}) : super(key: key);

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  AuthProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context);
    return Stack(
      children: [
        ClipOval(
          child: SizedBox(
              height: 145,
              width: 145,
              child: prefs.getString('photoUrl') != ''
                  ? Image.network(
                      prefs.getString('photoUrl') ?? '',
                      fit: BoxFit.cover,
                    )
                  : prefs.getString('imagePath') != ''
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                      File(prefs.getString('imagePath') ?? '')),
                                  fit: BoxFit.cover)),
                        )
                      : Container(
                          decoration: BoxDecoration(color: Colors.grey),
                          child: const Icon(
                            Icons.person,
                            size: 45,
                          ))),
        ),
        Positioned(
            top: 95,
            left: 85,
            child: IconButton(
              onPressed: () {
                modelBottomSheet(context);
              },
              icon: Icon(
                Icons.camera_alt,
                size: 45,
                color: Colors.green.shade800,
              ),
            ))
      ],
    );
  }

  Future getImageProfile(ImageSource source) async {
    final selectedImage = await ImagePicker().getImage(source: source);
    provider.cameraImage(selectedImage.path);
    setState(() {});
  }

  void modelBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
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
                            Navigator.pop(context);
                            prefs.setString('photoUrl', '');
                            prefs.setString('imagePath', '');
                            setState(() {});
                          });
                        },
                        child: prefs.getString('imagePath') != '' &&
                                prefs.getString('photoUrl') == ''
                            ? const Icon(Icons.delete)
                            : Container())
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton.icon(
                        icon: const Icon(Icons.camera),
                        onPressed: () async {
                          await getImageProfile(ImageSource.camera);
                        },
                        label: const Text("Camera"),
                      ),
                      FlatButton.icon(
                        icon: const Icon(Icons.image),
                        onPressed: () async {
                          await getImageProfile(ImageSource.gallery);
                        },
                        label: const Text("Gallery"),
                      ),
                    ])
              ],
            ),
          );
        });
  }
}
