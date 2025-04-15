// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/main.dart';

toastWidget(String message) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      // color: defautlCardColors,
    ),
    child: Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: blue, size: 20),
        SizedBox(height: 12.0),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 4,
            softWrap: true,
            style: GoogleFonts.montserrat(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

toastError(String message) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: red,
    ),
    child: Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error, color: white, size: 20),
        SizedBox(height: 12.0),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 4,
            softWrap: true,
            style: GoogleFonts.montserrat(color: white),
          ),
        ),
      ],
    ),
  );
}
