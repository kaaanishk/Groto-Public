//import 'package:app_settings/app_settings.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:groto/shared/constants.dart';
//import 'package:groto/shared/widgets.dart';
//import 'package:location_permissions/location_permissions.dart';
//
//class LocationServiceView extends StatelessWidget {
//  final Widget child;
//
//  // TODO: Move to stream provider
//  LocationServiceView({@required this.child});
//
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//      builder: (context, snapshot) {
//        if (snapshot.hasData) {
//          if (snapshot.data == ServiceStatus.enabled)
//            return child;
//          else
//            return Scaffold(
//              body: SafeArea(
//                minimum: minimumEdgeInset,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                        'Location Services are required to locate shops near you.'),
//                    CircularBlackButton(
//                      child: Text('Enable location services.'),
//                      onPressed: () {
//                        AppSettings.openLocationSettings();
//                      },
//                    )
//                  ],
//                ),
//              ),
//            );
//        } else if (snapshot.hasError) {
//          return Scaffold(
//            body: Center(
//              child: Text('Something went wrong'),
//            ),
//          );
//        }
//        return Scaffold(
//          body: Center(
//            child: CupertinoActivityIndicator(),
//          ),
//        );
//      },
//      stream: LocationPermissions().serviceStatus,
//    );
//  }
//}
