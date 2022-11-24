import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sareng/Screens/Admin/adminAddBoat.dart';
import 'package:sareng/Screens/Admin/adminMain.dart';
import 'package:sareng/Screens/login.dart';
import 'package:sareng/Screens/User/profile.dart';
import 'package:sareng/Screens/User/register.dart';
import 'package:sareng/Widgets/BoatCard.dart';

import 'Screens/User/Varification/otpVarification.dart';
import 'Screens/User/Varification/phoneVarification.dart';
import 'Screens/splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
   //   DevicePreview(
       // enabled: true,
        //builder: (context) =>
            MyApp(),
     // )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        'splash': (context) => SplashScreen(),
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        'phoneveri': (context) => PhoneVarification(),
        'otpveri': (context) => OtpVarification(),
        'adminmain': (context) => AdminMainScreen(),
        'adminaddboat': (context) => AdminAddBoat(),
        'profile' : (context) => ProfileScreen()
      },
    );
  }
}