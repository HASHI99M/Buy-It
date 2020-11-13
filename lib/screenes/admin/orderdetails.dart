import 'package:buy_it/constants.dart';
import 'package:buy_it/model/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  static String id = 'OrderDetails';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String docID;

  final _store = Store();
  double screenWidth;
  double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    docID = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrdersDetails(docID),
        builder: (context, snapShot) {
          if (!snapShot.hasData) {
            return Center(
              child: Text('Loading ..'),
            );
          } else {
            List<Product> products = [];
            snapShot.data.documents.forEach((element) {
              products.add(Product(
                  pName: element[kProductName],
                  pQuantity: element[kProductQuantity],
                  pLocation: element[kProductLocation],
                  pPrice: element[kProductPrice]));
            });
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.all(20),

                            color: kSecondaryColor,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Product Name : ${products[index].pName}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: screenHeight * .01,
                                  ),
                                  Text(
                                    'Quantity : ${products[index].pQuantity}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * .01,
                                  ),
                                  Text(
                                    'Price :${products[index].pPrice}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * .01,
                                  ),
                                  Image(image: AssetImage(products[index].pLocation) )

                                ],
                              ),
                            ),
                          )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Confirm Order'),
                        color: Colors.greenAccent,
                      ),
                      RaisedButton(
                          onPressed: () {},
                          child: Text('Delete Order'),
                          color: Colors.redAccent)
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
