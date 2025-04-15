// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/main.dart';

ListTile listB2BCard(var _station) {
  return ListTile(
    // leading: Image.asset('assets/Images/default_image.png'),
    title: Container(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _station.nomStation,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: styleG,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            "Adresse : ",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: styleG,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Text(
                            _station.adresse,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    trailing: Icon(Icons.navigate_next_outlined, color: blue),
  );
}

ListTile listStationCard(var _station) {
  return ListTile(
    trailing: Icon(Icons.navigate_next_outlined, color: blue),
    // leading: Image.asset('assets/Images/default_image.png'),
    title: Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _station.nomStation,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: styleG,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            "Marketer : ",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: styleG,
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Text(
                            _station.marketer.nom,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            "Adresse : ",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: styleG,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Text(
                            _station.adresse,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

ListTile cardCamion(var listCaion) {
  return ListTile(
    // leading: Icon(
    //   Icons.airport_shuttle,
    //   color: blue,
    //   size: 35,
    // ),
    // leading: Image.asset('assets/Images/default_image.png'),
    title: Container(
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                          listCaion.imat,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    listCaion.marque,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      color: blue,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    "Capacité",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w200,
                      fontSize: 15,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    "${listCaion.capacity}",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w200,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

ListTile listDesTransporteurs(Driver _transporteur) {
  return ListTile(
    // leading: Image.asset(
    //   'assets/icons/transporter.png',
    //   width: 30,
    //   height: 30,
    //   color: blue,
    // ),
    title: Text(
      _transporteur.nom,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(color: blue, fontWeight: FontWeight.bold),
    ),
    trailing: Icon(Icons.navigate_next_outlined),
  );
}

ListTile listDesMarketer(Marketer _marketer) {
  return ListTile(
    // leading: Image.asset(
    //   'assets/icons/marketer.png',
    //   width: 40,
    //   height: 50,
    //   color: blue,
    // ),
    title: Text(
      _marketer.nom,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(color: blue, fontWeight: FontWeight.bold),
    ),
    trailing: Icon(Icons.navigate_next_outlined),
  );
}

ListTile listDesDepot(Depot _depot) {
  return ListTile(
    // leading: Icon(
    //   Icons.houseboat_rounded,
    //   color: blue,
    // ),
    title: Text(
      _depot.nom,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(color: blue, fontWeight: FontWeight.bold),
    ),
    trailing: Icon(Icons.navigate_next_outlined),
  );
}
