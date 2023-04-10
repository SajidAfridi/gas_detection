import 'package:flutter/material.dart';

import '../common/app_colors.dart';

ButtonStyle buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colours.themeColor),
  //elevation: MaterialStateProperty.all<double>(1.0),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colours.themeColor),
    ),
  ),
);