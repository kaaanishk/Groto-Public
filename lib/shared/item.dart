import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Item {
  String id = '';
  String image = '';
  String name = '';
  int price = 0;
  int weight = 0;
  double displayPrice = 0;

  Item({@required DocumentSnapshot itemSnapshot}) {
    this.id = itemSnapshot.documentID;
    this.image = itemSnapshot.data['image'];
    this.name = itemSnapshot.data['name'];
    this.price = itemSnapshot.data['price'];
    this.weight = itemSnapshot.data['weight'];
  }

  bool operator ==(item) => item is Item && item.id == id;

  int get hashCode => id.hashCode;
}
