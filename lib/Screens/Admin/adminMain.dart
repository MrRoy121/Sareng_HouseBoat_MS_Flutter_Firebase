import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sareng/Screens/Admin/adminAddBoat.dart';
import 'package:sareng/Screens/Admin/adminBoatDetails.dart';
import 'package:sareng/Screens/Admin/adminShowBookings.dart';

import '../../Widgets/BoatCard.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

CollectionReference boats = FirebaseFirestore.instance.collection('Boats');

class _AdminMainScreenState extends State<AdminMainScreen> {
  FirebaseStorage storageRef = FirebaseStorage.instance;
  bool _validURL = false;
  int length = 0;

  Future<String?> getImage(String st) async {
    await storageRef
        .ref("Boats/" + st + "/primary.jpeg")
        .getDownloadURL()
        .then((value) {
      _validURL = Uri.parse(value).isAbsolute;
      return value;
    });
  }

  Future<int> loadId() async {
    int _id = await Future.delayed(Duration(seconds: 7), () => 42);
    return _id;
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
   late List<Map<String, dynamic>> files=[];
     boats.get().then((QuerySnapshot querySnapshot) {
       querySnapshot.docs.forEach((doc)  {
          storageRef.ref("Boats/" + doc.id + "/primary.jpeg").getDownloadURL().then((value) {;

          files.add({
            'Boat ID': doc.id,
            'Boat Name': doc["Boat Name"],
            'Price': doc["Price"],
            'Quantity': doc["Quantity"],
            'Service': doc["Service"],
            'Package': doc["Package"],
            "url": value,
            // "path": file.fullPath
          });
        });
      });
    });
     await loadId();
   return files;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/vectors/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Image.asset(
                            'assets/vectors/sareng.png',
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: 170,
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                margin: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Add New Boat",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => AdminAddBoat()));
                                      },
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5.0),
                                margin: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.bookmark_added_sharp,
                                      color: Colors.white,
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Show Bookings",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => AdminShowBookings()));
                                      },
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5, color: Colors.lightBlueAccent),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _loadImages(),
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> image =
                              snapshot.data![index];
                          return GestureDetector(
                            onTap:  () {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                  builder: (_) => AdminBoatDetails(
                                      image['Boat ID'],
                                      image['Boat Name'],
                                      image['Price'],
                                      image['url'],
                                      image['Quantity'],
                                      image['Service'],
                                      image['Package'])),(Route<dynamic>route) => false);
                            },
                            child:
                            BoatCard(image['Boat Name'], image['Price'], image['url'], image['Quantity'], image['Service'],image['Package'].toString()  + " Available"),
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
