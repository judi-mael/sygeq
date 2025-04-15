// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sygeq/Helpers/data.dart';

class BarData {
  static int interval = 5;
  static List<Data> barData = [
    Data(id: 0, name: "Mon", y: 15, color: Color.fromARGB(255, 12, 82, 110)),
    Data(id: 1, name: "Tue", y: 10, color: Color.fromARGB(245, 40, 177, 51)),
    Data(id: 2, name: "Wed", y: 9, color: Color.fromARGB(251, 199, 29, 176)),
  ];
}
