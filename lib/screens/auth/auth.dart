// import 'package:aewebshop/auth.dart';
// import 'package:aewebshop/controllers/user_controller.dart';
// import 'package:aewebshop/screens/homepage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_login/flutter_login.dart';
// import 'package:get/get.dart';

// class LoginPage extends StatelessWidget {
//   LoginPage({Key key}) : super(key: key);
//   Duration get loginTime => Duration(milliseconds: 2250);

//   Authentication auth = new Authentication();

//   Future<String> _authUser(LoginData data) {
//     print('Name: ${data.name}, Password: ${data.password}');
//     return Future.delayed(loginTime).then((_) async {
//       final String result = await auth.Login(data.name, data.password);
     
//       return result;
//     });
//   }

//   Future<String> _signInUser(LoginData data) {
//     return Future.delayed(loginTime).then((_) async {
//       final String result = await auth.SignUp(data.name, data.password);
//       return result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FlutterLogin(
//       title: 'WEB SHOP',
//       logo: 'assets/img/aelogo.png',
//       onLogin: _authUser,
//       onSignup: _signInUser,
//       onSubmitAnimationCompleted: () {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ));
//       },
//     );
//   }
// }
