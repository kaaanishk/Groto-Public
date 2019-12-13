import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/base_model.dart';
import 'package:groto/services/authentication_service.dart';
import 'package:groto/shared/user.dart';

class UserModel extends BaseModel {
  User _user;
  String _message;

  AuthService _authService = AuthService();

  User get user => _user;

  String get id => _user.id;

  String get name => _user.name;

  String get email => _user.email;

  String get phone => _user.phone;

  Map<String, String> get address => _user.address;


  String get message => _message;

  UserModel({User user}) {
    if (user != null) {
      _user = user;
    }
  }

  Future<void> logInEmail(String email, String password) async {
    setState(ViewState.BUSY);
    try {
      _user =
          await _authService.loginWithEmail(email: email, password: password);
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  Future<void> logInGmail() async {
    setState(ViewState.BUSY);

    setState(ViewState.IDLE);
  }

  Future<void> createUserWithEmail(
      {@required String name, String email, String password}) async {
    setState(ViewState.BUSY);
    try {
      _user = await _authService.createAccount(
          name: name, email: email, password: password);
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  Future<void> logOut() async {
    setState(ViewState.BUSY);
    try {
      await _authService.logOut();
      _user = null;
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  Future<void> resetPassword({@required email}) async {
    setState(ViewState.BUSY);
    try {
      await _authService.resetPassword(email: email);
      _message = 'A password reset link has been sent to your email';
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }
}
