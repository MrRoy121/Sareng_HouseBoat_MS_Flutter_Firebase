import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sareng/Screens/Admin/adminMain.dart';
import 'package:sareng/Screens/User/main.dart';
import 'package:sareng/Screens/User/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'User/Varification/phoneVarification.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _conuserPhone = TextEditingController();

  final _conuserPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    sharedPref();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('user') ?? false;
    if (user) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
          (Route<dynamic> route) => false);
    }
  }

  signIN(BuildContext context) async {
    String phone = _conuserPhone.text;
    String pass = _conuserPass.text;

    final prefs = await SharedPreferences.getInstance();
    if (phone.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ALL Fields Are Required"),
      ));
    } else {
      if (phone == "123456" && pass == "admin") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => AdminMainScreen()),
            (Route<dynamic> route) => false);
      } else {
        List<Future<QuerySnapshot>> futures = [];
        FirebaseFirestore.instance
            .collection('Users')
            .where('Phone', isEqualTo: phone)
            .where('Password', isEqualTo: pass)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size == 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Phone And Password Didn't Match!!"),
            ));
          } else {
            querySnapshot.docs.forEach((docResults) {
              prefs.setBool('user', true);
              prefs.setString("email", docResults.get("E-mail"));
              prefs.setString("phone", docResults.get("Phone"));
              prefs.setString("pass", docResults.get("Password"));
              prefs.setString("name", docResults.get("Full Name"));
              prefs.setString("uid", docResults.id);
              print(docResults.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Login Successful!"),
              ));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => MainScreen()),
                  (Route<dynamic> route) => false);
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/vectors/sareng.png',
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "Sign In Form",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoSlab',
                          color: Colors.blue,
                          fontSize: 26),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    child: Row(
                      children: [
                        Text("+880"),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '|',
                          style: TextStyle(fontSize: 26, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: TextField(
                          controller: _conuserPhone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Phone Number'),
                        ))
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 15.0),
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
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => signIN(context),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  SizedBox(height: 20,),


                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                  ),


                  Container(
                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PhoneVarification()),
                                (Route<dynamic> route) => false);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontFamily: 'RobotoSlab',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
