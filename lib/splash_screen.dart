import 'package:flutter/material.dart';
import 'dart:async';
import 'onboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => OnBoardScreen())); // Replace with your home page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // White background
      body: Center(
        child: Image.asset('assets/logo/logoset.png', height: 250,),  // Image in the center
      ),
    );
  }
}

