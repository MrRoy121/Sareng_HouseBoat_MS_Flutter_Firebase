import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sareng/Screens/User/boatBookingDetails.dart';

import '../../Helper/Dimensions.dart';
import '../../Widgets/ExpandableText.dart';
import '../../Widgets/PackageCard.dart';
import 'main.dart';

class BoatDetails extends StatefulWidget {
  String boatid, boatname, price, boatimage, quantity, service;
  int package;

  BoatDetails(this.boatid, this.boatname, this.price, this.boatimage,
      this.quantity, this.service, this.package);

  @override
  State<BoatDetails> createState() => _BoatDetailsState(boatid, boatname, price, boatimage, quantity, service, package);
}

class _BoatDetailsState extends State<BoatDetails> {
  String boatid, boatname, price, boatimage, quantity, service;
  int package;
  final picker = ImagePicker();
  late File imageFile;
  late String fileName;
  XFile? pickedImage;
  FirebaseStorage storage = FirebaseStorage.instance;

  _BoatDetailsState(this.boatid, this.boatname, this.price, this.boatimage,
      this.quantity, this.service, this.package);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('Boats')
        .doc(boatid)
        .collection("Package");

    String pack = package.toString();

    Future<List<Map<String, dynamic>>> _loadImages() async {
      List<Map<String, dynamic>> files = [];

      final ListResult result =
          await storage.ref("Boats/" + boatid + "/Extra/").list();
      final List<Reference> allFiles = result.items;

      await Future.forEach<Reference>(allFiles, (file) async {
        final String fileUrl = await file.getDownloadURL();
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
        });
      });

      return files;
    }

    TextEditingController _textdes = TextEditingController();
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MainScreen()),
            (Route<dynamic> route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                child: Image.network(boatimage),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: Dimensions.popdetailsimg - 10,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    top: Dimensions.height20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.radious20),
                    topLeft: Radius.circular(Dimensions.radious20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            boatname,
                            style: const TextStyle(
                              fontSize: 26,
                              fontFamily: 'liakot',
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          margin: EdgeInsets.only(right: 10.0),
                          child: TextButton(
                            child: Text(
                              "Book Regular",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => BoatBookingDetails(
                                        boatid,
                                        boatname,
                                        false,
                                        quantity,
                                        false,
                                        false,
                                        "",
                                        "",
                                        "")),
                              );
                            },
                          ),
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 6.0, left: 10, right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              padding:
                                  EdgeInsets.only(left: 25, right: 25, top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Details",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 18),
                                      ),
                                      // Container(
                                      //     child: IconButton(
                                      //         onPressed: () {},
                                      //         icon: Icon(
                                      //           Icons.edit,
                                      //           color: Colors.lightBlueAccent,
                                      //         ))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [Icon(
                                        Icons.groups,
                                        color: Colors.black38,
                                      ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'For : $quantity Persons',
                                          style: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 36,),
                                        ),],),

                                      Row(children: [Icon(
                                        Icons.room_service,
                                        color: Colors.black38,
                                      ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Service : $service',
                                          style: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 36,),
                                        ),],),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.black38,
                                        ),
                                        Text(
                                          'Charge ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: MediaQuery.of(context).size.width / 40,),
                                        ),
                                        Text(
                                          ': $price/-' + " Night",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 38,),
                                        ),
                                      ]),
                                      Row(children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: Colors.black38,
                                        ),
                                        Text(
                                          ' Package : $pack Available ',
                                          style: TextStyle(
                                              color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 40,),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: const Text(
                                    "Description",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Montserrat',
                                        fontSize: 14),
                                  ),
                                ),
                                // Container(
                                //     margin: EdgeInsets.only(right: 25),
                                //     child: IconButton(
                                //         onPressed: () {
                                //           _addDescription(context);
                                //         },
                                //         icon: Icon(
                                //           Icons.edit,
                                //           color: Colors.lightBlueAccent,
                                //         ))),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(right: 60, left: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.lightBlueAccent),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('Boat_Description')
                                      .doc(boatid)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Loading...');
                                    }
                                    return ExpandableText(
                                      text: snapshot.data!['Description'],
                                    );
                                  }),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Available Packages",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Montserrat',
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "$pack      ",
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(right: 60, left: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.lightBlueAccent),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: StreamBuilder(
                                stream: users.snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        streamSnapshot) {
                                  if (streamSnapshot.hasData) {
                                    return Container(
                                      height: 250,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 30),
                                        child: CarouselSlider.builder(
                                            itemCount: streamSnapshot
                                                .data!.docs.length,
                                            options: CarouselOptions(
                                              viewportFraction: 1,
                                              initialPage: 0,
                                              autoPlay: true,
                                              height: 200,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                index, int) {
                                              DocumentSnapshot stuone =
                                                  streamSnapshot
                                                      .data!.docs[index];

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BoatBookingDetails(
                                                                boatid,
                                                                boatname,
                                                                false,
                                                                quantity,
                                                                false,
                                                                true,
                                                                stuone[
                                                                    "Package Name"],
                                                                stuone[
                                                                    "Package Service"],
                                                                stuone.id)),
                                                  );
                                                },
                                                child: PackageCard(
                                                    id: stuone.id,
                                                    pname:
                                                        stuone["Package Name"],
                                                    validity: stuone[
                                                        "Package Service"],
                                                    pprice:
                                                        stuone["Package Price"],
                                                    pquantity: stuone[
                                                        "Package Quantity"],
                                                    boatid: boatid,
                                                    b: false,
                                                    boatname: boatname,
                                                    price: price,
                                                    quantity: quantity,
                                                    service: service,
                                                    package: package),
                                              );
                                            }),
                                      ),
                                    );
                                  } else {
                                    return Text("No Package Available");
                                  }
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 20, right: 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Images",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Montserrat',
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(right: 60, left: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.lightBlueAccent),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            FutureBuilder(
                              future: _loadImages(),
                              builder: (context,
                                  AsyncSnapshot<List<Map<String, dynamic>>>
                                      snapshot) {
                                print(snapshot);
                                print("snapshot");
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Container(
                                    height: 300,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: CarouselSlider.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, index, int) {
                                        final Map<String, dynamic> image =
                                            snapshot.data![index];
                                        snapshot.data![index];
                                        return Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                      image['url'],
                                                    ),
                                                  )),
                                            ));
                                      },
                                      options: CarouselOptions(
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        autoPlay: true,
                                        height: 400,
                                        // onPageChanged:
                                        //     (int i, carouselPageChangedReason) {
                                        //   setState(() {
                                        //     index = i;
                                        //   });
                                        // }
                                      ),
                                    ),

                                    // child: GridView.count(
                                    //   crossAxisCount: 2,
                                    //   crossAxisSpacing: 4.0,
                                    //   mainAxisSpacing: 8.0,
                                    //   children: List.generate(
                                    //       snapshot.data?.length ?? 0, (index) {
                                    //     final Map<String, dynamic> image =
                                    //         snapshot.data![index];
                                    //     return GestureDetector(
                                    //       onLongPress: () {
                                    //         _deleteImage(image['path']);
                                    //       },
                                    //       child: Center(
                                    //           child: Card(
                                    //         margin: const EdgeInsets.symmetric(
                                    //             vertical: 10),
                                    //         child: CarouselSlider(
                                    //           options: CarouselOptions(height: 400.0),
                                    //           items: [1,2,3,4,5].map((i) {
                                    //             return Builder(
                                    //               builder: (BuildContext context) {
                                    //                 return Container(
                                    //                   margin: EdgeInsets.all(6.0),
                                    //                   decoration: BoxDecoration(
                                    //                     borderRadius: BorderRadius.circular(8.0),
                                    //                     image: DecorationImage(
                                    //                       image: NetworkImage(image['url']),
                                    //                       fit: BoxFit.cover,
                                    //                     ),
                                    //                   ),
                                    //                 );
                                    //               },
                                    //             );
                                    //           }).toList(),
                                    //         ),
                                    //         //child: Image.network(image['url']),
                                    //       ),
                                    //       ),
                                    //     );
                                    //   }),
                                    // ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
