import 'package:flutter/material.dart';
import 'package:groto/models/order_model.dart';
import 'package:groto/shared/item.dart';
import 'package:groto/views/item_view.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  CartItem(this.item, this.quantity);

  Item item;
  int quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text((item.price / 100).toString()),
      trailing: AddToCartButton(Provider.of<OrderModel>(context), item)
    );
  }
}
