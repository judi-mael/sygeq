import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sygeq/main.dart';
import 'package:path/path.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;
  PDFViewerPage({Key? key, required this.file}) : super(key: key);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      backgroundColor: gryClaie,
      // body: PDFView(),
    );
  }
}
