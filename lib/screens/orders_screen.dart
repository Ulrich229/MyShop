import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as ord;
import '../widgets/drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: MainDrawer(),
      body: FutureBuilder(future: Provider.of<Orders>(context).fetchOrders(),
      builder: (context, snapShtot){
        if(snapShtot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return Consumer<Orders>(builder: (ctx, orderData, child){
            return ListView.builder(itemCount: orderData.orders.length,
      itemBuilder:(ctx, i){
        return ord.OrderItem(orderData.orders[i]);
      } , );
          },);
        }
      },)
    );
  }
}

/* :, */