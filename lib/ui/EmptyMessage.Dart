// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class EmptyMessage extends StatefulWidget {
  final String mesaageText;
  const EmptyMessage(
      {super.key, this.mesaageText = "Aucune information trouvée!!!"});

  @override
  State<EmptyMessage> createState() => _EmptyMessageState();
}

class _EmptyMessageState extends State<EmptyMessage> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          widget.mesaageText,
          textScaleFactor: 1,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}
