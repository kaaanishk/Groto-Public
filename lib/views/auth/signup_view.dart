import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/widgets.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: minimumSafeArea,
        child: Form(
          child: Column(
            children: <Widget>[
              Flexible(
                child: title(),
                flex: 1,
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    nameField(_nameController),
                    emailField(_emailController),
                    passwordField(_passwordController),
                    VerticalSpace(),
                    createAccountButton(context),
                  ],
                ),
                flex: 2,
              ),
            ],
          ),
          key: _formKey,
        ),
      ),
      key: _scaffoldKey,
    );
  }

  Widget createAccountButton(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, _) => userModel.state == ViewState.BUSY
          ? CupertinoActivityIndicator()
          : StretchedCircularBlackButton(
              child: Text('Create Account'),
              onPressed: () async {
                try {
                  if (_formKey.currentState.validate()) {
                    await userModel.createUserWithEmail(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (userModel.id != null) {
                      Navigator.pushReplacementNamed(context, shopsView);
                    }
                  }
                } catch (e) {
                  showSnackBar(scaffoldKey: _scaffoldKey, text: e.toString());
                }
              },
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
