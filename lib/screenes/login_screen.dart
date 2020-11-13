import 'package:buy_it/provider/adminMod.dart';
import 'package:buy_it/provider/modelHud.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:buy_it/widgets/cutsom_logo.dart';
import 'package:flutter/material.dart';
import 'package:buy_it/constants.dart';
import 'package:buy_it/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/admin_home.dart';
import 'user/home_screen.dart';
import 'signup_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  bool keepLoggedIn = false;
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: kMainColor,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<ModelHud>(context).isLoading,
          child: Form(
            key: widget._globalKey,
            child: ListView(
              children: <Widget>[
                CustomLogo(),
                SizedBox(
                  height: height * .1,
                ),
                CustomTextField(
                  onClick: (value) {
                    _email = value;
                  },
                  hint: 'Enter your email',
                  icon: Icons.email,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor: kSecondaryColor,
                        activeColor: kMainColor,
                        value: keepLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepLoggedIn = value;
                          });
                        },
                      ),
                      Text('Remember Me'),

                    ],
                  ),
                ),
                CustomTextField(
                  onClick: (value) {
                    _password = value;
                  },
                  hint: 'Enter your password',
                  icon: Icons.lock,
                ),
                SizedBox(
                  height: height * .05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: Builder(
                    builder: (context) => FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        if(keepLoggedIn){
                          keepUserLoggedIn();
                        }
                        validate(context);
                      },
                      color: Colors.black,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have an account ? ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignupScreen.id);
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Provider.of<AdminMod>(context, listen: false)
                              .changeIsAdmin(false);
                        },
                        child: Text(
                          'I\'m a Admin',
                          style: TextStyle(
                              fontSize: 18,
                              color: Provider.of<AdminMod>(context).isAdmin
                                  ? Colors.white
                                  : kMainColor),
                        )),
                    GestureDetector(
                      onTap: () {
                        Provider.of<AdminMod>(context, listen: false)
                            .changeIsAdmin(true);
                      },
                      child: Text(
                        'I\'m a User',
                        style: TextStyle(
                            fontSize: 18,
                            color: Provider.of<AdminMod>(context).isAdmin
                                ? kMainColor
                                : Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void validate(BuildContext context) async {
    final modelHud = Provider.of<ModelHud>(context, listen: false);
    modelHud.changeIsLoading(true);
    if (widget._globalKey.currentState.validate()) {
      widget._globalKey.currentState.save();
      if (Provider.of<AdminMod>(context, listen: false).isAdmin) {
        if (_password == 'admin123') {
          try {

            await _auth.signIn(_email.trim(), _password.trim());

            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelHud.changeIsLoading(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          }
        } else {
          modelHud.changeIsLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong !'),
          ));
        }
      } else {
        try {
          await _auth.signIn(_email, _password);
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          modelHud.changeIsLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),

          ));

        }
      }
    }
    modelHud.changeIsLoading(false);
  }

  keepUserLoggedIn() async{
SharedPreferences preferences = await SharedPreferences.getInstance();
preferences.setBool(kKeepMeLoggedIn, keepLoggedIn);
  }
}
