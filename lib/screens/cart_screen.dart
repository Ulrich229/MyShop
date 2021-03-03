import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
    Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return  Scaffold(
        appBar: AppBar(
          title: Text('Your Orders',
           style: Theme.of(context).textTheme.title,
        ),
        ) ,
        body: Column(children: <Widget>[
          Padding(padding: EdgeInsets.all(15), 
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Text("Total", style: TextStyle(fontSize: 20)),
          Spacer(),
          Chip(label: Text("\$${cart.total.toStringAsFixed(2)}"), backgroundColor: Theme.of(context).primaryColor,), 
          OrderButton(cart: cart)
          ],
          ),
          ),
          Expanded(child: ListView.builder(itemBuilder:(ctx, i) {
            return ci.CartItem(cart.items.values.toList()[i].id,
            cart.items.keys.toList()[i],
             cart.items.values.toList()[i].title,
              cart.items.values.toList()[i].price,
               cart.items.values.toList()[i].quantity);
          } ,
           itemCount: cart.itemCounter,))
        ],
        ),
        );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(child:_isLoading? Text("PLACE", style: TextStyle(color: Theme.of(context).primaryColor),): Text("PLACE ORDER", style: TextStyle(color: Theme.of(context).primaryColor),),
    onPressed:widget.cart.total == 0.0? null:(){
      try{
        setState(() {
          _isLoading = true;
        }); 
        Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.total);
      }catch(_){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Unable to add the order')));
      }
      widget.cart.clear();
    },
    );
  }
}
