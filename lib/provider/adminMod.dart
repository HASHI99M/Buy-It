import 'package:flutter/cupertino.dart';

class AdminMod extends ChangeNotifier{
  bool isAdmin =false;
  changeIsAdmin(bool value){
    isAdmin = value;
    notifyListeners();
  }

}