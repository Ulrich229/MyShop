import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import'../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
 final String imageUrl;
 final String title;

 UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      trailing: Container(width: 100,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,), onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
            }),
            IconButton(icon: Icon(Icons.delete, color: Theme.of(context).errorColor,), onPressed: () async {
              try{
              await Provider.of<Products>(context).removeProduct(id);
              } catch(_){
                scaffold.showSnackBar(SnackBar(content: Text('Failed to delete item', textAlign: TextAlign.center,)));
              }
            }),
          ],
        ),
      ),
    );
  }
}