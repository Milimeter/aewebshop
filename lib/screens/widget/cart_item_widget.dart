import 'package:aewebshop/controllers/cart_controller.dart';
import 'package:aewebshop/controllers/order_controller.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/model/cart_item.dart';
import 'package:aewebshop/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final CartController cartController = Get.find();
  final UserController userController = Get.find();
  final OrderController _orderController = Get.find();

  CartItemWidget({Key key, this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    _orderController.orders.add({
      "image": cartItem.image,
      "name": cartItem.name,
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            cartItem.image,
            width: 80,
          ),
        ),
        Expanded(
            child: Wrap(
          direction: Axis.vertical,
          children: [
            Container(
                padding: EdgeInsets.only(left: 14),
                child: CustomText(
                  text: cartItem.name,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      cartController.decreaseQuantity(cartItem);
                    }),
              ],
            )
          ],
        )),
      ],
    );
  }
}
