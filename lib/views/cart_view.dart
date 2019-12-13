import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/order_model.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/shared/cart_item.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/item.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/widgets.dart';
import 'package:groto/views/connectivity_view.dart';
import 'package:groto/views/retailer_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValue = 'Delivery';

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cart',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(minimum: minimumSafeArea, child: cartView(context)),
        key: _scaffoldKey,
      ),
    );
  }

  Widget _placeOrderButton(BuildContext context, OrderModel orderModel) {
    if (orderModel.state == ViewState.BUSY) {
      return CupertinoActivityIndicator();
    } else if (orderModel.items.isEmpty) {
      return Container();
    } else if (dropdownValue == 'Pickup') {
      return StretchedCircularBlackButton(
        child: Text(
          'CONFIRM YOUR INFO',
        ),
        onPressed: () {
          Navigator.pushNamed(context, pickupBillView);
        },
      );
    } else {
      return StretchedCircularBlackButton(
        child: Text(
          'CONFIRM YOUR ADDRESS',
        ),
        onPressed: () {
          Navigator.pushNamed(context, billView);
        },
      );
    }
  }

  Widget cartView(BuildContext context) {
    return Consumer<OrderModel>(builder: (context, orderModel, child) {
      if (orderModel.state == ViewState.BUSY)
        return Center(
          child: CupertinoActivityIndicator(),
        );
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RetailerCard(retailer: orderModel.retailer),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.phone),
              ClickableText(
                onTap: () async {
                  String url = 'tel:' + orderModel.retailer.phone;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                text: orderModel.retailer.phone,
              ),
            ],
          ),
          Divider(color: Colors.black),
          Expanded(
            child: SingleChildScrollView(
              child: (orderModel.items.isEmpty)
                  ? Text('Cart is Empty')
                  : ListView.separated(
                      itemCount: orderModel.items.length,
                      itemBuilder: (context, index) {
                        Item item = orderModel.items.keys.elementAt(index);
                        int quantity = orderModel.items[item];
                        return CartItem(item, quantity);
                      },
                      physics: ScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      shrinkWrap: true,
                    ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Item Total:',
              ),
              Text(
                (orderModel.total / 100).toString(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Tax:',
              ),
              Text(
                orderModel.tax.toString(),
              )
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total:',
              ),
              Text(
                ((orderModel.total + orderModel.tax) / 100).toString(),
              )
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Shipping method: '),
              DropdownButton(
                value: dropdownValue,
                items: <String>['Delivery', 'Pickup']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
              ),
            ],
          ),
          _placeOrderButton(context, orderModel),
        ],
      );
    });
  }
}
