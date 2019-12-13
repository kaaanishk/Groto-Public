import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:groto/shared/retailer.dart';
import 'package:groto/shared/user.dart';

class DatabaseService {
  final Geoflutterfire _geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;

  CollectionReference _orders;
  CollectionReference _retailers;
  CollectionReference _users;

  double _radius = 50;
  String _field = 'point';

  DatabaseService() {
    _users = _firestore.collection('users');
    _retailers = _firestore.collection('retailers');
    _orders = _firestore.collection('orders');
  }

  Future<void> updateUserPhoneOnDatabase(
      {@required String id, String phone}) async {
    try {
      await _users.document(id).updateData({'phone': phone});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserAddressOnDatabase(
      {@required String id, Map<String, String> address}) async {
    try {
      await _users.document(id).updateData({'address': address});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserDataOnDatabase(
      {@required String id, Map<String, dynamic> data}) async {
    try {
      await updateUserPhoneOnDatabase(id: id, phone: data['phone']);
      if (data.containsKey('address'))
        await updateUserAddressOnDatabase(id: id, address: data['address']);
    } catch (e) {
      throw e;
    }
  }

  Future<void> createOrder({
    @required User user,
    Retailer retailer,
    String paymentMethod,
    int total,
    int tax,
    String shippingMethod,
    Map<String, int> items,
    Map<String, dynamic> userInfo,
  }) async {
    try {
      DocumentReference _orderReference = await _orders.document();
      _orderReference.setData({
        'user': user.id,
        'retailer': retailer.id,
        'retailer_phone': retailer.phone,
        'order_status': 'created',
        'payment': paymentMethod,
        'shipping_method': shippingMethod,
        'total': total,
        'tax': tax,
        'items': items,
        'userinfo': userInfo,
        'shop': retailer.shop,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      });
      await _retailers
          .document(retailer.id)
          .collection('orders')
          .document(_orderReference.documentID)
          .setData({
        'user': user.id,
        'retailer': retailer.id,
        'retailer_phone': retailer.phone,
        'order_status': 'created',
        'payment': paymentMethod,
        'shipping_method': shippingMethod,
        'total': total,
        'tax': tax,
        'items': items,
        'userinfo': userInfo,
        'shop': retailer.shop,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw e;
    }
  }

  getShopsAroundUser({Map<String, dynamic> location}) {
    try {
      GeoFirePoint _center =
          _geo.point(latitude: location['lat'], longitude: location['lng']);
      Stream<List<DocumentSnapshot>> stream = _geo
          .collection(collectionRef: _retailers)
          .within(center: _center, radius: _radius, field: _field);
      return stream;
    } catch (e) {
      throw e;
    }
  }

  Future<String> fetchRetailer(String retailerId) async {
    try {
      DocumentSnapshot retailerSnapshot =
          await _retailers.document(retailerId).get();
      String phone = retailerSnapshot.data['phone'];
      print(retailerSnapshot);
      return phone;
    } catch (e) {
      throw e;
    }
  }

  updateItems(String retailerID, Map<String, int> items) async {
    try {
      for (String id in items.keys) {
        DocumentReference itemReference =
            _retailers.document(retailerID).collection('items').document(id);
        DocumentSnapshot itemSnapshot = await itemReference.get();
        int quantity = itemSnapshot.data['quantity'];
        await itemReference.updateData({'quantity': quantity - items[id]});
      }
    } catch (e) {
      throw e;
    }
  }
}
