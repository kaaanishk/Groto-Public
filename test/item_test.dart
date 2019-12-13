import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groto/shared/item.dart';
import 'package:mockito/mockito.dart';

class ItemDocumentSnapshotMock extends Mock implements DocumentSnapshot {
  final String documentID;
  final Map<String, dynamic> data;

  ItemDocumentSnapshotMock(this.documentID, this.data);
}

void main() {
  group('Item', () {
    test('Test whether item data is parsed correctly', () {
      Map<String, dynamic> data = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Item X',
        'price': 10,
        'weight': 10
      };
      var itemSnapshot = ItemDocumentSnapshotMock('QVSePFSs9Lnqr9gRPInU', data);
      Item item = Item(itemSnapshot: itemSnapshot);
      expect(item.id, 'QVSePFSs9Lnqr9gRPInU');
      expect(item.image, 'https://via.placeholder.com/150');
      expect(item.name, 'Item X');
      expect(item.price, 10);
      expect(item.weight, 10);
    });

    test('Test two items are equal', () {
      Map<String, dynamic> data = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Item X',
        'price': 10,
        'weight': 10
      };
      var itemSnapshot = ItemDocumentSnapshotMock('QVSePFSs9Lnqr9gRPInU', data);
      Item item1 = Item(itemSnapshot: itemSnapshot);
      Item item2 = Item(itemSnapshot: itemSnapshot);
      expect(item1 == item2, true);
    });

    test('Test two items are not equal', () {
      Map<String, dynamic> data1 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Item X',
        'price': 10,
        'weight': 10
      };
      Map<String, dynamic> data2 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Item Y',
        'price': 0,
        'weight': 0
      };
      var itemSnapshot1 =
      ItemDocumentSnapshotMock('QVSePFSs9Lnqr9gRPInU', data1);
      var itemSnapshot2 =
      ItemDocumentSnapshotMock('QVSePFSs9Lnqr9gRPInP', data2);
      Item item1 = Item(itemSnapshot: itemSnapshot1);
      Item item2 = Item(itemSnapshot: itemSnapshot2);
      expect(item1 != item2, true);
    });

  });
}
