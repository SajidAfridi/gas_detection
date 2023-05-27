import 'package:flutter/material.dart';

import '../common/app_colors.dart';

ButtonStyle buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colours.themeColor),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(color: Colours.themeColor),
    ),
  ),
);