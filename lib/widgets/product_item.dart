import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/Cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        child: Hero(
              tag: product.id,
              child: FadeInImage(placeholder: AssetImage('assets/images/5.1 product-placeholder.png'),
    fit: BoxFit.cover,
    image: NetworkImage(product.imageUrl),),
      ),
    onTap: (){
      Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
    },),
    
    footer: GridTileBar(title: Text(product.title, textAlign: TextAlign.center,),
    backgroundColor: Colors.black54,
    leading:Consumer<Product>(
        builder: (context, product, _){
          return IconButton(icon:product.isFavorite? Icon(Icons.favorite):Icon(Icons.favorite_border),
       onPressed: () async{
         try{
           product.toogleisFavorite(product.id, authData.token);
           }catch(_){
             Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fail to switch Favorite', textAlign: TextAlign.center),));
           }
       },
        color: Theme.of(context).accentColor,
        splashColor: Colors.yellow,);
        },
    ),
    trailing: IconButton(icon: Icon(Icons.shopping_cart),
     onPressed: (){
       cart.addItem(product.id, product.price, product.title);
       Scaffold.of(context).hideCurrentSnackBar();
       Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2),
    
       content: Text('${product.title} added to the cart'),
       action: SnackBarAction(label: 'UNDO', onPressed: () => cart.removeSingleItem(product.id)),
       ));
     },
      color: Theme.of(context).accentColor,
      splashColor: Colors.yellow,),
    ),
    
    );
  }
}