import 'package:buy_it/screenes/admin/add_product.dart';
import 'package:buy_it/screenes/admin/view_orders.dart';
import 'package:flutter/material.dart';


import '../../constants.dart';
import 'MangeProduct.dart';
class AdminHome extends StatefulWidget {
  static String id = 'AdminHome';
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:kMainColor ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(onPressed: (){
              Navigator.pushNamed(context, AddProduct.id);
            } , child: Text('Add Product'),),
            RaisedButton(onPressed: (){
              Navigator.pushNamed(context, MangeProduct.id);
            } , child: Text('Edit Product'),),
            RaisedButton(onPressed: (){
              Navigator.pushNamed(context, ViewOrders.id);
            } , child: Text('View Product'),)
          ],
        ),
      ),
    );
  }
}
