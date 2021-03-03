import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/orders.dart' as ci;

class OrderItem extends StatefulWidget {
  final ci.OrderItem orders;

  OrderItem(this.orders);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expand? min((widget.orders.products.length * 2.0) + 150.0, 200.0): 95,
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          title: Text('\$${widget.orders.amount.toStringAsFixed(2)}'), 
          subtitle: Text('${widget.orders.date.day} /${widget.orders.date.month} /${widget.orders.date.year}'),
          trailing:  IconButton(icon: Icon(_expand? Icons.expand_less: Icons.expand_more), onPressed: (){
            setState(() {
              _expand = !_expand;
            });
          }),
        ),
       AnimatedContainer(
         duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expand? min((widget.orders.products.length * 2.0) + 50.0, 100.0): 0,
            child: ListView(children:
              widget.orders.products.map((prod){
               return Row(children: <Widget>[
                  Text(prod.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${prod.quantity} x \$${prod.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey),)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,);
              }).toList()
            ,) ,
          )
      ],
      ),
      );
  }
}