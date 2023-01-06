import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'boatBookingDetails.dart';

class BookingHistory extends StatefulWidget {
  String uid;
  BookingHistory(this.uid);
  @override
  State<BookingHistory> createState() => _BookingHistoryState(uid);
}

class _BookingHistoryState extends State<BookingHistory> {
  bool approbool = false,
      pendbool = false,
      sharedbool = false,
      history = false,
      ppack = false,
      apack = false;
  String uid;
  String pname = "",
      pnumber = "",
      pduration = "",
      pdate = "",
      pbname = "",
      ppackname = "",
      pbid = "",
      aname = "",
      anumber = "",
      apackname = "",
      aduration = "",
      adate = "",
      abname = "",
      abid = "";

  int pquantity = 0;

  _BookingHistoryState(this.uid);
  @override
  Widget build(BuildContext context) {
    getData() {
      FirebaseFirestore.instance
          .collection("Boats_Booking_Requests")
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          pname = value["Booker Name"];
          pbname = value["Boat Name"];
          pnumber = value["Number"];
          pduration = value["Duration"];
          pdate = value["Booking Date"];
          pbid = value["Boat ID"];
          ppack = value["Package"];
          if (ppack) {
            ppackname = value["Package Name"];
          }
          pendbool = true;
          FirebaseFirestore.instance
              .collection("Boats")
              .doc(value["Boat ID"])
              .get()
              .then((value) {
            pquantity = int.parse(value["Quantity"]);
            setState(() {});
          });
        }
      });
      FirebaseFirestore.instance
          .collection('Boats_Booking_History')
          .where('User', isEqualTo: uid)
          .get()
          .then((QuerySnapshot qs) {
        if (!qs.docs.isEmpty) {
          history = true;
          setState(() {});
        }
      });
      FirebaseFirestore.instance
          .collection("Boats_Booking_Approved")
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          aname = value["Booker Name"];
          abname = value["Boat Name"];
          anumber = value["Booker Phone"];
          aduration = value["Duration"];
          adate = value["Booking Date"];
          abid = value["Boat ID"];
          apack = value["Package"];
          if (apack) {
            apackname = value["Package Name"];
          }
          approbool = true;
          print(value["Boat ID"]);
          setState(() {});
        }
      });

    }

    _editbookings() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BoatBookingDetails(
                pbid, pbname, false, pquantity.toString(), true, false, "", "", "")));

    }

    getData();
    return Scaffold(
      appBar: null,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: Text(
                "Booking History",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoSlab',
                    color: Colors.blue,
                    fontSize: 24),
              ),
            ),
            if (approbool)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Approved Bookings",
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Montserrat',
                            fontSize: 20),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5, color: Colors.lightBlueAccent),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 165,
                    margin:
                        const EdgeInsets.only(bottom: 6.0, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(children: [Expanded(
                                child: SizedBox(
                                  width: 1,
                                )),
                              Text(
                                "Booking On : ",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 10),
                              ),
                              Text(
                                adate,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 10),
                              ),],),
                            Container(
                              child: Row(children: [
                                if (apack)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_offer_outlined,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Package Name : ",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 10),
                                      ),
                                      Text(
                                        apackname,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                              ]),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.directions_boat_outlined,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Boat Name :  ",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 10),
                                          ),
                                          Text(
                                            abname,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'RobotoSlab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_outline_rounded,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Booker Name :  ",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 10),
                                          ),
                                          Text(
                                            aname,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'RobotoSlab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: Colors.white70,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                'Phone: ',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoSlab',
                                                    color: Colors.white70,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "(+880) " + anumber,
                                              style: TextStyle(
                                                  fontFamily: 'RobotoSlab',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ]),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.people,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Booking For : ",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 10),
                                          ),
                                          Text(
                                            aduration.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            if (pendbool)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pending Bookings",
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Montserrat',
                            fontSize: 20),
                      ),
                      Container(
                        child: IconButton(
                            onPressed: () {
                              _editbookings();
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.lightBlueAccent,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5, color: Colors.lightBlueAccent),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 155,
                    margin:
                        const EdgeInsets.only(bottom: 6.0, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Card(
                      color: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(children: [Expanded(
                                child: SizedBox(
                                  width: 1,
                                )),
                              Text(
                                "Booking On : ",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 10),
                              ),
                              Text(
                                pdate,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 10),
                              ),],),
                            Container(
                              child: Row(children: [
                                if (ppack)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_offer_outlined,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Package Name : ",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 10),
                                      ),
                                      Text(
                                        ppackname,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                Expanded(
                                    child: SizedBox(
                                  width: 1,
                                )),
                              ]),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.directions_boat_outlined,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Boat Name :  ",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 10),
                                          ),
                                          Text(
                                            pbname,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'RobotoSlab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: Colors.white70,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                'Phone: ',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoSlab',
                                                    color: Colors.white70,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "(+880) " + pnumber,
                                              style: TextStyle(
                                                  fontFamily: 'RobotoSlab',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ]),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.people,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Booking For : ",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 10),
                                          ),
                                          Text(
                                            pduration.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            if (history)
              (approbool || pendbool || sharedbool)
                  ? Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Booking History",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Montserrat',
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 40),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: Colors.lightBlueAccent),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Boats_Booking_History')
                                .where('User', isEqualTo: uid)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.hasData) {
                                return Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot stuone =
                                            streamSnapshot.data!.docs[index];
                                        return Container(
                                          height: 165,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            color: Colors.brown,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Row(children: [Expanded(
                                                      child: SizedBox(
                                                        width: 1,
                                                      )),Text(
                                                    "Booking On : ",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white70,
                                                        fontFamily:
                                                        'RobotoSlab',
                                                        fontSize: 10),
                                                  ),
                                                    Text(
                                                      stuone["Booking Date"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                          'RobotoSlab',
                                                          fontSize: 10),
                                                    ),],),
                                                  Container(
                                                    child: Row(children: [
                                                      Icon(
                                                        Icons
                                                            .directions_boat_outlined,
                                                        color: Colors.white70,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "Boat Name :  ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontFamily:
                                                                'RobotoSlab',
                                                            fontSize: 10),
                                                      ),
                                                      Text(
                                                        stuone["Boat Name"],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'RobotoSlab',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox(
                                                        width: 1,
                                                      )),

                                                    ]),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .person_outline_rounded,
                                                                  color: Colors
                                                                      .white70,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "Booker Name :  ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white70,
                                                                      fontFamily:
                                                                          'RobotoSlab',
                                                                      fontSize:
                                                                      10),
                                                                ),
                                                                Text(
                                                                  stuone[
                                                                      "Booker Name"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'RobotoSlab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                      10),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.phone,
                                                                    color: Colors
                                                                        .white70,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                    child: Text(
                                                                      'Booker Phone: ',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'RobotoSlab',
                                                                          color: Colors
                                                                              .white70,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    "(+880) " +
                                                                        stuone[
                                                                            "Booker Phone"],
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'RobotoSlab',
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                        10),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                            Row(children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.phone,
                                                                    color: Colors
                                                                        .white70,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                    child: Text(
                                                                      'User Phone: ',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'RobotoSlab',
                                                                          color: Colors
                                                                              .white70,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    "(+880) " +
                                                                        stuone[
                                                                            "User Phone"],
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'RobotoSlab',
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                        10),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: 1,
                                                                )),
                                                                Text(
                                                                  "Booking For : ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white70,
                                                                      fontFamily:
                                                                          'RobotoSlab',
                                                                      fontSize:
                                                                      10),
                                                                ),
                                                                Text(
                                                                  'For ' +
                                                                      stuone[
                                                                          "Duration"] +
                                                                      ' Nights'
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                      10),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return Text("No Package Available");
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Boats_Booking_History')
                          .where('User', isEqualTo: uid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot stuone =
                                      streamSnapshot.data!.docs[index];
                                  return Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      color: Colors.brown,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(children: [
                                                Icon(
                                                  Icons
                                                      .directions_boat_outlined,
                                                  color: Colors.white70,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Boat Name :  ",
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 10),
                                                ),
                                                Text(
                                                  stuone["Boat Name"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'RobotoSlab',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                  width: 1,
                                                )),
                                                Text(
                                                  "Booking Was On : ",
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 10),
                                                ),
                                                Text(
                                                  stuone["Booking Date"],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 10),
                                                ),
                                              ]),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .person_outline_rounded,
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Booker Name :  ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontSize: 10),
                                                          ),
                                                          Text(
                                                            stuone[
                                                                "Booker Name"],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.phone,
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 5),
                                                              child: Text(
                                                                'Booker Phone: ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'RobotoSlab',
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "(+880) " +
                                                                  stuone[
                                                                      "Booker Phone"],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'RobotoSlab',
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                      Row(children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.phone,
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 5),
                                                              child: Text(
                                                                'User Phone: ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'RobotoSlab',
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "(+880) " +
                                                                  stuone[
                                                                      "User Phone"],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'RobotoSlab',
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: SizedBox(
                                                            width: 1,
                                                          )),
                                                          Text(
                                                            "Booked For : ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontSize: 10),
                                                          ),
                                                          Text(
                                                            'For ' +
                                                                stuone[
                                                                    "Duration"] +
                                                                ' Nights'
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return Text("No Package Available");
                        }
                      },
                    ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
