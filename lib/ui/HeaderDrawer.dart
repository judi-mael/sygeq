// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:sygeq/main.dart';

class HaederDrawer extends StatefulWidget {
  const HaederDrawer({super.key});

  @override
  State<HaederDrawer> createState() => _HaederDrawerState();
}

class _HaederDrawerState extends State<HaederDrawer> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Color.fromARGB(255, 129, 177, 216), //Color(0xFF390047),
      elevation: 5,
      leadingWidth: 2,
      automaticallyImplyLeading: false,
      pinned: true,
      // centerTitle: true,
      title: Icon(Icons.arrow_back, size: 30, color: blue),
    );
  }
}
