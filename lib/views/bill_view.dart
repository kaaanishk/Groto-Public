import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/order_model.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/shared/constants.dart';
import 'package:groto/shared/item.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/widgets.dart';
import 'package:groto/views/connectivity_view.dart';
import 'package:provider/provider.dart';

class BillView extends StatefulWidget {
  @override
  _BillViewState createState() => _BillViewState();
}

class _BillViewState extends State<BillView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _firstLineController;
  TextEditingController _secondLineController;
  TextEditingController _cityController;
  String dropdownValue = 'Cash';

  @override
  void initState() {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    _nameController = TextEditingController(text: userModel.name);
    _phoneController = TextEditingController(text: userModel.phone);
    _firstLineController =
        TextEditingController(text: userModel.address['firstline']);
    _secondLineController =
        TextEditingController(text: userModel.address['secondline']);
    _cityController = TextEditingController(text: userModel.address['city']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Your Order',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          minimum: minimumSafeArea,
          child: Form(
            child: ListView(
              children: <Widget>[
                _addressForm(),
                _billView(),
              ],
              shrinkWrap: true,
            ),
            key: _formKey,
          ),
        ),
        key: _scaffoldKey,
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      autofocus: false,
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '') return 'Name cannot be empty';
        return null;
      },
    );
  }

  Widget phoneField() {
    return TextFormField(
      autofocus: false,
      controller: _phoneController,
      maxLines: 1,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Phone (Enter 10 Digit)',
        icon: Icon(
          Icons.phone,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '') {
          return 'Phone cannot be empty';
        } else if (value.length != 10) {
          return 'Invalid phone number';
        } else
          return null;
      },
    );
  }

  Widget firstLineField() {
    return TextFormField(
      controller: _firstLineController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Flat, House no., Building, Company, Apartment:',
        icon: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '')
          return 'Field cannot be empty';
        else
          return null;
      },
    );
  }

  Widget secondLineField() {
    return TextFormField(
      controller: _secondLineController..text,
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Area, Colony, Street, Sector',
        icon: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '')
          return 'Field cannot be empty';
        else
          return null;
      },
    );
  }

  Widget cityField() {
    return TextFormField(
      controller: _cityController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'City',
        icon: Icon(
          Icons.location_city,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '')
          return 'City cannot be empty';
        else
          return null;
      },
    );
  }

  Widget _confirmOrder(BuildContext context, OrderModel orderModel) {
    return (orderModel.state == ViewState.BUSY)
        ? CupertinoActivityIndicator()
        : StretchedCircularBlackButton(
            child: Text('CONFIRM ORDER'),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                try {
                  await orderModel.createOrder(
                      user: Provider.of<UserModel>(context).user,
                      retailer: orderModel.retailer,
                      paymentMethod: dropdownValue,
                      userInfo: _getUserInfo(),
                      shippingMethod: 'Delivery');
                  showSnackBar(
                    scaffoldKey: _scaffoldKey,
                    text: 'Order placed successfully',
                  );
                  orderModel.reset();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      shopsView, (Route<dynamic> route) => false);
                } catch (e) {
                  throw e;
                }
              }
            },
          );
  }

  Widget _addressForm() {
    return Column(
      children: <Widget>[
        nameField(),
        phoneField(),
        firstLineField(),
        secondLineField(),
        cityField(),
        VerticalSpace(),
      ],
    );
  }

  Widget _billView() {
    return Consumer<OrderModel>(
      builder: (context, orderModel, _) {
        return Column(
          children: <Widget>[
            Divider(color: Colors.black),
            ListView.builder(
              itemCount: orderModel.items.length,
              itemBuilder: (context, index) {
                Item item = orderModel.items.keys.elementAt(index);
                int quantity = orderModel.items[item];
                return ListTile(
                    title: Text(item.name),
                    trailing: Text(quantity.toString()));
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            Divider(color: Colors.black),
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
            Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Pay on delivery: '),
                DropdownButton(
                  value: dropdownValue,
                  items: <String>['Cash', 'PayTM']
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
            _confirmOrder(context, orderModel),
          ],
        );
      },
    );
  }

  Map<String, dynamic> _getUserInfo() {
    return {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'address': {
        'firstline': _firstLineController.text,
        'secondline': _secondLineController.text,
        'city': _cityController.text
      }
    };
  }
}
