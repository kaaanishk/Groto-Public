import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/services/database_service.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/widgets.dart';
import 'package:groto/views/connectivity_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemsView extends StatelessWidget {
  String _retailerId;

  ProblemsView(this._retailerId);

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: scaffoldTitle('Problem or Feedback'),
        ),
        body: SafeArea(
          minimum: minimumSafeArea,
          child: FutureBuilder<String>(
              future: DatabaseService().fetchRetailer(_retailerId),
              builder: (context, snapshot) {
                print(snapshot);
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('You can contact us at: '),
                          ClickableText(
                            text: 'contact@groto.io',
                            onTap: () async {
                              String url = 'mailto:contact@groto.io';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  );
                } else if (!snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoActivityIndicator(),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('You may call the shop at: '),
                          ClickableText(
                            text: snapshot.data,
                            onTap: () async {
                              String url = 'tel:' + snapshot.data;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ),
                      VerticalSpace(),
                      Row(
                        children: <Widget>[
                          Text('You can contact us at: '),
                          ClickableText(
                            text: 'contact@groto.io',
                            onTap: () async {
                              String url = 'mailto:contact@groto.io';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
