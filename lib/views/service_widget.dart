import 'package:flutter/material.dart';
import 'package:groto/shared/user.dart';

class ServiceWidgetBuilder extends StatelessWidget {
  const ServiceWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
