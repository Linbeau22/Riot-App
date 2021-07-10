import 'package:first_project/weather_screen.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'network/flutterfire.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//Register:
// - email
// - password

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const id = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_outlined),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  controller: _emailField,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  //password
                  controller: _passwordField,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Password'),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              RoundedButton(
                label: 'Register',
                color: Colors.blueGrey,
                onPressed: () async {
                  setState(() {
                    showSpinner =
                        true; //turning loading spinner on while data is retrieved
                  });

                  bool shouldNavigate =
                      await register(_emailField.text, _passwordField.text);
                  if (shouldNavigate) {
                    Navigator.pushNamed(context, WeatherScreen.id);
                  }

                  setState(() {
                    showSpinner =
                        false; //turning loading spinner off when data is retrieved
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
