import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class OrderController extends GetxController {
  UserController _userController = Get.find();
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("users");
  RxList orders = [].obs;
  createOrder({
    // String orderPrice,
    var itemInfo,
  }) {
    print(_userController.userData.value.name);
    showLoading();
    var uuid = Uuid();
    // creating order
    FirebaseFirestore.instance.collection("orders").add({
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "status": "pending",
      "name": _userController.userData.value.name,
      "id": _userController.userData.value.id,
      "number": _userController.userData.value.number,
      "address": _userController.userData.value.address,
      "itemsInfo": itemInfo,
      "orderId": uuid.v1()
    }).then((value) {
      orders.clear();
      _firebaseFirestore.doc(_userController.userData.value.id).update({
        "cart": [],
      });
      dismissLoading();
      // _userController.userData.value.cart = null;
    });
    dismissLoading();
  }
}
