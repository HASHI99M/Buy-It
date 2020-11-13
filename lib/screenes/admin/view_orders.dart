import 'package:buy_it/constants.dart';
import 'package:buy_it/model/order.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'orderdetails.dart';

class ViewOrders extends StatefulWidget {
  static String id = 'ViewOrders';

  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  final _store = Store();
  double screenWidth;
  double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapShot) {
          if (!snapShot.hasData) {
            return Center(
              child: Text('there is no orders ..'),
            );
          } else {
            List<Order> orders = [];
            snapShot.data.documents.forEach((doc) {
              orders.add(Order(totalPrice: doc.data[kTotallPrice],
                  address: doc.data[kAddress],
              docID: doc.documentID));
            });
            return ListView.builder(itemCount: orders.length,itemBuilder: (context , index){
              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, OrderDetails.id ,arguments: orders[index].docID );
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: screenHeight * .2,
                  color: kSecondaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('\$${orders[index].totalPrice.toString()}', style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: screenHeight * .01,
                        ),
                        Text('${orders[index].address}' , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),

                      ],
                    ),
                  ),
                ),
              );
            },);
          }
        },
      ),
    );
  }
}
