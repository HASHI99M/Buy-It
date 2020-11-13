import 'package:buy_it/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class Store {
  final Firestore fir = Firestore.instance;

  addProduct(Product product) {
    fir.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
      kProductCategory: product.pCategory,
    });
  }

  Stream<QuerySnapshot> loadProduct() {
    return fir.collection(kProductsCollection).snapshots();
  }

  deleteProduct(documentId) {
    fir.collection(kProductsCollection).document(documentId).delete();
  }

  editProduct({Map<String, dynamic> data, String documentId}) {
    fir.collection(kProductsCollection).document(documentId).updateData(data);
  }

  storeOrders(data, List<Product> products) {
    var documentRef = fir.collection(kOrders).document();
    documentRef.setData(data);

    products.forEach((element) {
      documentRef.collection(kOrderDetails).document().setData({
        kProductName: element.pName,
        kProductPrice: element.pPrice,
        kProductQuantity: element.pQuantity,
        kProductLocation: element.pLocation,
      });
    });
  }

  Stream<QuerySnapshot> loadOrders() {
    return fir.collection(kOrders).snapshots();
  }

  Stream<QuerySnapshot> loadOrdersDetails(docID) {
    return fir
        .collection(kOrders)
        .document(docID)
        .collection(kOrderDetails)
        .snapshots();
  }
}
