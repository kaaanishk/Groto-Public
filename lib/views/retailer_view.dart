import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/location_model.dart';
import 'package:groto/models/order_model.dart';
import 'package:groto/services/database_service.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/navigator_drawer.dart';
import 'package:groto/shared/retailer.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/widgets.dart';
import 'package:groto/views/connectivity_view.dart';
import 'package:groto/views/places_autocomplete.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

class RetailerView extends StatefulWidget {
  @override
  _RetailerViewState createState() => _RetailerViewState();
}

class _RetailerViewState extends State<RetailerView> {
  final PlacesAutoCompleteSearchDelegate _delegate =
      PlacesAutoCompleteSearchDelegate();
  Future<PermissionStatus> permission;
  final _locationPermission = LocationPermissions();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    permission = _locationPermission.requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Shops',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
          minimum: minimumSafeArea,
          child: Consumer<LocationModel>(
            builder: (context, locationModel, _) => Column(
              children: <Widget>[
                _locationSearch(context: context, locationModel: locationModel),
                Expanded(
                  child: _retailerList(
                    context: context,
                    locationModel: locationModel,
                  ),
                ),
                _requestRetailer(context: context),
              ],
            ),
          ),
        ),
        drawer: NavigationDrawer(),
        key: _scaffoldKey,
      ),
    );
  }

  Widget _retailerList(
      {@required BuildContext context, LocationModel locationModel}) {
    if (locationModel.place == null) {
      return Center(child: Text('Tap above to detect your location'));
    } else if (locationModel.state == ViewState.BUSY) {
      return Center(child: CupertinoActivityIndicator());
    } else {
      return RetailerList();
    }
  }

  Widget _requestRetailer({@required BuildContext context}) {
    return Column(
      children: <Widget>[
        Text('Don\'t see your known shops?'),
        ClickableText(
            onTap: () {
              Navigator.pushNamed(context, comingSoonView);
            },
            text: 'Tap here to let us know'),
      ],
    );
  }

  Widget _locationSearch(
      {@required BuildContext context, LocationModel locationModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.location_on,
        ),
        ClickableText(
          onTap: () async {
            await showSearch(
              context: context,
              delegate: _delegate,
            );
          },
          text: locationModel.place != null
              ? locationModel.place['description'] != null
                  ? locationModel.place['description'].toString().split(',')[0]
                  : locationModel.place['name']
              : 'Tap here to search your street or area',
        ),
      ],
    );
  }
}

class RetailerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(
      builder: (context, locationModel, _) =>
          locationModel.state == ViewState.BUSY
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : StreamBuilder(
                  stream: DatabaseService().getShopsAroundUser(
                      location: locationModel.place['geometry']['location']),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(
                        child: Text(
                          'Something went wrong. Check your internet connection or try restarting the app',
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data.length == 0) {
                      return Center(
                        child: Text(
                          'Coming soon in your area',
                        ),
                      );
                    } else {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: Column(children: <Widget>[
                              CupertinoActivityIndicator(),
                              Text('Finding retailers near you'),
                            ]),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot retailerSnapshot =
                                  snapshot.data[index];

                              return RetailerTile(
                                Retailer(
                                    retailerSnapshot: retailerSnapshot,
                                    location: locationModel.place['geometry']
                                        ['location']),
                              );
                            },
                            shrinkWrap: true,
                          );
                      }
                    }
                    return null;
                  }),
    );
  }
}

class RetailerTile extends StatelessWidget {
  @override
  final Retailer _retailer;

  RetailerTile(this._retailer);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.black),
        ),
        child: RetailerCard(retailer: _retailer),
      ),
    );
  }
}

class RetailerCard extends StatelessWidget {
  final Retailer retailer;

  RetailerCard({@required this.retailer});

  Widget _rating() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      child: Container(
        child: Center(
          child: Text(retailer.rating.toString()),
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        height: 50,
        width: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(retailer.shop),
      subtitle: Text(
        'Distance: ' + retailer.distance.toStringAsFixed(1) + ' km',
      ),
      trailing: _rating(),
      onTap: () {
        OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
        orderModel.retailer = retailer;
        orderModel.reset();
        Navigator.pushNamed(
          context,
          itemsView,
        );
      },
    );
  }
}
