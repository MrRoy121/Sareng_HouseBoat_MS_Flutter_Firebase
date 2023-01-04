import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class BoatBookingDetails extends StatefulWidget {
  bool shared, data, package;
  String boatid, boatname, packageName, packid, service,quantity;
  BoatBookingDetails(this.boatid, this.boatname, this.shared, this.quantity, this.data, this.package, this.packageName, this.service, this.packid);

  @override
  State<BoatBookingDetails> createState() =>
      _BoatBookingDetailsState(boatid, boatname, shared, int.parse(quantity), data, package, packageName, service, packid);
}

class _BoatBookingDetailsState extends State<BoatBookingDetails> {
  bool shared, data,package;
  int quantity;
  String boatid, boatname, packageName, packid, service;
  Color day = Colors.white;
  Color night = Colors.white;
  bool img = false;
  final _conbookername = TextEditingController();
  final _conbookernum = TextEditingController();
  final _conbookduration = TextEditingController();
  final _conbookseat = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String dddate = "";
  _BoatBookingDetailsState(
      this.boatid, this.boatname, this.shared, this.quantity, this.data, this.package, this.packageName, this.service, this.packid);
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dddate = "${selectedDate}".split(' ')[0];
      });
    }
  }

  _requestToBook() async {
    if (shared) {
      String name = _conbookername.text;
      String number = _conbookernum.text;
      String duration = _conbookduration.text;
      String seats = _conbookseat.text;
      // if (_day) {
      //   book = "Online";
      // } else {
      //   book = "Offline";
      // }

      if (name.isEmpty ||
          number.isEmpty ||
          duration.isEmpty ||
          dddate.isEmpty ||
          seats.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("ALL Fields Are Required"),
        ));
      } else if (!(number.length == 10)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Provide a valid Phone Number!!"),
        ));
      } else if (!(quantity > int.parse(seats))) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Seat Number is full, Book Fully!!"),
        ));
      } else {
        final prefs = await SharedPreferences.getInstance();

        FirebaseFirestore.instance
            .collection('Boats_Booking_Requests_Shared')
            .doc(prefs.getString("uid"))
            .get()
            .then((value) {
          if (value.exists) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("You Have Sent one Request Already!!"),
            ));
          } else {
            FirebaseFirestore.instance
                .collection('Boats_Booking_Requests_Shared')
                .doc(prefs.getString("uid"))
                .set({
              'Boat ID': boatid,
              'Booker Name': name,
              'Boat Name': boatname,
              'Duration': duration,
              'Seats': seats,
              'Total Seats': quantity,
              'Booking Date': dddate,
              'Number': number,
              "Booker Phone": prefs.getString("phone")
            }).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Booking Request Added!"),
              ));
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
                (Route<dynamic> route) => false);
          }
        });
      }
    } else {
      String name = _conbookername.text;
      String number = _conbookernum.text;
      String duration;

      if(package){
        duration = service;
      }else{
        duration = _conbookduration.text;
      }

      // if (_day) {
      //   book = "Online";
      // } else {
      //   book = "Offline";
      // }

      final prefs = await SharedPreferences.getInstance();

      if (name.isEmpty ||
          number.isEmpty ||
          duration.isEmpty ||
          dddate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("ALL Fields Are Required"),
        ));
      } else if (!(number.length == 10)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Provide a valid Phone Number!!"),
        ));
      } else {
        FirebaseFirestore.instance
            .collection('Boats_Booking_Requests')
            .doc(prefs.getString("uid"))
            .get()
            .then((value) {
          if (value.exists) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("You Have Sent one Request Already!!"),
            ));
          } else {
            FirebaseFirestore.instance
                .collection('Boats_Booking_Requests')
                .doc(prefs.getString("uid"))
                .set({
              'Boat ID': boatid,
              'Boat Name': boatname,
              'Booker Name': name,
              'Duration': duration,
              'Package': package,
              'Package ID': packid,
              'Package Name': packageName,
              'Booking Date': dddate,
              'Number': number,
              "Booker Phone": prefs.getString("phone")
            }).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Booking Request Added!"),
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

  _getData();
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
                            "Book Boat",
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
                      controller: _conbookername,
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
                        hintText: "Booker Name",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                          controller: _conbookernum,
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
                  if (shared)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        controller: _conbookseat,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.person),
                          hintText: "Seats",
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                      margin: EdgeInsets.only(top: 10.0, left: 20, right: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.black54,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              'Book To ',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          Text(
                            dddate,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 18),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                  if(!package)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _conbookduration,
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
                        prefixIcon: Icon(Icons.spa_rounded),
                        hintText: "Book For (Nights)",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       Container(
                  //         padding: EdgeInsets.only(left: 10.0),
                  //         margin: EdgeInsets.symmetric(vertical: 5),
                  //         child: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.online_prediction_rounded,
                  //               color: Colors.white,
                  //             ),
                  //             FlatButton(
                  //               child: Text(
                  //                 "Book Online",
                  //                 style: TextStyle(
                  //                     color: Colors.white, fontSize: 18),
                  //               ),
                  //               onPressed: () {
                  //                 setState(() {
                  //                   if (!_day) {
                  //                     day = Colors.blueAccent;
                  //                     _day = true;
                  //                     _night = false;
                  //                     night = Colors.white;
                  //                   }
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey,
                  //             border: Border.all(color: day, width: 3),
                  //             borderRadius: BorderRadius.circular(30.0)),
                  //       ),
                  //       Container(
                  //         padding: EdgeInsets.only(left: 10.0),
                  //         margin: EdgeInsets.symmetric(vertical: 5),
                  //         child: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.book_online,
                  //               color: Colors.white,
                  //             ),
                  //             FlatButton(
                  //               child: Text(
                  //                 "Book Offline",
                  //                 style: TextStyle(
                  //                     color: Colors.white, fontSize: 18),
                  //               ),
                  //               onPressed: () {
                  //                 setState(() {
                  //                   if (!_night) {
                  //                     day = Colors.white;
                  //                     _day = true;
                  //                     _night = false;
                  //                     night = Colors.blueAccent;
                  //                   }
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey,
                  //             border: Border.all(color: night, width: 3),
                  //             borderRadius: BorderRadius.circular(30.0)),
                  //       ),
                  //     ],
                  //   ),
                  //   decoration: BoxDecoration(
                  //       color: Colors.grey[200],
                  //       borderRadius: BorderRadius.all(Radius.circular(30))),
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
                          "Request To Book",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _requestToBook()),
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

  void _getData() async{

    final prefs = await SharedPreferences.getInstance();

    if(shared){
      FirebaseFirestore.instance
          .collection('Boats_Booking_Requests_Shared')
          .doc(prefs.getString("uid"))
          .get().then((value) {

        setState((){
          _conbookername.text = value['Booker Name'];
          _conbookernum.text = value['Number'];
          _conbookduration.text = value['Duration'];
          dddate = value['Booking Date'];
          _conbookseat.text = value['Seats'];
        });
      });
    }else{

      FirebaseFirestore.instance
          .collection('Boats_Booking_Requests')
          .doc(prefs.getString("uid"))
          .get().then((value) {

        setState((){
          _conbookername.text = value['Booker Name'];
          _conbookernum.text = value['Number'];;
          _conbookduration.text = value['Duration'];;
          dddate = value['Booking Date'];
        });
      });
    }
  }
}
