import 'package:buy_it/constants.dart';
import 'package:buy_it/model/product.dart';
import 'package:buy_it/provider/cartitem.dart';
import 'package:buy_it/screenes/user/productinfo.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/MyPopupMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double screenWidth;
  double screenHeight;
  double appBarHeight;
  double statusBarHeight;
  List<Product> products;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    appBarHeight = AppBar().preferredSize.height;
    products = Provider.of<CartItem>(context).product;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'My card'.toUpperCase(),
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            LayoutBuilder(
              builder: (context, constrains) {
                if (products.isNotEmpty) {
                  return Container(
                      height: screenHeight -
                          statusBarHeight -
                          appBarHeight -
                          screenWidth * .12,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(15),
                            child: GestureDetector(
                              onTapUp: (details) async {
                                double dx = details.globalPosition.dx;
                                double dy = details.globalPosition.dy;
                                double dx2 =
                                    MediaQuery.of(context).size.width - dx;
                              //  double dy2 =MediaQuery.of(context).size.height - dy;
                                await showMenu(
                                    context: context,
                                    position:
                                        RelativeRect.fromLTRB(dx, dy, dx2, dx2),
                                    items: [
                                      MyPopupMenuItem(
                                          child: Text('Edit'),
                                          onclick: () {
                                            Product a = Product();
                                            a = products[index];
                                            Navigator.pop(context);
                                            Provider.of<CartItem>(context,
                                                    listen: false)
                                                .removeProduct(products[index]);
                                            Navigator.pushNamed(
                                                context, ProductInfo.id,
                                                arguments: a);
                                          }),
                                      MyPopupMenuItem(
                                        child: Text('Delete'),
                                        onclick: () {
                                          Navigator.pop(context);
                                          Provider.of<CartItem>(context,
                                                  listen: false)
                                              .removeProduct(products[index]);
                                        },
                                      )
                                    ]);
                              },
                              child: Container(
                                height: screenHeight * .15,
                                color: kSecondaryColor,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: screenHeight * .15 / 2,
                                      backgroundImage:
                                          AssetImage(products[index].pLocation),
                                    ),
                                    SizedBox(
                                      width: screenWidth * .01,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * .02),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  products[index].pName,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: screenHeight * .01,
                                                ),
                                                Text(
                                                  '\$${products[index].pPrice}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20),
                                              child: Text(
                                                products[index]
                                                    .pQuantity
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: products.length,
                      ));
                } else
                  return Container(
                    height: screenHeight -
                        screenWidth * .12 -
                        appBarHeight -
                        statusBarHeight,
                    child: Center(
                      child: Text('Cart is Empty '),
                    ),
                  );
              },
            ),
            Builder(
              builder: (context)=> ButtonTheme(
                minWidth: screenWidth,
                buttonColor: kMainColor,
                height: screenWidth * .12,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  onPressed: () {
                    showCustomDialog(context);
                  },
                  child: Text(
                    'Order'.toUpperCase(),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void showCustomDialog(context) {
    String address;
    List<Product> product =
        Provider.of<CartItem>(context, listen: false).product;
    var price = getTotalPrice(product);
    AlertDialog alertDialog = AlertDialog(
      title: Text('Total Price = \$ $price'),
      content: TextField(
        onChanged: (value){
          address = value;
        },
        decoration: InputDecoration(hintText: 'Enter Your Address'),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Store().storeOrders({
              kTotallPrice :price,
              kAddress : address
            }, product);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Order Successfully')));
            Navigator.pop(context);
          },
          child: Text('Confirm'),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalPrice(List<Product> products) {
    double price = 0;

    products.forEach((element) {
      price += (element.pQuantity * int.parse(element.pPrice));
    });
    return price;
  }
}
