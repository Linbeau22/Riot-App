import 'package:first_project/network/api.dart';
import 'package:first_project/screens/main_screen.dart';
import 'package:first_project/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../components/constants.dart';
import '../network/flutterfire.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const id = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade900,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: ListView(
            children: <Widget>[
              TextLiquidFill(
                text: 'Flutter.GG',
                waveColor: Colors.orange.shade800,
                boxBackgroundColor: Colors.purple.shade900,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merienda',
                ),
                boxHeight: 300.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailField,
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Email'),
                    style: TextStyle(
                      fontFamily: 'SourceCodePro',
                    )),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  controller: _passwordField,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Password'),
                  style: TextStyle(
                    fontFamily: 'SourceCodePro',
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              RoundedButton(
                label: 'Log In',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  bool shouldNavigate =
                      await signIn(_emailField.text, _passwordField.text);
                  if (shouldNavigate) {
                    Navigator.pushNamed(context, MainScreen.id);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                label: 'New? Register here!',
                onPressed: () =>
                    Navigator.pushNamed(context, RegistrationScreen.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
