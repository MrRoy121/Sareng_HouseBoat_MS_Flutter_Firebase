import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminShowBookings extends StatefulWidget {
  @override
  State<AdminShowBookings> createState() => _AdminShowBookingsState();
}

class _AdminShowBookingsState extends State<AdminShowBookings> {
  bool pend = true, appro = false;
  CollectionReference pending =
      FirebaseFirestore.instance.collection('Boats_Booking_Requests');
  CollectionReference approve =
      FirebaseFirestore.instance.collection('Boats_Booking_Approved');
  @override
  Widget build(BuildContext context) {
    _launchCaller(String ss) async {
      var url = "tel:" + ss;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
                "User's Bookings",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoSlab',
                    color: Colors.blue,
                    fontSize: 24),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 40, left: 40, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(30)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      pend = true;
                      appro = false;
                    });
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                      color: pend ? Colors.lightBlueAccent : Colors.grey,
                      width: 1.0,
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: Text(
                    "Pending",
                    style: TextStyle(
                        color: pend ? Colors.lightBlueAccent : Colors.grey),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      appro = true;
                      pend = false;
                    });
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                      color: appro ? Colors.lightBlueAccent : Colors.grey,
                      width: 1.0,
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: Text(
                    "Approved",
                    style: TextStyle(
                        color: appro ? Colors.lightBlueAccent : Colors.grey),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            pend
                ? Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: StreamBuilder(
                      stream: pending.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot stuone =
                                      streamSnapshot.data!.docs[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext dcontext) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Container(
                                                height: 140,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  margin: EdgeInsets.only(
                                                      left: 20, right: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Booking Approval",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontFamily:
                                                                'RobotoSlab',
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Confirm To Book For " +
                                                            stuone[
                                                                "Booker Name"],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Boats_Booking_Requests')
                                                                  .doc(
                                                                      stuone.id)
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "Request Deleted Successfully!"),
                                                                ));
                                                                Navigator.pop(
                                                                    dcontext);
                                                              });
                                                            },
                                                            child: Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                              primary: const Color(
                                                                  0xFFFF0000),
                                                            )
                                                            ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  dcontext);
                                                            },
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontSize: 10,
                                                              ),
                                                            ),style: ElevatedButton.styleFrom(
                                                            primary: const Color(
                                                                0xFF4F6C6D),
                                                          )
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Boats_Booking_Approved')
                                                                  .doc(
                                                                      stuone.id)
                                                                  .set({
                                                                'Boat Name': stuone[
                                                                    "Boat Name"],
                                                                'Booker Name':
                                                                    stuone[
                                                                        "Booker Name"],
                                                                'Boat ID': stuone[
                                                                    "Boat ID"],
                                                                'Booking Contact':
                                                                    stuone[
                                                                        "Booker Phone"],
                                                                'User Phone':
                                                                    stuone[
                                                                        "Number"],
                                                                'Booking Date':
                                                                    stuone[
                                                                        "Booking Date"],
                                                                'Duration': stuone[
                                                                    "Duration"],
                                                                'Package': stuone[
                                                                    "Package"],
                                                                'Package Name':
                                                                    stuone[
                                                                        "Package Name"]
                                                              }).then((value) {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Boats_Booking_Requests')
                                                                    .doc(stuone
                                                                        .id)
                                                                    .delete();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "Approved Successfully!"),
                                                                ));
                                                                Navigator.pop(
                                                                    dcontext);
                                                              }).catchError(
                                                                      (error) =>
                                                                          print(
                                                                              "Failed to add user: $error"));
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                              style: ElevatedButton.styleFrom(
                                                                primary: const Color(
                                                                    0xFF099093),
                                                              ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      height: 230,
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
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: SizedBox(
                                                    width: 1,
                                                  )),
                                                  Text(
                                                    "Booking On : ",
                                                    style: TextStyle(
                                                        color: Colors.white70,
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
                                                  ),
                                                ],
                                              ),
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
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontSize: 8),
                                                  ),
                                                  Text(
                                                    stuone["Boat Name"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
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
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "Booked By :  ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontFamily:
                                                                      'RobotoSlab',
                                                                  fontSize: 8),
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
                                                                  fontSize: 12),
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
                                                                        top: 5),
                                                                child: Text(
                                                                  'Booking Contact: ',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'RobotoSlab',
                                                                      color: Colors
                                                                          .white70,
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.width/45),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      _launchCaller("0" +
                                                                          stuone[
                                                                              "Booker Phone"]),
                                                                  child: Text(
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
                                                                            12),
                                                                  )),
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
                                                                        top: 5),
                                                                child: Text(
                                                                  'User Phone: ',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'RobotoSlab',
                                                                      color: Colors
                                                                          .white70,
                                                                      fontSize:
                                                                      MediaQuery.of(context).size.width/45),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      _launchCaller("0" +
                                                                          stuone[
                                                                              "Number"]),
                                                                  child: Text(
                                                                    "(+880) " +
                                                                        stuone[
                                                                            "Number"],
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'RobotoSlab',
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  )),
                                                            ],
                                                          ),
                                                        ]),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: SizedBox(
                                                              width: 1,
                                                            )),
                                                            Text(
                                                              "Booking For : ",
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
                                    ),
                                  );
                                });
                        } else {
                          return Text("No Package Available");
                        }
                      },
                    ),
                  )
                : SizedBox(
                    width: 0,
                  ),
            appro
                ? Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: StreamBuilder(
                      stream: approve.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot stuone =
                                      streamSnapshot.data!.docs[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext dcontext) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Container(
                                                height: 140,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  margin: EdgeInsets.only(
                                                      left: 20, right: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Booking Finished",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontFamily:
                                                                'RobotoSlab',
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Confirm Trip is Finished For " +
                                                            stuone[
                                                                "Booker Name"],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  dcontext);
                                                            },
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontSize: 10,
                                                              ),
                                                            ),

                                                    style: ElevatedButton.styleFrom(
                                                      primary: const Color(
                                                          0xFF4F6C6D),
                                                    )
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Boats_Booking_History')
                                                                  .add({
                                                                'Boat Name': stuone[
                                                                    "Boat Name"],
                                                                'User':
                                                                    stuone.id,
                                                                'Booker Name':
                                                                    stuone[
                                                                        "Booker Name"],
                                                                'Boat ID': stuone[
                                                                    "Boat ID"],
                                                                'Booking Contact':
                                                                    stuone[
                                                                        "Booker Phone"],
                                                                'User Phone':
                                                                    stuone[
                                                                        "User Phone"],
                                                                'Booking Date':
                                                                    stuone[
                                                                        "Booking Date"],
                                                                'Duration': stuone[
                                                                    "Duration"],
                                                                'Package': stuone[
                                                                    "Package"],
                                                                'Package Name':
                                                                    stuone[
                                                                        "Package Name"]
                                                              }).then((value) {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Boats_Booking_Approved')
                                                                    .doc(stuone
                                                                        .id)
                                                                    .delete();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "Finished Booking Successfully!"),
                                                                ));
                                                                Navigator.pop(
                                                                    dcontext);
                                                              }).catchError(
                                                                      (error) =>
                                                                          print(
                                                                              "Failed to add user: $error"));
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'RobotoSlab',
                                                                fontSize: 10,
                                                              ),
                                                            ),

                                                              style: ElevatedButton.styleFrom(
                                                                primary: const Color(
                                                                    0xFF099093),
                                                              )
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      height: 230,
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
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Expanded(
                                                    child: SizedBox(
                                                      width: 1,
                                                    )),
                                                Text(
                                                  "Booking On : ",
                                                  style: TextStyle(
                                                      color: Colors.white70,
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
                                                ),
                                              ],),
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
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontSize: 8),
                                                  ),
                                                  Text(
                                                    stuone["Boat Name"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    width: 25,
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
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "Booked By :  ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontFamily:
                                                                      'RobotoSlab',
                                                                  fontSize: 8),
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
                                                                  fontSize: 12),
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
                                                                        top: 5),
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
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      _launchCaller("0" +
                                                                          stuone[
                                                                              "Booker Phone"]),
                                                                  child: Text(
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
                                                                            12),
                                                                  )),
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
                                                                        top: 5),
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
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      _launchCaller("0" +
                                                                          stuone[
                                                                              "User Phone"]),
                                                                  child: Text(
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
                                                                            12),
                                                                  )),
                                                            ],
                                                          ),
                                                        ]),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: SizedBox(
                                                              width: 1,
                                                            )),
                                                            Text(
                                                              "Booking For : ",
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
                                    ),
                                  );
                                });
                        } else {
                          return Text("No Package Available");
                        }
                      },
                    ),
                  )
                : SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
