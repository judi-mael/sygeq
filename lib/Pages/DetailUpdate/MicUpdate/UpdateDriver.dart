// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:sygeq/Models/Driver.dart';

class UpdateDriver extends StatefulWidget {
  List<Driver> driverL = [];
  UpdateDriver({Key? key, required this.driverL}) : super(key: key);

  @override
  State<UpdateDriver> createState() => _UpdateDriverState();
}

class _UpdateDriverState extends State<UpdateDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
