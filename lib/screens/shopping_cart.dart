import 'dart:convert';

import 'package:aewebshop/controllers/cart_controller.dart';
import 'package:aewebshop/controllers/order_controller.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/model/cart_item.dart';
import 'package:aewebshop/screens/widget/cart_item_widget.dart';
import 'package:aewebshop/utilities/loading.dart';
import 'package:aewebshop/widgets/custom_btn.dart';
import 'package:aewebshop/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingCartWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  final UserController userController = Get.find();
  final OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: CustomText(
                text: "Shopping Cart",
                size: 24,
                weight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Obx(() => Column(
                  children: userController.userData.value.cart
                      .map(
                        (cartItem) => CartItemWidget(
                          cartItem: cartItem,
                        ),
                      )
                      .toList(),
                )),
          ],
        ),
        Positioned(
          bottom: 30,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: CustomButton(
                // text:
                //     "Order (\$${cartController.totalCartPrice.value.toStringAsFixed(2)})",
                text: "Order",
                onTap: () {
                  // // convert each item to a string by using JSON encoding
                  final jsonList = orderController.orders
                      .map((item) => jsonEncode(item))
                      .toList();

                  // // using toSet - toList strategy
                  final uniqueJsonList = jsonList.toSet().toList();

                  // // convert each item back to the original form using JSON decoding
                  final myOrders =
                      uniqueJsonList.map((item) => jsonDecode(item)).toList();
                  print(myOrders);

                  orderController.createOrder(
                    itemInfo: myOrders,
                  );
                }),
          ),
        ),
        Positioned(
          top: 30,
          left: 30,
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(4, 8),
                    color: Colors.grey[200],
                  ),
                ]),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
