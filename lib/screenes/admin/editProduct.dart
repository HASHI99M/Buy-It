import 'package:buy_it/model/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  final _store = Store();

  
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
   String _name, _price, _description, _category, _location;
    double heightScreen = MediaQuery.of(context).size.height;
    Product product = ModalRoute.of(context).settings.arguments;
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
                _store.editProduct(data: {
                  kProductName: _name,
                  kProductPrice: _price,
                  kProductDescription: _description,
                  kProductCategory: _category,
                  kProductLocation: _location
                }, documentId: product.pID);
              }
            },
            child: Text('Add Product'),
          )
        ],
      ),
    ));
  }
}
