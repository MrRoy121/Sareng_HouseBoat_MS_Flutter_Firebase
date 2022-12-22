import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoatCard extends StatelessWidget {
  String boatname, price, boatimage, quantity, service, package;
  BoatCard(this.boatname, this.price, this.boatimage, this.quantity,
      this.service, this.package);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 20.0), //(x,y)
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Wrap(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(boatimage),
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text(
                        boatname,
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'liakot',
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.groups,
                                color: Colors.black38,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Maximum : $quantity' + " Person",
                                style: TextStyle(
                                    color: Colors.black38, fontSize: MediaQuery.of(context).size.width / 40),
                              ),
                            ],
                          ),
                          Container(
                            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.room_service,
                                  color: Colors.black38,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Service : $service',
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: MediaQuery.of(context).size.width / 40),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: Colors.black38,  fontSize: MediaQuery.of(context).size.width / 40),
                            ),
                            Text(
                              ': $price/-' + " Nights",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black38, fontSize: MediaQuery.of(context).size.width / 40),
                            ),
                          ]),
                          Row(children: [
                            Icon(
                              Icons.local_offer_outlined,
                              color: Colors.black38,
                            ),
                            Text(
                              'Package : $package',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: MediaQuery.of(context).size.width / 40),
                            ),
                          ]),
                        ],
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
        ],
      ),
    );
  }
}
