import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  UserController _userController = Get.find();

  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("users");
  RxList<Map<dynamic, dynamic>> orders = [{}].obs;
  createOrder({String orderPrice, var itemInfo}) {
    print(itemInfo);
    showLoading();
    // creating order
    FirebaseFirestore.instance.collection("orders").add({
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "status": "pending",
      "name": _userController.userData.value.name,
      "id": _userController.userData.value.id,
      "orderPrice": orderPrice.toString(),
      "itemsInfo": itemInfo,
    }).then((value) {
      _firebaseFirestore.doc(_userController.userData.value.id).update({
        "cart": [],
      }).catchError((err) {
        print(err + " error from get orders");
      });
      dismissLoading();
      // _userController.userData.value.cart = null;
    });
    dismissLoading();
  }
}
