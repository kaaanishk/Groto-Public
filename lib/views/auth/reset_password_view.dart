import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/widgets.dart';
import 'package:provider/provider.dart';

class ResetPasswordView extends StatefulWidget {
  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
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
                child: Column(
                  children: <Widget>[
                    info(),
                    VerticalSpace(),
                    emailField(_emailController),
                    VerticalSpace(),
                    Consumer<UserModel>(
                      builder: (context, userModel, _) =>
                          (userModel.state == ViewState.BUSY)
                              ? CupertinoActivityIndicator()
                              : Column(
                                  children: <Widget>[
                                    resetPasswordButton(
                                      context: context,
                                      userModel: userModel,
                                    )
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

  Widget info() {
    return Text('A reset link will be sent to your registered email');
  }

  Widget resetPasswordButton(
      {@required BuildContext context, UserModel userModel}) {
    return StretchedCircularBlackButton(
      child: Text('Reset Password'),
      onPressed: () async {
        try {
          if (_formKey.currentState.validate()) {
            await userModel.resetPassword(email: _emailController.text);
            showSnackBar(scaffoldKey: _scaffoldKey, text: userModel.message);
          }
        } catch (e) {
          showSnackBar(scaffoldKey: _scaffoldKey, text: e.toString());
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
