import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/connectivity_state.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/widgets.dart';
import 'package:provider/provider.dart';

class ConnectivityView extends StatelessWidget {
  final Widget child;

  ConnectivityView({@required this.child});

  @override
  Widget build(BuildContext context) {
    ConnectivityState _connectivityState =
        Provider.of<ConnectivityState>(context);
//    if (_connectivityState == null) {
//      return Scaffold(body: Center(child: CupertinoActivityIndicator()));
//    } else if (_connectivityState == ConnectivityState.OFFLINE) {
//      return Scaffold(
//        body: SafeArea(
//          minimum: minimumSafeArea,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                  'No internet connection detected.'),
//              StretchedCircularBlackButton(
//                onPressed: () {
//                  AppSettings.openWIFISettings();
//                },
//                child: Text('Enable internet'),
//              )
//            ],
//          ),
//        ),
//      );
//    }
    return child;
  }
}
