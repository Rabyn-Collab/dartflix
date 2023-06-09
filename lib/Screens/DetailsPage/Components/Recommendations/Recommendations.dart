// ignore_for_file: unnecessary_const

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:dartflix/Screens/DetailsPage/Components/DetailsPageBody.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import '../../../../CustomSnackbar/Snackbar.dart';
import '../../../../Util/GreenSnackbar.dart';
import '../../../../main.dart';
import '../../../CustomListFromUserHistory/Model/History.dart';

class Recommendations extends StatefulWidget {
  final id;
  final movie_name;

  Recommendations({
    Key? key,
    @required this.id,
    this.movie_name,
  }) : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  List popularlist = [];
  List recommend = [];
  Future<void> _showMyDialog(movieid, moviename, posterpath) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            content: Container(
              height: 140,
              width: 140,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              AntIcons.plusSquareOutlined,
                              color: Colors.red,
                              size: 30,
                            ),
                            const Text(
                              "Add TO WATCHLIST",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.white),
                            ),
                          ],
                        ))),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: const Text(
                          "CLOSE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void contentbasedrecommendations() async {
    try {
      var response = await Dio().get(
          "https://enage22.herokuapp.com/send/" + widget.movie_name.toString());
      var data = response.data;
      if (mounted) {
        setState(() {
          if (mounted) {
            popularlist = data;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void apibased() async {
    try {
      var response = await Dio().get("https://api.themoviedb.org/3/movie/" +
          widget.id.toString() +
          "/recommendations?api_key=ebe86eb4e04342d7598d4096a16d8d11&language=en-US&page=1");

      var data = response.data;
      if (mounted) {
        setState(() {
          recommend = data['results'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    contentbasedrecommendations();
    apibased();
  }

  List<String> movieimages = [];
  List<String> movietitles = [];

  void storedata(String name, String url, String id) async {
    movieimages.add(url.toString());
    recommemdedmovieimages =
        preferences.getStringList('recommemdedmovieimages') ?? [];
    for (int i = 0; i < recommemdedmovieimages.length; i++) {
      if (recommemdedmovieimages[i] == url) {
        return;
      }
    }
    recommemdedmovieimages.add(url.toString());
    recommemdedmovieimages.toSet().toList();
    preferences.setStringList("recommemdedmovieimages", recommemdedmovieimages);

    movietitles.add(name.toString());
    recommemdedmovienames =
        preferences.getStringList('recommemdedmovietitles') ?? [];
    for (int i = 0; i < recommemdedmovienames.length; i++) {
      if (recommemdedmovienames[i] == name) {
        return;
      }
    }
    recommemdedmovienames.add(name.toString());
    recommemdedmovienames.toSet().toList();
    preferences.setStringList("recommemdedmovietitles", recommemdedmovienames);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 2.h,
                left: 2.w,
                right: 2.w,
              ),
              child: Text("Recommendations Based on ML Model",
                  style: TextStyle(
                      color: HexColor("#7220C9"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none)),
            ),
            recommend.isNotEmpty
                ? InkWell(
                    onTap: () {
                      var _type = FeedbackType.success;
                      Vibrate.feedback(_type);
                      storedata(
                          recommend[0]["original_title"].toString(),
                          "https://image.tmdb.org/t/p/w780" +
                              recommend[0]["poster_path"].toString(),
                          recommend[0]["id"].toString());
                      storedata(
                          recommend[1]["original_title"].toString(),
                          "https://image.tmdb.org/t/p/w780" +
                              recommend[1]["poster_path"].toString(),
                          recommend[1]["id"].toString());

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 5,
                        content: GreenSnackbar(
                          title: "Recommendations are sent to your watchlist",
                          message: ':)',
                        ),
                      ));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: 80.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.blueGrey),
                      child: Row(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.only(bottom: 4, left: 10),
                              child: const Icon(AntIcons.likeOutlined,
                                  size: 22, color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: 5, top: 2),
                            child: const Text(
                              "Like these recommendations ?",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            recommend.isNotEmpty ? getallpopularmoviecards() : SizedBox(),
            getallpopularmoviecard(),
          ],
        ),
      ),
    );
  }

  Widget getlottie() {
    return Center(
      child: Container(
        height: 30.h,
        width: 80.w,
        child: Lottie.asset("assets/images/analysing.json"),
      ),
    );
  }

  Widget getallpopularmoviecard() {
    if (popularlist.isEmpty) {
      return getlottie();
    } else {
      return Container(
          color: Colors.black,
          margin: const EdgeInsets.only(top: 10),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (130.0 / 190.0),
              ),
              shrinkWrap: true,
              itemCount: popularlist.isNotEmpty ? popularlist.length : 0,
              controller: ScrollController(keepScrollOffset: false),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.black),
                    child: Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              var _type = FeedbackType.success;
                              Vibrate.feedback(_type);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsPageBody(
                                            moviename: popularlist[index]
                                                ["title"],
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 160,
                              width: double.infinity,
                              child: popularlist[index]["poster_path"] == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: const Image(
                                          fit: BoxFit.cover,
                                          image: const AssetImage(
                                              'assets/images/loading.png')))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: FadeInImage.assetNetwork(
                                        image:
                                            "https://image.tmdb.org/t/p/w780" +
                                                popularlist[index]
                                                    ["poster_path"],
                                        placeholder:
                                            "assets/images/loading.png",
                                        fit: BoxFit.cover,
                                      )),
                            )),
                        Positioned(
                          top: 3,
                          right: 0,
                          child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ));
              }));
    }
  }

  Widget getallpopularmoviecards() {
    if (popularlist.isEmpty) {
      return getlottie();
    } else {
      return Container(
        color: Colors.black,
        margin: const EdgeInsets.only(top: 0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: (130.0 / 190.0),
          ),
          shrinkWrap: true,
          itemCount: recommend.isNotEmpty ? recommend.length : 0,
          controller: ScrollController(keepScrollOffset: false),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black),
              child: Stack(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPageBody(
                                      moviename: recommend[index]["title"],
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 160,
                        width: double.infinity,
                        child: recommend[index]["poster_path"] == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/loading.png')))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage.assetNetwork(
                                  image: "https://image.tmdb.org/t/p/w780" +
                                      recommend[index]["poster_path"],
                                  placeholder: "assets/images/loading.png",
                                  fit: BoxFit.cover,
                                )),
                      )),
                  const Positioned(
                      top: 3,
                      right: 0,
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      )),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
