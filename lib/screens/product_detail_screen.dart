import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
   static const routeName = '/product_detail_screen';


  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments as String;
    final Product lProduct =Provider.of<Products>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(title: Text(lProduct.title)),
      body:  SingleChildScrollView(
              child: Column(children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      child: Container(
                          child: Hero(
                            tag: lProduct.id,
                           child: Image.network(lProduct.imageUrl, fit: BoxFit.cover,)),
            height: 300,
            width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text("\$${lProduct.price}", style: TextStyle(color: Colors.grey, fontSize: 20, ),),
          SizedBox(height: 10),
          Container(child: Text('${lProduct.description}'),
          margin: EdgeInsets.symmetric(horizontal: 10),),
        ],
        ),
      ),
    );
  }
}