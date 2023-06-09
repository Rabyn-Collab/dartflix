import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dartflix/Profile/Profile.dart';
import 'package:dartflix/Screens/Home/HomePage.dart';
import 'package:dartflix/Screens/Search/Search.dart';
import 'package:dartflix/Watchlistbar/Watchlistbar.dart';

import '../Screens/Swipe Cards/Swipablecards.dart';

class MyHomePage extends StatefulWidget {
  final List<Page> _pages = [
    Page('Home', Icons.home, 30),
    Page('search', Icons.search, 30),
    Page('Suggest', Icons.assistant, 30),
    Page('Profile', Icons.person_outline, 30),
  ];

  final userid;
  final username;
  MyHomePage({Key? key, @required this.userid, this.username})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  void _openPage(int index) {
    var _type = FeedbackType.selection;
            Vibrate.feedback(_type);
    setState(() {
      _currentPageIndex = index;
    });
  }

  void initState() {
    super.initState();
    Future(() {
  // Call your function
  WidgetsBinding.instance!.addPostFrameCallback((_) async {
       setState(() {
      _currentPageIndex = 0;
    });
    });
  
});
    
  }

  @override
  Widget build(BuildContext context) {
    List routes = [
      Home(),
      Search(),
      SwipableCards(),
      Profile(),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
          index: _currentPageIndex,
          children: const [
            Home(),
            Search(),
            SwipableCards(),
          
            Profile(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: HexColor("#272727"),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _currentPageIndex,
        items: widget._pages
            .map((Page page) => BottomNavigationBarItem(
                  icon: Icon(
                    page.iconData,
                    size: page.size,
                  ),
                  label: page.title,
                ))
            .toList(),
        onTap: _openPage,
      ),
    );
  }
}

class Page {
  final String title;
  final IconData iconData;
  final double size;
  Page(this.title, this.iconData, this.size);
}
