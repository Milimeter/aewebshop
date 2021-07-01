import 'package:aewebshop/constants/sizes.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginContainer extends StatefulWidget {
  String type;

  LoginContainer({this.type});

  @override
  _LoginContainerState createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = WindowSizes.size(width);
    return Container(
      width: size == Sizes.Large ? Get.width * 0.3 : Get.width * 0.6,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size == Sizes.Large ? 100.0 : 20),
            Container(
              height: size == Sizes.Large ? 55 : 50,
              child: TextFormField(
                controller: _userController.emailTextEditingController,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.red[800]),
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[800], width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[800], width: 0.5),
                  ),
                  hintStyle: TextStyle(color: Colors.red[800]),
                  labelStyle: TextStyle(color: Colors.red[800]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              height: size == Sizes.Large ? 55 : 50,
              child: TextFormField(
                controller: _userController.passwordTextEditingController,
                obscureText: true,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.red[800]),
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[800], width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[800], width: 0.5),
                  ),
                  hintStyle: TextStyle(color: Colors.red[800]),
                  labelStyle: TextStyle(color: Colors.red[800]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            // Text(
            //   'I forgot my password?',
            //   style: TextStyle(color: Colors.yellow[800], fontSize: 16.0),
            // ),

            Container(
              width: double.infinity,
              height: size == Sizes.Large ? 45 : 40,
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  _userController.emailAndPasswordSignIn();
                },
                color: Colors.red[800],
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
