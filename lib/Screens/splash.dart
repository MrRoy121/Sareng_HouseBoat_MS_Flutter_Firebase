import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sareng/Screens/login.dart';

class SplashScreen extends StatefulWidget {


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(
        const Duration(seconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/vectors/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 180, left: 40, right: 40, bottom: 30),
                child: Image.asset(
                  'assets/vectors/sareng.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 160,
              ),
              Text(
                "Boat Booking And \n Providing Company In ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 204, 255, 30),
                  fontSize: 26,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Tanguar Hoar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 204, 255, 30),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
