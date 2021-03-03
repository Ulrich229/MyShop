import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/drawer.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = '/user_product';

  Future<void> _refreshData (BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProduct();
    
    
  }

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Products"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.add, color: Colors.white,), onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        })
      ],),
      drawer: MainDrawer(),
      body: RefreshIndicator(
              onRefresh: () =>_refreshData(context),
              child: ListView.builder(itemBuilder: (ctx, i){
          return Column(children: <Widget>[
            UserProductItem(products.items[i].id,products.items[i].title, products.items[i].imageUrl),
            Divider(),
          ],);
        }, itemCount: products.items.length,),
      ),
    );
  }
}