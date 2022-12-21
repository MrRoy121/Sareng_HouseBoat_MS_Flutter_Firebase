import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sareng/Screens/Admin/adminMain.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AdminAddBoat extends StatefulWidget {
  @override
  State<AdminAddBoat> createState() => _AdminAddBoatState();
}

class _AdminAddBoatState extends State<AdminAddBoat> {
  Color day = Colors.white;
  Color night = Colors.white;
  bool _day = false, _night = false, img = false;
  final picker = ImagePicker();
  late File imageFile;
  late String fileName;
  XFile? pickedImage;
  final _conboatname = TextEditingController();
  final _conboatprice = TextEditingController();
  final _conboatquantity = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  addBoat() async{
    String bname = _conboatname.text;
    String price = _conboatprice.text;
    String quantity = _conboatquantity.text;
    String service;
    int package = 0;
    DateTime now = DateTime.now();

    if(bname.isEmpty || price.isEmpty || quantity.isEmpty || (!_day && !_night)){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("ALL Fields Are Required"),
      ));
    }else{
      if(_day&&_night){
        service = 'Day/Night';
      }else if(_day){
        service = 'Day';
      }else{
        service = 'Night';
      }

      FirebaseFirestore.instance.collection('Boats').add({'Boat Name': bname, 'Price' : price, 'Quantity': quantity, 'Package': package,'Service': service}).then((value) async {
        try {
          FirebaseFirestore.instance.collection("Boat_Description").doc(value.id).set({'Description': "New Boat"});
          await storage.ref("Boats/" + value.id+"/primary.jpeg").putFile(
              imageFile,
              SettableMetadata(customMetadata: {
                'Boat Name': bname,
              }));
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Boat Added Successfully!"),
        ));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => AdminMainScreen()),
                (Route<dynamic> route) => false);
      }).catchError((error) => print("Failed to add user: $error"));
    }

  }

  Future<void> selectImage() async{
      try {
        pickedImage = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
        fileName = path.basename(pickedImage!.path);
        imageFile = File(pickedImage!.path);
        img=true;
      }catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
      setState((){});
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                      child: Image.asset(
                        'assets/vectors/sareng.png',
                        height: MediaQuery.of(context).size.width/6,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "Add Boat Form",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoSlab',
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width/22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _conboatname,
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
                      prefixIcon: Icon(Icons.directions_boat_outlined),
                      hintText: "Boat Name",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _conboatprice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: "Charge",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _conboatquantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.groups),
                      hintText: "Quantity",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width:  MediaQuery.of(context).size.width/3,
                            padding: EdgeInsets.only(left: 10.0),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sunny,
                                  color: Colors.white,
                                ),
                                TextButton(
                                  child: Text(
                                    "Day",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () {
                                    setState((){
                                      if(!_day){
                                        day = Colors.blueAccent;
                                        _day = true;
                                      }else{
                                        day=Colors.white;
                                        _day = false;
                                      }

                                    });
                                  },
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: day,width: 3),
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          Container(
                            width:  MediaQuery.of(context).size.width/3,
                            padding: EdgeInsets.only(left: 10.0),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.brightness_3_rounded,
                                  color: Colors.white,
                                ),
                                TextButton(
                                  child: Text(
                                    "Night",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () {
                                    setState((){

                                      if(!_night){
                                        night = Colors.blueAccent;
                                        _night = true;
                                      }else{
                                        night=Colors.white;
                                        _night = false;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(

                                color: Colors.grey,
                                border: Border.all(color: night,width: 3),
                                borderRadius: BorderRadius.circular(30.0)),
                          ),

                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      margin: EdgeInsets.only(left: 20, top: 10, bottom: 50),
                      child: Row(
                        children: [
                          Icon(Icons.add_a_photo_outlined,),
                          TextButton(child: Text("Add Image"),onPressed: (){
                            selectImage();
                          },
                          ),
                        ],
                      ),
                        decoration: BoxDecoration(
                    color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height/6,
                      width: MediaQuery.of(context).size.width/3,
                      margin: EdgeInsets.only( right: 20, top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child:  img ?
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                        ),
                      ):SizedBox(width: 1,),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),

                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  width: 240,
                  child: TextButton(
                      child: Text(
                        "Add Boat",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        addBoat();
                      }),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
