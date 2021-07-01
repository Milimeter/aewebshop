import 'package:aewebshop/screens/widget/signup_container.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
            colors: [Colors.purple[700], Colors.blueGrey[600]],
          ),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 1200)
            return SignupContainer(type: 'desktop',);
          else if (constraints.maxWidth > 700 && constraints.maxWidth < 1200)
            return SignupContainer(type: 'tablet',);
          else
            return SignupContainer(type: 'mobile',);  
        })
      ),
    );
  }
}