import 'package:flutter/material.dart';

class EmptyList extends StatefulWidget {
  @override
  State<EmptyList> createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Image.asset('assets/icons/empty.png'),
      height: _size.height / 4,
      width: _size.height / 4,
    );
  }
}
