import 'package:buy_it/model/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/MyPopupMenuItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constants.dart';
import 'editProduct.dart';

class MangeProduct extends StatefulWidget {
  static String id = 'MangeProduct';

  @override
  _MangeProductState createState() => _MangeProductState();
}

class _MangeProductState extends State<MangeProduct> {
  final _store = Store();
  String pID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            snapshot.data.documents.forEach((element) {
              Map data = element.data;
              pID = element.documentID;
              products.add(Product(
                  pName: data[kProductName],
                  pPrice: data[kProductPrice],
                  pDescription: data[kProductDescription],
                  pCategory: data[kProductCategory],
                  pLocation: data[kProductLocation],
                  pID: pID));
            });
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: .7),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: GestureDetector(
                    onTapUp: (details) async {
                      double dx = details.globalPosition.dx;
                      double dy = details.globalPosition.dy;
                      double dx2 = MediaQuery.of(context).size.width - dx;
                      //double dy2 = MediaQuery.of(context).size.height - dy;
                      await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(dx, dy, dx2, dx2),
                          items: [
                            MyPopupMenuItem(
                                child: Text('Edit'),
                                onclick: () {
                                  Navigator.pushNamed(context, EditProduct.id,
                                      arguments: products[index]);
                                }),
                            MyPopupMenuItem(
                              child: Text('Delete'),
                              onclick: () {
                                _store.deleteProduct(products[index].pID);
                                Navigator.pop(context);
                              },
                            )
                          ]);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Image(
                                fit: BoxFit.cover,
                                image: AssetImage(products[index].pLocation))),
                        Positioned(
                          bottom: 0,
                          child: Opacity(
                            opacity: .6,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(products[index].pName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text('\$ ${products[index].pPrice}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Loading .....'));
          }
        },
      ),
    );
  }
}


