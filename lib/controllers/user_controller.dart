import 'package:aewebshop/model/user.dart';
import 'package:aewebshop/screens/auth/login_screen.dart';
import 'package:aewebshop/screens/homepage.dart';
import 'package:aewebshop/utilities/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  Rx<User> firebaseUser;
  Rx<UserData> userData = UserData().obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  final box = GetStorage();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController fullnameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneNoTextEditingController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  String usersCollection = "users";

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      userData.bindStream(listenToUser());
      Get.offAll(() => HomePage());
    }
  }

  get getuser => userData.bindStream(listenToUser());

  emailAndPasswordSignIn() async {
    showLoading();
    try {
      await auth
          .signInWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((result) {
        userData.bindStream(listenToUser());
        print("=========================== user sign in =================");
        _clearControllers();
        // Get.offAll(HomePage());
      });
    } catch (e) {
      dismissLoading();
      var error = e.toString().split("]");
      var displayError = error[1];
      Get.snackbar(
        "Error",
        displayError,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 5),
      );
    }
  }

  void signUp() async {
    showLoading();
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((result) {
        String _userId = result.user.uid;
        _addUserToFirestore(_userId);
        _clearControllers();
      });
    } catch (e) {
      dismissLoading();
      var error = e.toString().split("]");
      var displayError = error[1];
      Get.snackbar(
        "Error",
        displayError,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 5),
      );
    }
  }

  _addUserToFirestore(String userId) {
    FirebaseFirestore.instance.collection(usersCollection).doc(userId).set({
      "name": fullnameTextEditingController.text.trim(),
      "id": userId,
      "email": emailTextEditingController.text.trim(),
      "password": passwordTextEditingController.text.trim(),
      "number": "",
      "address": "",
      "cart": []
    }).then((_) {
      // userData.bindStream(listenToUser());
      print(
          "===========================  user uploaded to database =================");
      // Get.offAll(HomePage());
    });
  }

  Stream<UserData> listenToUser() {
    print("=========================== Listen to user =================");
    print(firebaseUser.value.uid);
    print(firebaseUser.value.email);
    User user = auth.currentUser;
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(firebaseUser.value.uid)
        .snapshots()
        .map((snapshot) => UserData.fromSnapshot(snapshot));
  }

  updateUserData(Map<String, dynamic> data) {
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(firebaseUser.value.uid)
        .update(data);
  }

  _clearControllers() {
    emailTextEditingController.clear();
    passwordTextEditingController.clear();
    fullnameTextEditingController.clear();
    phoneNoTextEditingController.clear();
    usernameTextEditingController.clear();
  }

  signOut() async {
    try {
      await auth.signOut();
      // Get.offAll(LoginScreen());
      return true;
    } catch (e) {
      return false;
    }
  }
}
