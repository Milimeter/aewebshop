import 'package:aewebshop/constants/sizes.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/screens/auth/signup_screen.dart';
import 'package:aewebshop/screens/widget/login_container.dart';
import 'package:aewebshop/screens/widget/signup_container.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AuthWrapper extends StatefulWidget {
  String type;

  AuthWrapper({this.type});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  UserController _userController = Get.find();

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = WindowSizes.size(width);
    return Card(
      elevation: 5,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: size == Sizes.Large ? 0 : 50),
              width: size == Sizes.Large ? Get.width * 0.6 : Get.width * 0.8,
              height: size == Sizes.Large ? Get.height * 0.5 : Get.height * 0.6,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: Colors.red[800],
                      child: Center(
                        child: Text(
                            _index == 0 ? "Welcome with us" : "Welcome Back !",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900)),
                      ),
                      width:
                          size == Sizes.Large ? Get.width * 0.2 : Get.width * 0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: size == Sizes.Large ? 40 : 8.0),
                                child: IndexedStack(
                                  index: _index,
                                  children: [
                                    Center(child: LoginContainer()),
                                    Center(child: SignupContainer())
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                height: 45.0,
                                width: Get.width * 0.3,

                                // ignore: deprecated_member_use
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _index = _index == 0 ? 1 : 0;
                                      });
                                    },
                                    child: Text(
                                        _index == 0
                                            ? "Don't have an account ? Singup"
                                            : 'You already have an account ? login',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size == Sizes.Large
                                                ? 16.0
                                                : 8)),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 20,
                left: size == Sizes.Large ? Get.width * 0.21 : 10,
                child: Text(
                  _index == 0 ? "Login" : "Signup",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Positioned(
              top: 5,
              right: 10,
              child: GestureDetector(
                  onTap: () {
                    BotToast.cleanAll();
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: WindowSizes.size(Get.width) == Sizes.Large ? 50 : 30,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
