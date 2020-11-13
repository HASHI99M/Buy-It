import 'package:buy_it/model/product.dart';
import 'package:buy_it/provider/cartitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'cart_screen.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int count = 1;
  Product _product;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    _product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: w,
          height: h,
          child: Image(
            image: AssetImage(_product.pLocation),
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * .09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.id);
                  },
                )
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            child: Column(
              children: [
                Opacity(
                  child: Container(
                    height: h * .3,
                    width: w,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _product.pName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: h * .01,
                          ),
                          Text(
                            _product.pDescription,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: h * .01,
                          ),
                          Text(
                            '\$${_product.pPrice}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: h * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: w * .12,
                                height: w * .12,
                                decoration: BoxDecoration(
                                    color: kMainColor,
                                    borderRadius: BorderRadius.circular(40)),
                                child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      add();
                                    }),
                                alignment: Alignment.center,
                              ),
                              SizedBox(
                                width: w * .03,
                              ),
                              Text(
                                count.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                width: w * .03,
                              ),
                              Container(
                                width: w * .12,
                                height: w * .12,
                                decoration: BoxDecoration(
                                    color: kMainColor,
                                    borderRadius: BorderRadius.circular(40)),
                                child: IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      remove();
                                    }),
                                alignment: Alignment.center,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  opacity: .5,
                ),
                ButtonTheme(
                    minWidth: w,
                    height: h * .09,
                    child: Builder(
                      builder: (context) => RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        onPressed: () {
                          addToCart(context);
                        },
                        color: kMainColor,
                        child: Text(
                          'Add to Card'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ))
              ],
            ))
      ],
    ));
  }

  remove() {
    if (count > 1) {
      setState(() {
        count--;
      });
    }
  }

  add() {
    setState(() {
      count++;
    });
  }

  addToCart(context) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    var productCart = cartItem.product;
    bool isYes = false;
    productCart.forEach((element) {
      if (element.pName == _product.pName)
        isYes = true;
      else
        isYes = false;
    });

    if (isYes) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('the Product is Add ! ')));
    } else {
      _product.pQuantity = count;
      cartItem.addProduct(_product);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Added to Cart')));
    }
  }
}
