import 'package:buy_it/constants.dart';
import 'package:buy_it/provider/adminMod.dart';
import 'package:buy_it/provider/cartitem.dart';
import 'package:buy_it/provider/modelHud.dart';
import 'package:buy_it/screenes/admin/add_product.dart';
import 'package:buy_it/screenes/admin/admin_home.dart';
import 'package:buy_it/screenes/admin/MangeProduct.dart';
import 'package:buy_it/screenes/admin/editProduct.dart';
import 'package:buy_it/screenes/admin/orderdetails.dart';
import 'package:buy_it/screenes/admin/view_orders.dart';
import 'package:buy_it/screenes/login_screen.dart';
import 'package:buy_it/screenes/signup_screen.dart';
import 'package:buy_it/screenes/user/cart_screen.dart';
import 'package:buy_it/screenes/user/home_screen.dart';
import 'package:buy_it/screenes/user/productinfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isUserLoggedIn = preferences.get(kKeepMeLoggedIn) ?? false;
  String screenID;
  if (isUserLoggedIn)
    screenID = HomeScreen.id;
  else
    screenID = LoginScreen.id;
  runApp(MyApp(screenID: screenID,));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final String screenID;

  const MyApp({Key key, this.screenID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ModelHud>(create: (context) => ModelHud()),
        ChangeNotifierProvider<AdminMod>(create: (context) => AdminMod()),
        ChangeNotifierProvider<CartItem>(create: (context) => CartItem()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: screenID,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AdminHome.id: (context) => AdminHome(),
          AddProduct.id: (context) => AddProduct(),
          MangeProduct.id: (context) => MangeProduct(),
          EditProduct.id: (context) => EditProduct(),
          ProductInfo.id: (context) => ProductInfo(),
          CartScreen.id: (context) => CartScreen(),
          ViewOrders.id: (context) => ViewOrders(),
          OrderDetails.id: (context) => OrderDetails(),
        },
      ),
    );
  }
}
