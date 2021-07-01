import 'package:aewebshop/screens/widget/login_container.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.red[800], Colors.blueGrey[600]],
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 1200)
              return LoginContainer(
                type: 'desktop',
              );
            else if (constraints.maxWidth > 700 && constraints.maxWidth < 1200)
              return LoginContainer(
                type: 'tablet',
              );
            else
              return LoginContainer(
                type: 'mobile',
              );
          })),
    );
  }
}
