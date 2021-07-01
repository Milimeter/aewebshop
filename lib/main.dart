import 'dart:async';
import 'package:fluro/fluro.dart' as fr;

import 'package:aewebshop/controllers/cart_controller.dart';
import 'package:aewebshop/controllers/order_controller.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/routes.dart';
import 'package:aewebshop/screens/auth/login_screen.dart';
import 'package:aewebshop/screens/homepage.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(UserController());
  Get.put(CartController());
  Get.put(OrderController());
  Flurorouter.setupRouter();
  await GetStorage.init();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: ("Montserrat")),
      onGenerateRoute: Flurorouter.router.generator,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user;
  @override
  void initState() {
    super.initState();

    navigate();
    print("user from firebase " + user.toString());
    //navigate();

    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.push(
    //         context,
    //         PageTransition(
    //             type: PageTransitionType.fade,
    //             child: HomePage(),
    //             duration: Duration(milliseconds: 900))));
  }

  navigate() {
    // User user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    Timer(Duration(seconds: 5), () {
      Get.off(HomePage());
    });
    // } else {
    //   Timer(Duration(seconds: 3), () {
    //     Get.off(LoginScreen());
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: Image.asset(
                'assets/img/ae_landing.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 80.0),
                      ),
                      new Image.asset('assets/img/aelogo.png',
                          height: 180, width: 180),
                    ],
                  ))),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white)),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
