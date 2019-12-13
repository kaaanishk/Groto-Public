import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/widgets.dart';
import 'package:groto/views/problem_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Your orders',
          style: TextStyle(
            fontFamily: 'NotoSerif',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        minimum: minimumSafeArea,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('orders')
              .where('user',
              isEqualTo: Provider.of<UserModel>(context).id)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            print(snapshot);
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoActivityIndicator(),
                      Text('Loading Orders')
                    ]),
              );
            } else if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text('No orders yet'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot orderSnapshot =
                      snapshot.data.documents[index];
                  return OrderCard(orderSnapshot: orderSnapshot);
                },
                shrinkWrap: true,
                physics: ScrollPhysics(),
              );
            }
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final DocumentSnapshot orderSnapshot;

  OrderCard({@required this.orderSnapshot});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(orderSnapshot.data['shop']),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: ClickableText(
                    onTap: () async {
                      String url =
                          'tel:' + orderSnapshot.data['retailer_phone'];
                      try {
                        if (await canLaunch(url)) await launch(url);
                      } catch (e) {
                        throw 'Could not launch $url';
                      }
                    },
                    text: orderSnapshot.data['retailer_phone']),
              ),
              Divider(color: Colors.black),
              ListView.builder(
                itemCount: orderSnapshot.data['items'].length,
                itemBuilder: (context, index) {
                  String key =
                      orderSnapshot.data['items'].keys.elementAt(index);
                  return ListTile(
                    title: Text(key),
                    trailing: Text(orderSnapshot.data['items'][key].toString()),
                  );
                },
                shrinkWrap: true,
              ),
              ListTile(
                  title: Text('Total:'),
                  trailing:
                      Text((orderSnapshot.data['total'] / 100).toString())),
              Divider(color: Colors.black),
              ListTile(
                title: Text('Payment method:'),
                trailing: Text(orderSnapshot.data['payment']),
              ),
              ListTile(
                title: Text('Shipping method: '),
                trailing: Text(
                  orderSnapshot.data['shipping_method'],
                ),
              ),
              ListTile(
                title: Text('Status: '),
                trailing: orderSnapshot.data['order_status'] == 'created'
                    ? Text('Created')
                    : Text('Delivered'),
              ),
              Center(
                child: ClickableText(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProblemsView(orderSnapshot.data['retailer']),
                      ),
                    );
                  },
                  text: 'Report a problem',
                ),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
    ;
  }
}
