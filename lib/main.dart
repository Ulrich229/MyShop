import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'providers/products.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/Cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(
          value: Auth()),
      ChangeNotifierProxyProvider<Auth, Products>(
       create: null,
       update:  (ctx, auth, previousProducts) => Products(auth.token, previousProducts == null? []: previousProducts.items),
      ),
      ChangeNotifierProvider.value(
          value: Cart(),),
      ChangeNotifierProxyProvider<Auth, Orders>(
       create: null,
       update:  (ctx, auth, previousOrders) => Orders(auth.token, previousOrders == null? []: previousOrders.orders),
      ),

    ],
          child: Consumer<Auth>(builder: (ctx, auth, _) => MaterialApp(
            home:auth.isAuth?ProductOverviewScreen(): AuthScreen(),
            theme: ThemeData(
              primaryColor: Colors.purpleAccent,
              accentColor: Colors.deepOrangeAccent,
              fontFamily: 'Lato'
            ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),

            },
      )) ,
    );
  }
}