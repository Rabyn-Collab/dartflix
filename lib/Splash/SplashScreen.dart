import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dartflix/Navigation/Navigation.dart';
import 'package:dartflix/Screens/Introduction%20Screen/IntroductionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../Onboarding Page/Genere selection/GenreSelection.dart';

class SplashScreen extends StatefulWidget {
  static bool saw = false;

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
//(prefs.getBool('seen') ?? false);
    if (_seen) {
      SplashScreen.saw = _seen;
      _handleStartScreen();
    } else {
      SplashScreen.saw = false;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return IntroductionPage();
        }),
        ModalRoute.withName('/intro'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: Center(
              child: Image.asset(
            'assets/images/logo.png',
            height: 10.h,
          )),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  Future<void> _handleStartScreen() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) {
        return MyHomePage(userid: "userid");
      }),
      ModalRoute.withName('/Splash'),
    );
  }
}
