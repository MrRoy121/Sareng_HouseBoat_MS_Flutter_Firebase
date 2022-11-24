import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sareng/Screens/User/profile.dart';

import '../../Widgets/BoatCard.dart';
import 'boatDetails.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

CollectionReference boats = FirebaseFirestore.instance.collection('Boats');

class _MainScreenState extends State<MainScreen> {
  FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<int> loadId() async {
    int _id = await Future.delayed(Duration(seconds: 4), () => 42);
    return _id;
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
    late List<Map<String, dynamic>> files = [];
    boats.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        storageRef
            .ref("Boats/" + doc.id + "/primary.jpeg")
            .getDownloadURL()
            .then((value) {
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadImages();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/vectors/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          margin: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),
                child: Row(
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
                        child: IconButton(
                      icon: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.lightBlueAccent,
                        size: 60,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ProfileScreen()));
                      },
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1.5, color: Colors.lightBlueAccent),
                    borderRadius: BorderRadius.circular(30)),
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
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => BoatDetails(
                                          image['Boat ID'],
                                          image['Boat Name'],
                                          image['Price'],
                                          image['url'],
                                          image['Quantity'],
                                          image['Service'],
                                          image['Package'])),
                                  (Route<dynamic> route) => false);
                            },
                            child: BoatCard(
                                image['Boat Name'],
                                image['Price'],
                                image['url'],
                                image['Quantity'],
                                image['Service'],
                                image['Package'].toString() + " Available"),
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
