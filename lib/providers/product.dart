import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id, 
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toogleisFavorite(String id, String token) async{
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://myshop-229.firebaseio.com/products/$id.json?auth=$token';
    try{
      await http.patch(url, body: json.encode({
        'isFavorite': isFavorite
      }));
    } catch(error){
      isFavorite = !isFavorite;
      throw error;
    }
  }
}