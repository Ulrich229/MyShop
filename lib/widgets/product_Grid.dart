import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavs;

  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Products>(context);
    final produits =showFavs? prod.favorites : prod.items;
    return GridView.builder(padding: const EdgeInsets.all(10)
    ,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, 
     childAspectRatio: 1.2,
     crossAxisSpacing: 10,
     mainAxisSpacing: 10), 
    itemBuilder: (ctx, i){
      return ChangeNotifierProvider.value(
        value: produits[i],
      child: ProductItem());
    },
    itemCount: produits.length,);
  }
}