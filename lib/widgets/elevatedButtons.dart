import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import 'button_style.dar.dart';

ElevatedButton elevatedButton(String title){
  return ElevatedButton(
    style: buttonStyle,
    onPressed: () {

    },
    child: Text(
      title,
      style: const TextStyle(
        color: Colours.fontColor1,
        fontSize: 14,
      ),
    ),
  );
}