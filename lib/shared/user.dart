import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String email;
  String phone;
  Map<String, String> address = {'firstline': '', 'secondline': '', 'city': ''};

  User({@required DocumentSnapshot userSnapshot}) {
    this.id = userSnapshot.documentID;
    this.name = userSnapshot.data['name'];
    this.email = userSnapshot.data['email'];
    this.phone = userSnapshot.data['phone'];
    this.address['firstline'] = userSnapshot.data['address']['firstline'];
    this.address['secondline'] = userSnapshot.data['address']['secondline'];
    this.address['city'] = userSnapshot.data['address']['city'];
  }

  User.fromMap({@required Map<String, dynamic> data}) {
    this.id = data['id'];
    this.name = data['name'];
    this.email = data['email'];
    this.phone = data['phone'];
    this.address['firstline'] = data['address']['firstline'];
    this.address['secondline'] = data['address']['secondline'];
    this.address['city'] = data['address']['city'];
  }
}
