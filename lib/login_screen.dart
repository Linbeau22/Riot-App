import 'package:first_project/registration_screen.dart';
import 'package:first_project/weather_screen.dart';
import 'package:flutter/material.dart';
import 'components/rounded_button.dart';
import 'constants.dart';
import 'network/flutterfire.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

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
      backgroundColor: Colors.redAccent,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Expanded(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextLiquidFill(
                  text: 'Weather App',
                  waveColor: Colors.blueAccent,
                  boxBackgroundColor: Colors.redAccent,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
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
                  ),
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
                      Navigator.pushNamed(context, WeatherScreen.id);
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
      ),
    );
  }
}
