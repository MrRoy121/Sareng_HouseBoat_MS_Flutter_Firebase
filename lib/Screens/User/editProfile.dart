import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sareng/Screens/User/main.dart';
import 'package:sareng/Screens/User/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  String email, name, pass, phone;
  EditProfile(this.email, this.name, this.pass, this.phone);
  @override
  State<EditProfile> createState() => _EditProfileState(email, name, pass, phone);
}

class _EditProfileState extends State<EditProfile> {

  String email, name, pass, sphone;
  _EditProfileState(this.email, this.name, this.pass, this.sphone);
  final _conuserEmail = TextEditingController();
  final _conuserName = TextEditingController();
  final _conuserPass = TextEditingController();


  signUp() async {
    String email = _conuserEmail.text;
    String name = _conuserName.text;
    String pass = _conuserPass.text;
    String phone = sphone;

    if (email.isEmpty || name.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ALL Fields Are Required"),
      ));
    } else {

      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString("uid");
      FirebaseFirestore.instance.collection('Users').doc(uid).set({'Full Name': name, 'E-mail' : email, 'Phone': phone, 'Password': pass}).then((value) {
        prefs.setBool('user', true);
        prefs.setString("email", email);
        prefs.setString("phone", phone);
        prefs.setString("pass", pass);
        prefs.setString("name", name);
        prefs.setString("uid", uid!);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Update Successfull!"),
        ));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MainScreen()),
                (Route<dynamic> route) => false);
      }).catchError((error) => print("Failed to add user: $error"));

    }
  }

  @override
  Widget build(BuildContext context) {

    _conuserEmail.text = email;
    _conuserName.text = name;
    _conuserPass.text = pass;
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/vectors/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                    child: Image.asset(
                      'assets/vectors/sareng.png',
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "Edit Profile Form",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoSlab',
                          color: Colors.blue,
                          fontSize: 24),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _conuserName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Full Name",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _conuserEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.mail),
                        hintText: "E-Mail",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _conuserPass,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.password),
                        hintText: "Password",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    width: 240,
                    child: TextButton(
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => signUp(),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30.0)),
                  ),


                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
