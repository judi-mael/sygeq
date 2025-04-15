// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/UpdateProduit.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailProduit extends StatefulWidget {
  var data;
  DetailProduit({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailProduit> createState() => _DetailProduitState();
}

class _DetailProduitState extends State<DetailProduit> {
  disable() async {
    var data = await RemoteServiceDisable.micDisable(
      widget.data['id'],
      0,
      'produits',
    );
    return data;
  }

  restor() async {
    var data = await RemoteServiceDisable.micRestor(
      widget.data['id'],
      0,
      'produits',
    );
    return data;
  }

  actionOnTheEditProduit(var data) {
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
              child: UpdateProduit(data: data),
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
        padding: EdgeInsets.only(
          // top: 20,
        ),
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
                      child: IconButton(
                        icon: Icon(Icons.edit, color: green),
                        onPressed: () {
                          actionOnTheEditProduit(widget.data);
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => UpdateProduit(
                          //       data: widget.data,
                          //     ),
                          //   ),
                          // );
                        },
                      ),
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
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        Flexible(child: Icon(Icons.fire_hydrant, color: red)),
                        Flexible(
                          child: Text(
                            "Désignation : ",
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
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Icon(Icons.mode_comment_outlined),
                        ),
                        Flexible(
                          child: Text(
                            "Type : ",
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
                    flex: 2,
                    child: Text(
                      "${widget.data['type']}",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        Flexible(child: Icon(Icons.password)),
                        Flexible(
                          child: Text(
                            "Code : ",
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
                    flex: 2,
                    child: Text(
                      "${widget.data['code']}",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                ],
              ),
            ),
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
