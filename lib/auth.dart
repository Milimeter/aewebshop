// import 'package:aewebshop/controllers/user_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class Authentication {
//   // static FirebaseAuth _auth = FirebaseAuth.instance;
//   UserController _userController = Get.find();
//   static User user;
//   static bool isLoggedIn = false;
//   final box = GetStorage();

//   Future<String> SignUp(String email, String password) async {
//     try {
//       UserCredential userCredential = await _userController.auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       user = userCredential.user;
//       _userController.firebaseUser.value = user;
//       _userController.addDataToDb(
//           email: email, password: password, uid: user.uid);
//       box.write("uid", user.uid);
//      // _userController.getuser;
//       isLoggedIn = true;
//       return null;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'User not exists';
//       } else if (e.code == 'wrong-password') {
//         return 'Password does not match';
//       }
//     }
//   }

//   Future<String> Login(String email, String password) async {
//     try {
//       _userController.signIn(email: email, password: password);
//       // UserCredential userCredential = await _userController.auth
//       //     .signInWithEmailAndPassword(email: email, password: password);
//       // user = userCredential.user;
//       // box.write("uid", user.uid);
//       // _userController.firebaseUser.value = user;
//       // _userController.getuser;
//       isLoggedIn = true;
//       return null;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'User not exists';
//       } else if (e.code == 'wrong-password') {
//         return 'Password does not match';
//       }
//     }
//   }

//   bool getCurrentUser() {
//     if (user.email != "") {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   bool get isLogged {
//     return isLoggedIn;
//   }

//   String get userEmail {
//     return user.email;
//   }

//   String get uid {
//     return user.uid;
//   }
// }
