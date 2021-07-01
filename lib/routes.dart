import 'package:aewebshop/product_detail.dart';
import 'package:aewebshop/screens/homepage.dart';
import 'package:aewebshop/screens/orders.dart';
import 'package:aewebshop/screens/preartiki.dart';
import 'package:aewebshop/screens/shopping_cart.dart';
import 'package:aewebshop/screens/widget/cart_item_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();
  static String home = "/";
  static String shop = "/shop";
  static String cart = "/korpa";
  static String orders = "/narudzbe";
  static String product = "/artikal/:id";
  static Handler _homeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());
  static Handler _ordersHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          UserOrder());
  static Handler _shopHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          PregledArtikala()); // this one is for one paramter passing...

  // lets create for two parameters tooo...
  static Handler _cartHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ShoppingCartWidget());
  static Handler _productHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          DetailWidget(productId: params['id'][0]));
  // ok its all set now .....
  // now lets have a handler for passing parameter tooo....

  static void setupRouter() {
    router.define(
      home,
      handler: _homeHandler,
    );
    router.define(
      shop,
      handler: _shopHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      orders,
      handler: _ordersHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      cart,
      handler: _cartHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(product, handler: _productHandler);
  }
}
