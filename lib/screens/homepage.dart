import 'package:aewebshop/constants/sizes.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/routes.dart';
import 'package:aewebshop/screens/auth/login_screen.dart';
import 'package:aewebshop/screens/preartiki.dart';
import 'package:aewebshop/screens/widget/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController _userController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final size = WindowSizes.size(screenSize.width);
    return Title(
      color: Colors.red[800],
      title: "Početna - AE Web shop",
      child: Scaffold(
          appBar: size == Sizes.Large
              ? null
              : AppBar(
                  backgroundColor: Colors.red[800],
                  centerTitle: true,
                  title: Text("P O Č E T N A", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
          drawer: size == Sizes.Large
              ? SizedBox()
              : NavBar(
                  size: size,
                ),
          body: Stack(children: [
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
            Center(
              child: Column(
                children: [
                  SizedBox(height: 150),
                  new Image.asset('assets/img/aelogo.png',
                      height: 180, width: 180),
                  SizedBox(height: 50),
                  Text(
                    "WEB SHOP",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Na stanju preko 30.000 autodijelova za razne automobile.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.red[800])),
                      elevation: 5.0,
                      color: Colors.red[800],
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      splashColor: Colors.grey,
                      onPressed: () async {
                        Get.toNamed(Flurorouter.shop);
                      },
                      child: Text("Pretraga autodijelova"))
                ],
              ),
            ),
            if (size == Sizes.Large)
              Positioned(top: 0.0, right: 0.0, child: NavBar()),
          ])),
    );
  }
}
