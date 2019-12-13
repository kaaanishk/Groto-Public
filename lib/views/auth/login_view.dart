import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/widgets.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: title(),
              flex: 1,
            ),
            Flexible(
              child: Form(
                child: Column(
                  children: <Widget>[
                    logInEmailButton(context: context),
                    signUpButton(context: context),
                  ],
                ),
                key: _formKey,
              ),
              flex: 2,
            ),
          ],
        ),
        minimum: minimumSafeArea,
      ),
      key: _scaffoldKey,
    );
  }

  Widget logInEmailButton({BuildContext context}) {
    return StretchedCircularBlackButton(
      child: Text('Log in with email'),
      onPressed: () {
        Navigator.pushNamed(context, loginEmailView);
      },
    );
  }

  Widget signUpButton({BuildContext context}) {
    return StretchedCircularBlackButton(
      child: Text('Sign up'),
      onPressed: () {
        Navigator.pushNamed(context, signupView);
      },
    );
  }
}
