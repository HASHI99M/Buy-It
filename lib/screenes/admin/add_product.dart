import 'package:buy_it/model/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';


class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  final _store = Store();
  

  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String _name, _price, _description, _category, _location;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Form(
      key: _globalKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
              onClick: (value) {
                _name = value;
              },
              icon: null,
              hint: 'Product Name'),
          SizedBox(
            height: heightScreen * .01,
          ),
          CustomTextField(
              onClick: (value) {
                _price = value;
              },
              icon: null,
              hint: 'Product Price'),
          SizedBox(
            height: heightScreen * .01,
          ),
          CustomTextField(
              onClick: (value) {
                _description = value;
              },
              icon: null,
              hint: 'Product Description'),
          SizedBox(
            height: heightScreen * .01,
          ),
          CustomTextField(
              onClick: (value) {
                _category = value;
              },
              icon: null,
              hint: 'Product Category'),
          SizedBox(
            height: heightScreen * .01,
          ),
          CustomTextField(
              onClick: (value) {
                _location = value;
              },
              icon: null,
              hint: 'Product Location'),
          SizedBox(
            height: heightScreen * .015,
          ),
          RaisedButton(
            onPressed: () {
              if (_globalKey.currentState.validate()) {
                _globalKey.currentState.save();
                _store.addProduct(Product(
                    pName: _name,
                    pPrice: _price,
                    pDescription: _description,
                    pCategory: _category,
                    pLocation: _location));
              }
            },
            child: Text('Add Product'),
          )
        ],
      ),
    ));
  }
}
