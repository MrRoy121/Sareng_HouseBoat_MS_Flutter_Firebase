import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sareng/Screens/User/editProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/displayImage.dart';
import 'bookingHistory.dart';
import '../login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name = "", email = "", phone = "", pass = "", uid = "";
  final picker = ImagePicker();
  late File imageFile;
  late String fileName, imgFile = "";
  XFile? pickedImage;
  bool img = false, p = false;
  String hpass = "********";
  Icon iccon = Icon(
    Icons.lock_outline,
    color: Colors.black26,
  );

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    sharedPref();
  }

  getImage() {
    storage
        .ref("Users/" + uid + "/primary.jpeg")
        .getDownloadURL()
        .then((value) {
          setState((){
            imgFile = value.toString();
            img = true;
          });
    });
  }

  showpass() {
    setState(() {
      if (p) {
        hpass = "********";
        iccon = Icon(
          Icons.lock_outline,
          color: Colors.black26,
        );
        p = false;
      } else {
        hpass = pass;
        iccon = Icon(
          Icons.lock_open_outlined,
          color: Colors.black26,
        );
        p = true;
      }
    });
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      phone = prefs.getString("phone") ?? "";
      pass = prefs.getString("pass") ?? "";
      uid = prefs.getString("uid") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    logout() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('user', false);
      prefs.setString("email", '');
      prefs.setString("phone", '');
      prefs.setString("pass", '');
      prefs.setString("name", '');
      prefs.setString("uid", '');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false);
    }

    Future<void> selectImage() async {
      try {
        pickedImage =
            await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
        fileName = path.basename(pickedImage!.path);
        imageFile = File(pickedImage!.path);

        await storage
            .ref("Users/" + uid + "/primary.jpeg")
            .putFile(
                imageFile,
                SettableMetadata(customMetadata: {
                  'Full Name': name,
                }))
            .then((p0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User Image Added Successfully!"),
          ));
          Navigator.of(context).pop();
        });
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

    return Scaffold(
      appBar: null,
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    "Profile Screen",
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontFamily: 'sail',
                      fontSize: MediaQuery.of(context).size.width / 16,),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () {
                      logout();
                    },
                    icon: Icon(
                      Icons.logout,
                      size: MediaQuery.of(context).size.width / 16,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                img
                    ? Container(
                        width: 140,
                        height: 140,
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(imgFile), fit: BoxFit.fill),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 140,
                        height: 140,
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'http://s3.amazonaws.com/37assets/svn/765-default-avatar.png'),
                              fit: BoxFit.fill),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    selectImage();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 135, left: 100),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 22,
                      color: Colors.lightBlueAccent,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFADD8E6).withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Details",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Montserrat',
                      fontSize: MediaQuery.of(context).size.width / 26),
                ),
                Container(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => EditProfile(email, name, pass, phone)));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.lightBlueAccent,
                          size: MediaQuery.of(context).size.width / 26,
                        ))),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 40),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(30)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 35,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Full Name",
                style: TextStyle(
                    color: Colors.black26,
                    fontFamily: 'RobotoSlab',
                    fontSize: 12),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50, top: 5, left: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.black26),
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'RobotoSlab',
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "E-mail",
                style: TextStyle(
                    color: Colors.black26,
                    fontFamily: 'RobotoSlab',
                    fontSize: 12),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50, top: 5, left: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.black26),
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                email,
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'RobotoSlab',
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone",
                style: TextStyle(
                    color: Colors.black26,
                    fontFamily: 'RobotoSlab',
                    fontSize: 12),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50, top: 5, left: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.black26),
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                "(+880) $phone",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'RobotoSlab',
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(
                    color: Colors.black26,
                    fontFamily: 'RobotoSlab',
                    fontSize: 12),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50, top: 5, left: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.black26),
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hpass,
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'RobotoSlab',
                        fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {
                        showpass();
                      },
                      icon: iccon)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 40,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: TextButton(
                      child: const Text(
                        "Booking History",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold,),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => BookingHistory(uid)));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
