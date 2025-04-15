// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/main.dart';

class DetailBL extends StatefulWidget {
  const DetailBL({Key? key}) : super(key: key);

  @override
  State<DetailBL> createState() => _DetailBLState();
}

class _DetailBLState extends State<DetailBL> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text(
          'Détail du BL',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
          style: styleG,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderMic(),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'INFORMATIONS',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
