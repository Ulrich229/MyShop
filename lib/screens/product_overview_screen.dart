import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_Grid.dart';
import '../providers/Cart.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../widgets/drawer.dart';
import '../providers/products.dart';


enum Displayfavs{
  Favorites,
  All
}

class ProductOverviewScreen extends StatefulWidget {

static String routeName = "/product_overview_screen";
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}
  
class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavs = false;
  bool _isLoading = false; 
 // bool _isInit = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false).fetchAndSetProduct().then((_){
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Shop"),
      actions: <Widget>[
        PopupMenuButton(onSelected: (Displayfavs value){
          setState(() {
             if(value == Displayfavs.Favorites){
              _showFavs = true;
          }
          else{
              _showFavs = false;
          }
          });
         
        },
        icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
          PopupMenuItem(child: Text("Only Favorites"), value: Displayfavs.Favorites,),
          PopupMenuItem(child: Text("Show all"), value: Displayfavs.All,)
        ]),
        Consumer<Cart> (builder: (_, cart, ch) {
          return Badge(child: ch,
              value: cart.itemCounter.toString(),
             );
        },
        child: IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white,),
             onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName))
        )],
      ),
      drawer: MainDrawer(),
      body:_isLoading? Center(
        child: CircularProgressIndicator(),
      ) : ProductGrid(_showFavs),
    );
  }
}
