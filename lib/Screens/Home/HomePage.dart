import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dartflix/Screens/Home/components/CollaborativeHomepage.dart';
import 'package:dartflix/Screens/Home/components/HomepageBody.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#121212"),
      resizeToAvoidBottomInset: false,
      //body: HomepageBody(),
            body: CollaborativeHomePage(),

    );
  }
}
