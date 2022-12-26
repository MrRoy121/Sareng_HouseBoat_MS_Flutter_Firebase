import 'package:flutter/material.dart';
import 'package:sareng/Screens/Admin/adminMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'adminBoatDetails.dart';

class AdminAddBoatPackage extends StatefulWidget {

  String boatid, boatname, price, boatimage, quantity, service;
  int package;
  AdminAddBoatPackage(this.boatid, this.boatname, this.price, this.boatimage,
      this.quantity, this.service, this.package);
  @override
  State<AdminAddBoatPackage> createState() =>
      _AdminAddBoatPackageState(boatid, boatname, price, boatimage, quantity, service, package);
}

class _AdminAddBoatPackageState extends State<AdminAddBoatPackage> {
  //String date= "";
  final _conpackName = TextEditingController();
  final _conpackprice = TextEditingController();
  final _conpackFor = TextEditingController();
  final _conpackservice = TextEditingController();

  String boatid, boatname, prices, boatimage, quantity, service;
  int package;
  _AdminAddBoatPackageState(this.boatid, this.boatname, this.prices, this.boatimage,
      this.quantity, this.service, this.package);
  DateTime selectedDate = DateTime.now();
  //String dddate = "";

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       dddate = "${selectedDate}".split(' ')[0];
  //     });
  //   }
  // }

  AddPackage() async {
    String fors = _conpackFor.text;
    String name = _conpackName.text;
    String price = _conpackprice.text;
    String srvice = _conpackservice.text;

    if (fors.isEmpty || name.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ALL Fields Are Required"),
      ));
    } else {
      package ++;
      DocumentReference d = FirebaseFirestore.instance.collection('Boats').doc(boatid);
      d.set({'Boat Name': boatname, 'Price' : prices, 'Quantity': quantity, 'Package': package, 'Service': service});
      d.collection("Package").add({
        'Package Name': name,
        'Package Price': price,
        'Package Quantity': fors,
        'Package Service': srvice + " Nights"
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Package Added Successfully!"),
        ));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (_) => AdminBoatDetails(
                boatid, boatname, prices, boatimage, quantity, service, package)), (Route<dynamic> route) => false);
      }).catchError((error) => print("Failed to add package: $error"));
    }}


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
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(top: 20, bottom: 20, left: 20),
                          child: Image.asset(
                            'assets/vectors/sareng.png',
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Text(
                            "New Package",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoSlab',
                                color: Colors.blue,
                                fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Text(
                      "For - $boatname",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sail',
                          color: Colors.blue,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _conpackName,
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
                        prefixIcon: Icon(Icons.local_offer_outlined),
                        hintText: "Package Name",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _conpackFor,
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
                        prefixIcon: Icon(Icons.people_alt_outlined),
                        hintText: "Quantity",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _conpackprice,
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
                        prefixIcon: Icon(Icons.monetization_on),
                        hintText: "Price",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _conpackservice,
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
                        prefixIcon: Icon(Icons.date_range),
                        hintText: "Serves For",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                  //   margin: EdgeInsets.only(top: 10.0, left: 20, right: 20),
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.date_range, color: Colors.black54,),
                  //
                  //       Container(
                  //         margin: EdgeInsets.only(left: 10),
                  //         child: Text(
                  //           'Valid Till ',
                  //           style: TextStyle(color: Colors.black54),
                  //         ),
                  //       ),
                  //       FlatButton(
                  //         child: Text(
                  //           dddate,
                  //           style: TextStyle(
                  //               color: Colors.black54, fontSize: 18),
                  //         ),
                  //         onPressed: () {_selectDate(context);},
                  //       ),
                  //     ],
                  //   ),decoration: BoxDecoration(
                  //     color: Colors.grey[200],
                  //     borderRadius: BorderRadius.circular(30.0)),
                  // ),

                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    width: 240,
                    child: TextButton(
                      child: Text(
                        "Add Package",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => AddPackage(),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30.0)),
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
