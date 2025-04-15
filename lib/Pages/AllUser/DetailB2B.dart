// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Pages/AllUser/UpdateB2B.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailB2B extends StatefulWidget {
  var data;
  DetailB2B({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailB2B> createState() => _DetailB2BState();
}

class _DetailB2BState extends State<DetailB2B> {
  disable() async {
    var data = await RemoteServiceDisable.micDisable(
      widget.data['id'],
      0,
      'stations',
    );
    return data;
  }

  restor() async {
    var data = await RemoteServiceDisable.micRestor(
      widget.data['id'],
      0,
      'stations',
    );
    return data;
  }

  actionOnTheEditB2B(var data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            insetPadding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              child: UpdateB2B(data: data),
            ),
          ),
        );
      },
    );
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
              child: Text("Oui"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text("Non"),
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
              child: Text("Oui"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text("Non"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            widget.data['delete'] == ''
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        widget.data['nom'],
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child:
                          prefUserInfo['type'] == "Marketer"
                              ? IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  actionOnTheEditB2B(widget.data);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             UpdateStation(data: widget.data)));
                                },
                              )
                              : Container(),
                    ),
                  ],
                )
                : Text(
                  widget.data['nom'],
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(Icons.info, color: green),
                        Text('IFU : '),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Text(
                      widget.data['ifu'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 15,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Flexible(
            //         flex: 2,
            //         child: Row(
            //           children: [
            //             Flexible(
            //               child: Icon(
            //                 Icons.oil_barrel_sharp,
            //                 color: blue,
            //               ),
            //             ),
            //             Flexible(
            //               flex: 3,
            //               child: Text(
            //                 "Marketer : ",
            //                 softWrap: true,
            //                 maxLines: 2,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: styleG,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Flexible(
            //         flex: 4,
            //         child: Text(
            //           widget.data['marketerNom'],
            //           softWrap: true,
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //           // style: styleG,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Flexible(child: Icon(Icons.check, color: red)),
                        Flexible(
                          child: Text(
                            "RCCM : ",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styleG,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Text(
                      widget.data['rccm'],
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: styleG,
                    ),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 10,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Flexible(
            //         flex: 2,
            //         child: Row(
            //           children: [
            //             Flexible(
            //               child: Icon(
            //                 Icons.location_city,
            //                 color: blue,
            //               ),
            //             ),
            //             Flexible(
            //               child: Text(
            //                 "Ville  : ",
            //                 softWrap: true,
            //                 maxLines: 2,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: styleG,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Flexible(
            //         flex: 4,
            //         child: Text(
            //           widget.data['villeNom'],
            //           softWrap: true,
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //           // style: styleG,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Icon(Icons.fmd_good_sharp, color: green),
                        ),
                        Flexible(
                          flex: 3,
                          child: Text(
                            "Adresse  : ",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styleG,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Text(
                      widget.data['adresse'],
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: styleG,
                    ),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 10,
            //   ),
            //   child: Card(
            //     child: Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Flexible(
            //             flex: 2,
            //             child: Text(
            //               "Date de fin :",
            //               softWrap: true,
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //               style: styleG,
            //             ),
            //           ),
            //           Flexible(
            //             flex: 2,
            //             child: Text(
            //               "${widget.data['DateEnd']}",
            //               softWrap: true,
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //               style: styleG,
            //             ),
            //           ),
            //         ],
            //       ),
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
