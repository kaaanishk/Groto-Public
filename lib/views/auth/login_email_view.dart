import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/widgets.dart';
import 'package:provider/provider.dart';

class LoginEmailView extends StatefulWidget {
  @override
  _LoginEmailViewState createState() => _LoginEmailViewState();
}

class _LoginEmailViewState extends State<LoginEmailView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          child: Column(
            children: <Widget>[
              Flexible(
                child: title(),
                flex: 1,
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    emailField(_emailController),
                    passwordField(_passwordController),
                    VerticalSpace(),
                    Consumer<UserModel>(
                      builder: (context, userModel, _) =>
                          (userModel.state == ViewState.BUSY)
                              ? CupertinoActivityIndicator()
                              : Column(
                                  children: <Widget>[
                                    logInButton(
                                      context: context,
                                      userModel: userModel,
                                    ),
                                    VerticalSpace(),
                                    forgotPassword(
                                      context: context,
                                    ),
                                  ],
                                ),
                    ),
                  ],
                ),
                flex: 2,
              ),
            ],
          ),
          key: _formKey,
        ),
        minimum: minimumSafeArea,
      ),
      key: _scaffoldKey,
    );
  }

  Widget logInButton({@required BuildContext context, UserModel userModel}) {
    return StretchedCircularBlackButton(
        child: Text('Log in'),
        onPressed: () async {
          print(_formKey.currentState.validate());
          if (_formKey.currentState.validate()) {
            try {
              await userModel.logInEmail(
                  _emailController.text, _passwordController.text);
              Navigator.pushNamedAndRemoveUntil(
                context,
                shopsView,
                ModalRoute.withName('/'),
              );
            } catch (e) {
              showSnackBar(scaffoldKey: _scaffoldKey, text: e.toString());
            }
          }
        });
  }

  Widget forgotPassword({@required BuildContext context}) {
    return ClickableText(
      onTap: () {
        Navigator.pushReplacementNamed(context, resetPasswordView);
      },
      text: 'Forgot Password?',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
