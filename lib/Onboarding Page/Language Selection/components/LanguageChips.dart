import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dartflix/Navigation/Navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';

import '../../../CustomSnackbar/Snackbar.dart';
import '../../../Util/RoundedRectenguarButton.dart';
import '../../../main.dart';

class LanguageSelection extends StatefulWidget {
  static final List<String> languages = [];

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  @override
  Widget build(BuildContext context) {
  
    // TODO: implement build
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
              child: Wrap(
            spacing: 5.0,
            runSpacing: 3.0,
            children: const <Widget>[
              LanguageChip(chipName: 'English'),
              LanguageChip(chipName: 'Hindi'),
              LanguageChip(chipName: 'Bengali'),
              LanguageChip(chipName: 'Telugu'),
              LanguageChip(chipName: 'Marathi'),
              LanguageChip(chipName: 'Gujarati'),
              LanguageChip(chipName: 'Punjabi'),
            ],
          )),
        ),
        SizedBox(
          height: 5.h,
        ),
        RoundedRectengularButton(
          text: "Continue",
          onPressed: () async {
            var _type = FeedbackType.success;
            Vibrate.feedback(_type);
            if (LanguageSelection.languages.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 5,
                  content: CustomSnackbr(
                    title: "oh Error!",
                    message: 'Select atleast one language',
                  ),
                ),
              );
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              preferences.setStringList(
                  "_language", LanguageSelection.languages.toList());
              await prefs.setBool('seen', true);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return MyHomePage();
                }),
                ModalRoute.withName('/LanguageSelection'),
              );
            }
          },
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class LanguageChip extends StatefulWidget {
  final String chipName;

  const LanguageChip({Key? key, required this.chipName}) : super(key: key);

  @override
  _LanguageChipState createState() => _LanguageChipState();
}

// ignore: camel_case_types
class _LanguageChipState extends State<LanguageChip> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selectedColor: HexColor("#7220C9"),
      label: Text(widget.chipName),
      labelStyle: GoogleFonts.getFont(
        "Chivo",
        textStyle: TextStyle(
          color: _isSelected ? Colors.white : Colors.black,
          letterSpacing: .5,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: HexColor("#E5E5FF"),
      onSelected: (isSelected) {
        var _type = FeedbackType.selection;
        Vibrate.feedback(_type);
        setState(() {
          if (isSelected) {
            _isSelected = isSelected;
            LanguageSelection.languages.add(widget.chipName);
            // print( FilterChipDisplay._filters.toString());
          } else {
            _isSelected = false;

            LanguageSelection.languages.removeWhere((String name) {
              return name == widget.chipName;
            });
          }
        });
      },
    );
  }
}
