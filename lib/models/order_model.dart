import 'package:flutter/cupertino.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/base_model.dart';
import 'package:groto/services/database_service.dart';
import 'package:groto/shared/item.dart';
import 'package:groto/shared/retailer.dart';
import 'package:groto/shared/user.dart';

class OrderModel extends BaseModel {
  Map<Item, int> items = {};
  int total = 0;
  int tax = 0;
  Retailer retailer;
  DatabaseService _database = DatabaseService();

  void add(Item item) {
    if (!items.containsKey(item)) {
      items[item] = 0;
    }
    items[item]++;
    total = total + item.price;
    notifyListeners();
  }

  void remove(Item item) {
    if (items[item] > 1) {
      items[item]--;
    } else {
      items.remove(item);
    }
    total = total - item.price;
    notifyListeners();
  }

  Future<String> createOrder(
      {@required User user,
      @required Retailer retailer,
      @required String shippingMethod,
      String paymentMethod,
      Map<String, dynamic> userInfo}) async {
    setState(ViewState.BUSY);
    // Create Order on Backend
    try {
      await _database.updateUserDataOnDatabase(id: user.id, data: userInfo);
      await _database.createOrder(
        user: user,
        retailer: retailer,
        paymentMethod: paymentMethod,
        total: total,
        tax: tax,
        items: _getItemStringMap(),
        shippingMethod: shippingMethod,
        userInfo: userInfo,
      );
      await _database.updateItems(retailer.id, _getItemIdMap());
      return 'Order placed successfully';
    } catch (e) {
      throw 'Order could not be placed';
    } finally {
      setState(ViewState.IDLE);
    }
  }

  void reset() {
    items = {};
    total = 0;
    tax = 0;
  }

  Map<String, int> _getItemStringMap() {
    Map<String, int> items = {};
    for (Item item in this.items.keys) {
      items[item.name] = this.items[item];
    }
    print(items);
    return items;
  }

  Map<String, int> _getItemIdMap() {
    Map<String, int> items = {};
    for (Item item in this.items.keys) {
      items[item.id] = this.items[item];
    }
    return items;
  }
}
