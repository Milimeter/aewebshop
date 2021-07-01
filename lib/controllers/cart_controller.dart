import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/model/cart_item.dart';
import 'package:aewebshop/model/product.dart';
import 'package:aewebshop/model/user.dart';
import 'package:aewebshop/screens/widget/auth_wrapper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  RxDouble totalCartPrice = 0.0.obs;
  UserController userController = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void onReady() {
    super.onReady();
    ever(userController.userData, changeCartTotalPrice);
  }

  dynamic getProductDetails(String productId) async {
    try {
      final DocumentSnapshot querySnapshot =
          await firestore.collection('artikli').doc(productId).get();
      if (querySnapshot.data() != null) {
        return ProductDetailModel.fromMap(querySnapshot.data());
      }
      print(" --- product details " + querySnapshot.data().toString());
      // return ProductModel.fromMap(querySnapshot)
    } catch (e) {
      print("error from get product details");
      print(e);
      return null;
    }
  }

  void addProductToCart(ProductDetailModel product) {
    try {
      if (userController?.userData?.value?.name == null) {
        // Get.defaultDialog(
        //     titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        //     title: "Authentification",
        //     content: AuthWrapper(),
        //     barrierDismissible: true);
        BotToast.showWidget(
            toastBuilder: (_) => Center(
                  child: AuthWrapper(),
                ));
        return;
      }
      if (_isItemAlreadyAdded(product)) {
        Get.snackbar("Check your cart", "${product.name} is already added");
      } else {
        String itemId = Uuid().toString();
        userController.updateUserData({
          "cart": FieldValue.arrayUnion([
            {
              "id": itemId,
              "productId": product.id,
              "name": product.name,
              "quantity": 1,
              "price": product.price,
              "image": product.image,
              "cost": product.price
            }
          ])
        });
        Get.snackbar("Item added", "${product.name} was added to your cart");
      }
    } catch (e) {
      Get.snackbar("Error", "Cannot add this item");
      debugPrint(e.toString());
    }
  }

  void removeCartItem(CartItemModel cartItem) {
    try {
      userController.updateUserData({
        "cart": FieldValue.arrayRemove([cartItem.toJson()])
      });
    } catch (e) {
      Get.snackbar("Error", "Cannot remove this item");
      debugPrint(e.message);
    }
  }

  changeCartTotalPrice(UserData userModel) {
    totalCartPrice.value = 0.0;
    if (userModel.cart.isNotEmpty) {
      userModel.cart.forEach((cartItem) {
        totalCartPrice += cartItem.cost;
      });
    }
  }

  bool _isItemAlreadyAdded(ProductDetailModel product) =>
      userController.userData.value.cart
          .where((item) => item.productId == product.id)
          .isNotEmpty;

  void decreaseQuantity(CartItemModel item) {
    if (item.quantity == 1) {
      removeCartItem(item);
    } else {
      removeCartItem(item);
      item.quantity--;
      userController.updateUserData({
        "cart": FieldValue.arrayUnion([item.toJson()])
      });
    }
  }

  void increaseQuantity(CartItemModel item) {
    removeCartItem(item);
    item.quantity++;
    userController.updateUserData({
      "cart": FieldValue.arrayUnion([item.toJson()])
    });
  }
}
