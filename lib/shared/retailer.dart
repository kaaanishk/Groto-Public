// The most recent file
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Retailer {
  double distance;

  String id;
  String image;
  String name;
  String shop;
  double rating;
  int raters;
  String status;
  Map<String, String> address = {'firstline': '', 'secondline': '', 'city': ''};
  String phone;

  Retailer(
      {@required DocumentSnapshot retailerSnapshot,
      @required Map<String, dynamic> location}) {
    this.id = retailerSnapshot.documentID;
    this.image = retailerSnapshot.data['image'];
    this.name = retailerSnapshot.data['name'];
    this.shop = retailerSnapshot.data['shop'];
    this.phone = retailerSnapshot.data['phone'];
    this.status = retailerSnapshot.data['status'];
    this.address['firstline'] = retailerSnapshot.data['address']['firstline'];
    this.address['secondline'] = retailerSnapshot.data['address']['secondline'];
    this.address['city'] = retailerSnapshot.data['address']['city'];
    this.rating = retailerSnapshot.data['rating'].toDouble();
    this.raters = retailerSnapshot.data['raters'];
    double latitude = retailerSnapshot.data['point']['geopoint'].latitude;
    double longitude = retailerSnapshot.data['point']['geopoint'].longitude;
    this.distance = calculateDistance(
        location['lat'], location['lng'], latitude, longitude);
  }

  /// Only the Retailer ID is guaranteed to be unique
  bool operator ==(retailer) => retailer is Retailer && retailer.id == id;

  int get hashCode => id.hashCode;

  double calculateDistance(double latitude1, double longitude1,
      double latitude2, double longitude2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latitude2 - latitude1) * p) / 2 +
        c(latitude1 * p) *
            c(latitude2 * p) *
            (1 - c((longitude2 - longitude1) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
