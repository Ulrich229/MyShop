import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';


class Products with ChangeNotifier{
List <Product> _items =  [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

final String authToken;
Products(this.authToken, this._items);

Product findById (id){
  return items.firstWhere((prod)=> prod.id == id);
}

 List <Product> get items{
   return _items.toList();
 }

 List <Product> get favorites{
   return items.where((test)=> test.isFavorite).toList();
 } 

 Future<void> fetchAndSetProduct() async{
   print("ici");
   final url = 'https://myshop-229.firebaseio.com/products.json?auth=$authToken';
   try{
     final response = await http.get(url);
     final extratedData = json.decode(response.body) as Map<String, dynamic>;
     final List<Product> loaded = [];
     extratedData.forEach((prodId, prodData){
       loaded.add(Product(
         id: prodId,
         description: prodData['description'],
         title: prodData['title'],
         imageUrl: prodData['imageUrl'],
         price: prodData['price'],
         isFavorite: prodData['isFavorite']
       ));
       _items = loaded;
     });
   }catch (error){
     throw error;
   }
   notifyListeners();
 }


Future <void> addProduct(Product product) async{
   final url = 'https://myshop-229.firebaseio.com/products.json';
   try{
 final response = await http.post(url, body: json.encode({
    'title': product.title,
    'description': product.description,
    'imageUrl': product.imageUrl,
    'price': product.price,
    'isFavortite': product.isFavorite
  }));
     _items.add(Product(id: json.decode(response.body)['name'],
      title: product.title,
       description: product.description,
        price: product.price,
         imageUrl: product.imageUrl));
   notifyListeners();
   }catch(error){
     throw error;
   }
 
 }

 Future <void> updateProduct(String id, Product prod) async{
   final url = 'https://myshop-229.firebaseio.com/products/$id.json';
   http.patch(url, body: json.encode({
      'title': prod.title,
    'description': prod.description,
    'imageUrl': prod.imageUrl,
    'price': prod.price,
    'isFavortite': prod.isFavorite
   }));
   final prodIndex = _items.indexWhere((ppp) => ppp.id == id);
   _items[prodIndex] = prod;
 }

 Future<void> removeProduct(String id) async{
   final url = 'https://myshop-229.firebaseio.com/products/$id';
   final prodIndex = _items.indexWhere((prod) => prod.id == id);
   var prod = _items[prodIndex];
   _items.removeWhere((prod) => prod.id == id);
   notifyListeners();
     final response = await http.delete(url);
     if(response.statusCode >= 400){
      _items.add(prod);
      notifyListeners();
      throw HttpException("Can't delete that item");
     }
 }
}