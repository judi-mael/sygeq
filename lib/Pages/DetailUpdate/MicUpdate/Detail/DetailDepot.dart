// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailDepot extends StatefulWidget {
  var data;
  DetailDepot({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailDepot> createState() => _DetailDepotState();
}

class _DetailDepotState extends State<DetailDepot> {
  disable() async {
    var data = await RemoteServiceDisable.micDisable(
      widget.data['id'],
      0,
      'depots',
    );
    return data;
  }

  restor() async {
    var data = await RemoteServiceDisable.micRestor(
      widget.data['id'],
      0,
      'depots',
    );
    return data;
  }

  restoralertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: Container(
            child: Column(
              children: [
                Text(
                  "Vous allez restaurer ${widget.data['nom']}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                  style: styleG,
                ),
                Text(
                  "Vous êtes sur de vouloir continuer?",
                  maxLines: 2,
                  softWrap: true,
                  style: styleG,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                restor();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: green),
              child: Text("Oui", style: btnTxtCOlor),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text("Non", style: btnTxtCOlor),
            ),
          ],
        );
      },
    );
  }

  alertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: Container(
            child: Column(
              children: [
                Text(
                  "Vous allez désactiver ${widget.data['nom']}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                  style: styleG,
                ),
                Text(
                  "Vous êtes sur de vouloir continuer?",
                  maxLines: 2,
                  softWrap: true,
                  style: styleG,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                disable();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: green),
              child: Text("Oui", style: btnTxtCOlor),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text("Non", style: btnTxtCOlor),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Nom dépôt douanier :",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${widget.data['nom']}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "IFU :",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${widget.data['ifu']}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Régistre  : ",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${widget.data['agrement']}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Autorisation du : ",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        DateFormat(
                              'dd MMM yyyy ',
                            ).format(DateTime.parse(widget.data['DateStart'])) +
                            ' au ' +
                            DateFormat(
                              'dd MMM yyyy ',
                            ).format(DateTime.parse(widget.data['DateEnd'])),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        // style: styleG,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 10,
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Flexible(
            //           flex: 2,
            //           child: Text(
            //             "Date de fin :",
            //             softWrap: true,
            //             maxLines: 2,
            //             overflow: TextOverflow.ellipsis,
            //             style: styleG,
            //           ),
            //         ),
            //         Flexible(
            //           flex: 2,
            //           child: Text(
            //             "${widget.data['DateEnd']}",
            //             softWrap: true,
            //             maxLines: 2,
            //             overflow: TextOverflow.ellipsis,
            //             // style: styleG,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity,
                child:
                    widget.data['delete'] == ''
                        ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            alertDialog();
                          },
                          child: Text(
                            "Désactiver",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: btnTxtCOlor,
                          ),
                        )
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            restoralertDialog();
                          },
                          child: Text(
                            "Restaurer",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: btnTxtCOlor,
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
