import 'package:flutter/material.dart';
import '../common/app_colors.dart';

InputDecoration inputDecoration(String hintText) {
  const double borderWidth = 0.0;
  return InputDecoration(
    fillColor: Colors.white,
    filled: true,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(
        width: 1,
        color: Colors.black,
      ),
    ),

    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide(
        color: Colors.white54,
        width: 1, // Set the border width
      ),
    ),
    enabledBorder:const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide:BorderSide(
        width: borderWidth, // Set the border width
        color: Colors.black,
      ),
    ),
    focusColor: Colors.white54,
    hintText: hintText,
    contentPadding: const EdgeInsets.fromLTRB(20, 17, 50, 14),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide:BorderSide(
        color: Colors.black,
        width: borderWidth, // Set the border width
      ),
    ),
  );
}
