import 'package:flutter/material.dart';

import '../screens/product_overview_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../models/customROute.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(height: 75,
          color: Colors.deepPurpleAccent,
          child: Center(child: Text("MENU", style: TextStyle(fontSize: 30, color: Colors.greenAccent),),),),
          SizedBox(height: 10,),
          DrawerItem('Show All Products', Icons.shop, (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
              return ProductOverviewScreen();
            }));
          }),
          Divider(),
          DrawerItem('Orders', Icons.credit_card, (){
            Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx)=> OrdersScreen(),));
          }),
           Divider(),
          DrawerItem('Manage Products', Icons.edit, (){
            Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
          }),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
 final String title;
 final IconData icon;
 final Function fonc;

DrawerItem(this.title, this.icon, this.fonc);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fonc ,
          child: 
ListTile(
  leading: Icon(icon),
  title: Text(title)
)
    );
  }
}
