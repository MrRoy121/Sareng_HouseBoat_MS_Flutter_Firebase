import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

import '../register.dart';

class PhoneVarification extends StatefulWidget {
  static String verify = "";
  static String phone = "";
  @override
  State<PhoneVarification> createState() => _PhoneVarificationState();
}

class _PhoneVarificationState extends State<PhoneVarification> {
  final phonecon = TextEditingController();
  final ccode = '+880';
  bool prog = false;

  phoneVeri() async {
    String phon = phonecon.text;
    PhoneVarification.phone = phon;
    String p = '${ccode + phon}';
    if (phon.length <= 0 || phon.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Phone Number Should Be 10 Digit"),
      ));
    } else {
      var fauth = FirebaseAuth.instance;
      await fauth.verifyPhoneNumber(
        phoneNumber: p,
        verificationCompleted: (PhoneAuthCredential credential) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => RegisterScreen()),
                  (Route<dynamic> route) => false);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Code Sending Failed"),
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          PhoneVarification.verify = verificationId;
          Navigator.pushNamed(context, 'otpveri');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/vectors/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Image.asset(
                'assets/vectors/sareng.png',
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.blue),
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Phone Varification",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoSlab',
                    color: Colors.blue,
                    fontSize: 24),
              ),
            ),
            Text(
              "Please Verify Your Phone Number To Proceed \nFor Registration",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                    controller: phonecon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Phone Number'),
                  ))
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
            SizedBox(
              height: 30,
            ),
            if(prog)
              CircularProgressIndicator(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(top: 10.0),
              width: 240,
              child: TextButton(
                child: Text(
                  "Get Code",
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  phoneVeri();
                  setState((){
                    prog = true;
                  });
    } ,
              ),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30.0)),
            ),
          ],
        ),
      ),
    );
  }
}
