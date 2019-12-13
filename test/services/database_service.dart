import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groto/shared/item.dart';
import 'package:mockito/mockito.dart';

class ItemDocumentSnapshotMock extends Mock implements DocumentSnapshot {
  final String documentID;
  final Map<String, dynamic> data;

  ItemDocumentSnapshotMock(this.documentID, this.data);
}
