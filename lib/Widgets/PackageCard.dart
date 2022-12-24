import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  String validity,
      pname,
      pprice,
      pquantity,
      id,
      boatid,
      boatname,
      price,
      quantity,
      service;
  int package;
  bool b;

  PackageCard(
      {required this.id,
      required this.pname,
      required this.validity,
      required this.pprice,
      required this.pquantity,
      required this.boatid,
        required this.b,
      required this.boatname,
      required this.price,
      required this.quantity,
      required this.service,
      required this.package});

  _deletePackage(String packID) {
    FirebaseFirestore.instance
        .collection('Boats')
        .doc(boatid)
        .collection("Package")
        .doc(packID)
        .delete();
    FirebaseFirestore.instance.collection('Boats').doc(boatid).set({
      'Boat Name': boatname,
      'Price': price,
      'Quantity': quantity,
      'Package': package - 1,
      'Service': service
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6.0),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage("assets/vectors/package_bg.png"),
                  fit: BoxFit.fill),
            ),
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 25, top: 40),
                      child:
                          Row(
                            children: [
                              Text(
                                "For : ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 10),
                              ),
                              Text(
                                validity,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 10),
                              ),
                            ],
                          ),
                    ),

                    if(b)
                      Container(
                        height: 25,
                        margin: EdgeInsets.only(right: 30),
                        child: IconButton(
                          onPressed: () {
                            _deletePackage(id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        pname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      Expanded(
                          child: SizedBox(
                        width: 1,
                      )),
                      Text(
                        pprice.toString(),
                        style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width/20),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "/-",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RobotoSlab',
                              fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.white70,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "For : " + pquantity + ' Person'.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            margin: EdgeInsets.only(left: 50, right: 35, top: 140, bottom: 20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 15),
                  color: Colors.grey.withOpacity(.5),
                  spreadRadius: -9)
            ]),
          ),
        ],
      ),
    );
  }
}
