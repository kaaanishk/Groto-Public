import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groto/shared/retailer.dart';
import 'package:mockito/mockito.dart';

class RetailerDocumentSnapshotMock extends Mock implements DocumentSnapshot {
  final String documentID;
  final Map<String, dynamic> data;

  RetailerDocumentSnapshotMock(this.documentID, this.data);
}

void main() {
  group('Retailer', () {
    test('Test whether retailer data is parsed correctly', () {
      Map<String, dynamic> data = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'open',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
        'point': {'geopoint': GeoPoint(27.0, 74)},
      };
      Map<String, dynamic> location = {'lat': 27.0, 'lng': 74.9};
      var retailerSnapshot = RetailerDocumentSnapshotMock('QVSePFSs9Ln', data);
      Retailer retailer =
          Retailer(retailerSnapshot: retailerSnapshot, location: location);
      expect(retailer.id, 'QVSePFSs9Ln');
      expect(retailer.image, 'https://via.placeholder.com/150');
      expect(retailer.name, 'Person A');
      expect(retailer.shop, 'Shop X');
      expect(retailer.phone, '1234567890');
      expect(
          retailer.address, {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'});
      expect(retailer.address['firstline'], 'X');
      expect(retailer.address['secondline'], 'Y');
      expect(retailer.address['city'], 'Z');
      expect(retailer.rating, 4.5);
      expect(retailer.raters, 30);
    });

    test('Check whether retailers are the same', () {
      // Only ids are guaranteed to be unique
      //TODO if ids are same all other field should be same
      Map<String, dynamic> data1 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'open',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
        'point': {'geopoint': GeoPoint(27.0, 74)},
      };
      Map<String, dynamic> data2 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person B',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'open',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
        'point': {'geopoint': GeoPoint(27.0, 74)},
      };
      Map<String, dynamic> location = {'lat': 27.0, 'lng': 74.9};
      var retailerSnapshot1 = RetailerDocumentSnapshotMock('QVSePFSs9', data1);
      var retailerSnapshot2 = RetailerDocumentSnapshotMock('QVSePFSs9', data2);
      Retailer retailer1 =
          Retailer(retailerSnapshot: retailerSnapshot1, location: location);
      Retailer retailer2 =
          Retailer(retailerSnapshot: retailerSnapshot2, location: location);
      expect(retailer1 == retailer2, true);
    });

    test('Check whether retailers are not the same', () {
      //TODO if ids are unique, location and phone cannot be same
      Map<String, dynamic> data1 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'open',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
        'point': {'geopoint': GeoPoint(27.0, 74)},
      };
      Map<String, dynamic> location1 = {'lat': 27.4, 'lng': 75.9};
      Map<String, dynamic> data2 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'created',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
        'point': {'geopoint': GeoPoint(27.0, 74)},
      };
      Map<String, dynamic> location2 = {'lat': 27.0, 'lng': 74.9};

      var retailerSnapshot1 = RetailerDocumentSnapshotMock('QVSePFSs9', data1);
      var retailerSnapshot2 = RetailerDocumentSnapshotMock('QVSePFSsX', data2);

      Retailer retailer1 =
          Retailer(retailerSnapshot: retailerSnapshot1, location: location1);
      Retailer retailer2 =
          Retailer(retailerSnapshot: retailerSnapshot2, location: location2);
      expect(retailer1 == retailer2, false);
    });
  });
}
