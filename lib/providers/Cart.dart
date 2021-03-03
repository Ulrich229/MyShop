import 'package:flutter/foundation.dart';

class CartItem{
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({@required this.id, @required this.title, @required this.price, @required this.quantity});
}

class Cart extends ChangeNotifier{
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items{
      return {..._items};
  }

int get itemCounter{
  return _items.length;
}

double get total{
  double tot = 0.0;
  _items.forEach((key, cartItem){ 
    tot += cartItem.price * cartItem.quantity;
  });
  return tot;
}
  void addItem(String productId, double price, String title){
    if (_items.containsKey(productId)){
      _items.update(productId, (cart) => CartItem(id: cart.id, title: cart.title, price: cart.price, quantity: (cart.quantity + 1)));
    }
    else{
      _items.putIfAbsent(productId, () => CartItem(id: DateTime.now().toString(), title: title , price: price, quantity: 1));
    }
    notifyListeners();
  }

  void removeSingleItem(String id){
    if(!_items.containsKey(id)){
      return;
    }
    if(_items[id].quantity > 1){
      _items.update(id, (ite){
        return CartItem(id: ite.id, title: ite.title, price: ite.price, quantity: ite.quantity - 1);
      });
    }
    else{
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
      }
}