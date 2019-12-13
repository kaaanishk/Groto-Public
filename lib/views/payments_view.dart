//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:groto/shared/item.dart';
//import 'package:groto/shared/widgets.dart';
//
//class Order {
//  Order(this.orderID, this.retailerID, this.userID, this.total, this.cart);
//
//  String orderID;
//  String retailerID;
//  String userID;
//  int total = 0;
//  Map<Item, int> cart;
//}
//
//class PaymentsView extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: scaffoldTitle('Payments'),
//        elevation: 0.0,
//      ),
//      backgroundColor: Colors.white,
//      body: SafeArea(
//        minimum: EdgeInsets.all(12.0),
//        child: Column(
//          children: <Widget>[
//            Text(
//              'Payment Methods',
//              textScaleFactor: 1.3,
//            ),
//            ListView(
//              children: <Widget>[
//                ListTile(
//                  title: Text('Cash'),
//                  onTap: () {},
//                ),
//                ListTile(
//                  title: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text(
//                        'Add Payment Method',
//                      ),
//                      Icon(
//                        Icons.arrow_forward_ios,
//                      )
//                    ],
//                  ),
//                  onTap: () {
//                    Navigator.pushNamed(context, '/add_payment_method');
//                  },
//                ),
//              ],
//              shrinkWrap: true,
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class AddPaymentView extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: scaffoldTitle(),
//        brightness: Brightness.light,
//        elevation: 0.0,
//        backgroundColor: Colors.white,
//        iconTheme: IconThemeData(
//          color: Colors.black,
//        ),
//      ),
//      backgroundColor: Colors.white,
//      body: SafeArea(
//        minimum: EdgeInsets.all(12.0),
//        child: ListView(
//          children: <Widget>[
//            ListTile(
//              title: Text('Credit/Debit Card'),
//              onTap: () {
//                Navigator.pushNamed(context, '/add_card');
//              },
//            ),
//            ListTile(
//              title: Text('PayTM'),
//            ),
//            ListTile(
//              title: Text('PhonePe'),
//            ),
//            ListTile(
//              title: Text('GPay'),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class AddCardView extends StatefulWidget {
//  @override
//  _AddCardViewState createState() => _AddCardViewState();
//}
//
//class _AddCardViewState extends State<AddCardView> {
//  TextEditingController _cardController;
//  TextEditingController _expiryController;
//  TextEditingController _cvvController;
//  TextEditingController _nameController;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: scaffoldTitle(''),
//        brightness: Brightness.light,
//        elevation: 0.0,
//        backgroundColor: Colors.white,
//        iconTheme: IconThemeData(
//          color: Colors.black,
//        ),
//      ),
//      backgroundColor: Colors.white,
//      body: SafeArea(
//        minimum: EdgeInsets.all(12.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'We accept Credit and Debit Cards from VISA, Mastercard, and Rupay',
//            ),
//            _cardField(_cardController),
//            Row(
//              children: <Widget>[
//                Flexible(child: _expiryField(_expiryController)),
//                Flexible(child: _cvvField(_cvvController)),
//              ],
//            ),
//            _nameField(_nameController),
//            _addCardButton(context),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _cardField(TextEditingController _cardController) {
//    return TextFormField(
//      controller: _cardController,
//      maxLines: 1,
//      maxLength: 16,
//      keyboardType: TextInputType.number,
//      autofocus: true,
//      decoration: InputDecoration(
//        hintText: 'Card number',
//      ),
//      validator: (value) {
//        if (value.isEmpty)
//          return 'Card cannot be empty';
//        else
//          return null;
//      },
//    );
//  }
//
//  Widget _expiryField(TextEditingController _expiryController) {
//    return TextFormField(
//      controller: _expiryController,
//      maxLength: 4,
//      maxLines: 1,
//      keyboardType: TextInputType.number,
//      autofocus: true,
//      decoration: InputDecoration(
//        hintText: 'Expiry date (MM/YY)',
//      ),
//      validator: (value) {
//        if (value.isEmpty)
//          return 'Expiry cannot be empty';
//        else
//          return null;
//      },
//    );
//  }
//
//  Widget _cvvField(TextEditingController _cvvController) {
//    return TextFormField(
//      controller: _cvvController,
//      maxLength: 3,
//      maxLines: 1,
//      keyboardType: TextInputType.number,
//      autofocus: true,
//      decoration: InputDecoration(
//        hintText: 'CVV',
//      ),
//      validator: (value) {
//        if (value.isEmpty)
//          return 'CVV cannot be empty';
//        else
//          return null;
//      },
//    );
//  }
//
//  Widget _nameField(TextEditingController nameController) {
//    return TextFormField(
//      controller: nameController,
//      maxLines: 1,
//      keyboardType: TextInputType.text,
//      autofocus: true,
//      decoration: InputDecoration(
//        hintText: 'Name on Card',
//      ),
//      validator: (value) {
//        if (value.isEmpty)
//          return 'Name cannot be empty';
//        else
//          return null;
//      },
//    );
//  }
//
//  Widget _addCardButton(BuildContext context) {
//    return MaterialButton(
//      minWidth: double.infinity,
//      elevation: 0.0,
//      color: Colors.black,
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
//      child: Text('Add Card', style: TextStyle(color: Colors.white)),
//      onPressed: () {},
//    );
//  }
//}
//
////  void processOrder(Order order) async {
////    print("Processing");
////    print(order.userID);
////    DocumentReference userDocument =
////    Firestore.instance.collection('USERS').document(order.userID);
////    DocumentReference retailerDocument =
////    Firestore.instance.collection('RETAILERS').document(order.retailerID);
////    String time = DateTime
////        .now()
////        .millisecondsSinceEpoch
////        .toString();
////    userDocument.collection('ORDERS').document(order.orderID).setData({
////      'USERID': order.userID,
////      'RETAILERID': order.retailerID,
////      'TOTAL': order.total,
////      'TIME': time
////    });
////    retailerDocument.collection('ORDERS').document(order.orderID).setData({
////      'USERID': order.userID,
////      'TOTAL': order.total,
////      'RETAILERID': order.retailerID,
////      'TIME': time
////    });
