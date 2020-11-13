import 'package:buy_it/model/product.dart';
import 'package:buy_it/screenes/user/productinfo.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../login_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  final _store = Store();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabBarIndex = 0;
  int _bottomNavIndex = 0;
bool isLoading = false;
  List<Product> _products;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Stack(
        children: [
          DefaultTabController(
            length: 4,
            child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _bottomNavIndex,
                  fixedColor: kMainColor,
                  unselectedItemColor: kUnActiveColor,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) async {
                    if(value == 0){
                      setState(() {
                        isLoading = true;
                      });
                      SharedPreferences a = await SharedPreferences.getInstance();
                      a.clear();
                      Auth().signOut();
                      Navigator.popAndPushNamed(context, LoginScreen.id);
                    }
                    setState(() {
                      _bottomNavIndex = value;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.switch_video), title: Text('Test')),     BottomNavigationBarItem(
                        icon: Icon(Icons.switch_video), title: Text('Test')),

                  ]),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                bottom: TabBar(
                  indicatorColor: kMainColor,
                  onTap: (value) {
                    setState(() {
                      _tabBarIndex = value;
                    });
                  },
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Jackets',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                          fontSize: _tabBarIndex == 0 ? 16 : null,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Trouser',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 1 ? Colors.black : kUnActiveColor,
                          fontSize: _tabBarIndex == 1 ? 16 : null,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'T-shirts',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 2 ? Colors.black : kUnActiveColor,
                          fontSize: _tabBarIndex == 2 ? 16 : null,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Shoes',
                        style: TextStyle(
                          color:
                              _tabBarIndex == 3 ? Colors.black : kUnActiveColor,
                          fontSize: _tabBarIndex == 3 ? 16 : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                productView(kJackets),
                productView(kTrousers),
                productView(kTshirts),
                productView(kShoes),
              ]),
            ),
          ),
          Material(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                height: MediaQuery.of(context).size.height * .09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discover'.toUpperCase(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
                      Navigator.pushNamed(context, CartScreen.id);
                    })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget productView(pCategory) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget._store.loadProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          snapshot.data.documents.forEach((element) {
            Map data = element.data;

            products.add(Product(
                pName: data[kProductName],
                pPrice: data[kProductPrice],
                pDescription: data[kProductDescription],
                pCategory: data[kProductCategory],
                pLocation: data[kProductLocation],
                pID: element.documentID));
          });

          _products = [...products];
          products.clear();
          for (var product in _products) {
            if (product.pCategory == pCategory) products.add(product);
          }

          return GridView.builder(

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .7),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductInfo.id , arguments: products[index]);
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
    );
  }
}
