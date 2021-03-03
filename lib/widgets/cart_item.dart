import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id, this.productId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dismissible(
        key:  ValueKey(id),
        background: Container(color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 40,),
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerRight,),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
              child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(padding: EdgeInsets.all(10),
              child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text('$title'),
            subtitle: Text("\$ ${(price * quantity).toStringAsFixed(2)}"),
            trailing: Text("$quantity x"),
          )
        ),
        confirmDismiss: (direction){
          return showDialog(context: context, builder: (ctx) {
            return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you really want to Dismiss this item?'),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(ctx).pop(false);
              }, child: Text('No')),
              FlatButton(onPressed:  (){
                Navigator.of(ctx).pop(true);
              }, child: Text('Yes')),
            ],
          );
          });
        },
      ),
    );
  }
}