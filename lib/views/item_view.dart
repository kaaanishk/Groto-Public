import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/models/order_model.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/item.dart';
import 'package:groto/shared/navigator_drawer.dart';
import 'package:groto/shared/widgets.dart';
import 'package:groto/views/cart_view.dart';
import 'package:groto/views/connectivity_view.dart';
import 'package:provider/provider.dart';

class ItemView extends StatefulWidget {
  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final _ItemSearchDelegate _delegate = _ItemSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _lastItemSelected;

  Widget itemTile(BuildContext context, Item item) {
    OrderModel orderModel = Provider.of<OrderModel>(context);
    return ListTile(
      title: Text(item.name),
      subtitle: Text('Rs. ' +
          (item.price / 100).toString() +
          ' per ' +
          item.weight.toString() +
          ' g'),
      trailing: AddToCartButton(orderModel, item),
    );
  }

  Widget itemGrid(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('retailers')
            .document(Provider.of<OrderModel>(context).retailer.id)
            .collection('items')
            .where('quantity', isGreaterThan: 0)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Text('Loading Items')
                ]);
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot itemSnapshot = snapshot.data.documents[index];
                Item item = Item(itemSnapshot: itemSnapshot);
                return itemTile(context, item);
              },
              padding: EdgeInsets.all(5.0),
              physics: ScrollPhysics(),
              shrinkWrap: true,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              tooltip: 'Search',
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () async {
                final String selected = await showSearch<String>(
                  context: context,
                  delegate: _delegate,
                );
                if (selected != null && selected != _lastItemSelected) {
                  setState(() {
                    _lastItemSelected = selected;
                  });
                }
              },
            ),
          ],
          title: Text(
            'Items',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
          minimum: minimumSafeArea,
          child: Column(
            children: <Widget>[itemGrid(context), checkoutButton(context)],
          ),
        ),
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(),
        extendBody: true,
      ),
    );
  }

  Widget checkoutButton(BuildContext context) {
    return StretchedCircularBlackButton(
      child: Text(
        'GO TO CHECKOUT',
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartView()),
        );
      },
    );
  }
}

class AddToCartButton extends StatelessWidget {
  OrderModel orderModel;
  Item item;

  AddToCartButton(this.orderModel, this.item);

  @override
  Widget build(BuildContext context) {
    return (!orderModel.items.containsKey(item))
        ? CircularBlackButton(
            child: Text(
              'Add To Cart',
            ),
            onPressed: () {
              orderModel.add(item);
            },
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 10.0, right: 16.0, bottom: 10.0),
                      child: Text(
                        "-",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  orderModel.remove(item);
                },
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    orderModel.items[item].toString(),
                  ),
                ),
              ),
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 10.0, right: 16.0, bottom: 10.0),
                      child: Text(
                        "+",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  orderModel.add(item);
                },
              ),
            ],
          );
  }
}

class _ItemSearchDelegate extends SearchDelegate<String> {
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.black,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('retailers')
          .document(orderModel.retailer.id)
          .collection('items')
          .orderBy('name')
          .where('name',
              isGreaterThanOrEqualTo: query.length == 0
                  ? query
                  : query[0].toUpperCase() + query.substring(1).toLowerCase())
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Text('Loading suggestions')
                ]),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot itemSnapshot = snapshot.data.documents[index];
              Item item = Item(itemSnapshot: itemSnapshot);
              return ListTile(
                title: Text(
                  item.name,
                ),
                trailing: AddToCartButton(orderModel, item),
              );
            },
            shrinkWrap: true,
            physics: ScrollPhysics(),
          );
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('retailers')
          .document(orderModel.retailer.id)
          .collection('items')
          .orderBy('name')
          .where('name',
              isGreaterThanOrEqualTo: query.length == 0
                  ? query
                  : query[0].toUpperCase() + query.substring(1).toLowerCase())
          .limit(25)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Text('Searching for your item')
                ]),
          );
        } else if (snapshot.data.documents.length == 0) {
          return Center(
              child: Text('The item you are looking for is not available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot itemSnapshot = snapshot.data.documents[index];
              Item item = Item(itemSnapshot: itemSnapshot);
              return ListTile(
                title: Text(
                  item.name,
                ),
                trailing: AddToCartButton(orderModel, item),
              );
            },
            shrinkWrap: true,
            physics: ScrollPhysics(),
          );
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Text('')
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }
}
