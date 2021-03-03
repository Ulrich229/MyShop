import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './Cart.dart';
class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({@required this.id,@required this.amount,@required this.products,@required this.date});
}

class Orders extends ChangeNotifier{
   List<OrderItem> _orders = [];
   final String token;

   Orders(this.token, this._orders);

List<OrderItem> get orders {
  return _orders.toList();
}
Future<void> fetchOrders() async{
  final url = 'https://myshop-229.firebaseio.com/orders.json?auth=$token';
  final response =await http.get(url);
  final extratedData = json.decode(response.body) as Map <String, dynamic>;
  if(extratedData == null){
    return;
  }
  List <OrderItem>loadedData = [];
  extratedData.forEach((orderId, orderData){
    loadedData.add(OrderItem(id: orderId,
     amount: orderData['amount'],
      date: DateTime.parse(orderData['date']),
      products: (orderData['products'] as List<dynamic>).map((item){
        return CartItem(id: item['id'],
         title: item['title'],
          price: item['price'],
           quantity: item['quantity']);
      }).toList()
      ));
  });
  _orders = loadedData;
  

}

Future<void> addOrder(List<CartItem> products, double total) async{
  final url = 'https://myshop-229.firebaseio.com/orders.json?auth=$token';
  final timesTamp = DateTime.now();
  try{
    http.post(url, body: json.encode({
      'amount': total,
      'date': timesTamp.toIso8601String(),
      'products': products.map((prod) =>{
        'id': prod.id,
        'title': prod.title,
        'quantity': prod.quantity,
        'price': prod.price
      }).toList()
    }));
  } catch(error){
    throw error;
  }
  _orders.insert(0, OrderItem(id: timesTamp.toString(), amount: total, products: products, date: DateTime.now()));
  notifyListeners();
}
}