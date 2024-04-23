import 'package:flutter/material.dart';
import 'package:dementia_care/helper/size_config.dart';

const kPrimaryColor = Color.fromARGB(255, 0, 0, 0);
const kPrimaryLightColor = Color.fromARGB(255, 255, 255, 255);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color.fromARGB(255, 121, 110, 219), Color.fromARGB(255, 29, 80, 190)],
);
const kSecondaryColor = Color.fromARGB(255, 255, 255, 255);
const kTextColor = Color.fromARGB(255, 47, 47, 47);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getRelativeScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);
