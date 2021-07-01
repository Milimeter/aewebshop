import 'package:aewebshop/model/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static const ID = "id";
  static const NAME = "name";
  static const ADDRESS = "address";
  static const NUMBER = "number";
  static const EMAIL = "email";
  static const CART = "cart";

  String id;
  String name;
  String email;
  String number;
  String address;
  List<CartItemModel> cart;

  UserData({this.id, this.name, this.email, this.cart});

  UserData.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.get(NAME) ?? "";
    email = snapshot.get(EMAIL) ?? "";
    id = snapshot.get(ID) ?? "";
    address = snapshot.get(ADDRESS) ?? "";
    number = snapshot.get(NUMBER) ?? "";
    cart = _convertCartItems(snapshot.get(CART) ?? []);
  }

  List<CartItemModel> _convertCartItems(List cartFomDb) {
    List<CartItemModel> _result = [];
    if (cartFomDb.length > 0) {
      cartFomDb.forEach((element) {
        _result.add(CartItemModel.fromMap(element));
      });
    }
    return _result;
  }

  List cartItemsToJson() => cart.map((item) => item.toJson()).toList();
}
