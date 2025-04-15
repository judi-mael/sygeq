// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/UpdateBT.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/UpdateBTCharger.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailBT extends StatefulWidget {
  var data;
  Depot depot;
  Marketer marketer;
  Camion camion;
  Depot station;
  Driver driver;
  List<DetailLivraison> listDetailLivraison = [];
  DetailBT({
    Key? key,
    required this.data,
    required this.listDetailLivraison,
    required this.camion,
    required this.depot,
    required this.driver,
    required this.marketer,
    required this.station,
  }) : super(key: key);
  @override
  State<DetailBT> createState() => _DetailBTState();
}

class _DetailBTState extends State<DetailBT> {
  int id = 0;
  updateBLStatut(String statut) async {
    var data = await MarketerRemoteService.markUpdateBLStatut(
      widget.data['id'],
      statut,
    );
    return data;
  }

  disable(int id) async {
    var data = await RemoteServiceDisable.marketerDisable(id, 0, 'stations');
    return data;
  }

  @override
  void initState() {
    super.initState();
    // id = widget.data
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data["statut"] == "Ouvert" ||
                    widget.data["statut"] == "Approuvé" ||
                    widget.data["statut"] == "Chargé" ||
                    widget.data["statut"] == "Bon à Charger"
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Détail BT",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: styleG,
                      ),
                    ),
                    if (widget.data["statut"] == "Chargé" ||
                        widget.data["statut"] == "Bon à Charger")
                      Flexible(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => UpdateBTCharger(
                                      data: widget.data,
                                      station: widget.station,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (widget.data["statut"] == "Ouvert" ||
                        widget.data["statut"] == "Approuvé")
                      Flexible(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => UpdateBT(
                                      data: widget.data,
                                      listDetailLivraison:
                                          widget.listDetailLivraison,
                                      camion: widget.camion,
                                      depot: widget.depot,
                                      driver: widget.driver,
                                      marketer: widget.marketer,
                                      station: widget.station,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                  // if (prefUserInfo['role'] == 'Super Admin') ...[
                  //   Flexible(
                  //     child: IconButton(
                  //       icon: Icon(Icons.edit),
                  //       onPressed: () {
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => UpdateBL(
                  //               data: widget.data,
                  //               listDetailLivraison:
                  //                   widget.listDetailLivraison,
                  //               camion: widget.camion,
                  //               depot: widget.depot,
                  //               driver: widget.driver,
                  //               marketer: widget.marketer,
                  //               station: widget.station,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ],
                )
                : Text(
                  "Détail BL",
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            "Numero BL : ",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: styleG,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Text(
                            "${widget.data['numBL']}",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            // style: styleG,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        "Marketer : ",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        widget.marketer.nom,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        // style: styleG,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        "Dépôt : ",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        widget.depot.nom,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        // style: styleG,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        "Destination : ",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        widget.station.nom,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        // style: styleG,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Détails du Bl",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Column(
                children: [
                  for (int i = 0; widget.listDetailLivraison.length > i; i++)
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                "${i + 1} - ${widget.listDetailLivraison[i].produit.nom} ",
                                softWrap: true,
                                maxLines: 2,
                                style: styleG,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                "qtés :   ${widget.listDetailLivraison[i].qtte} ${widget.listDetailLivraison[i].produit.unite}",
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
                ],
              ),
            ),
            if (prefUserInfo['role'] == 'Admin') ...[
              if (widget.data['statut'] == "Ouvert") ...[
                Padding(
                  padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      updateBLStatut("Annulé").then((value) {});
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel_rounded, color: red, size: 30),
                    label: Text(
                      "Annuler",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.montserrat(color: red, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ],
            if (prefUserInfo['role'] == 'Super Admin') ...[
              if (widget.data['statut'] == "Ouvert") ...[
                Padding(
                  padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: blue,
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: (() {
                            updateBLStatut("Approuvé").then((value) {});
                            Navigator.pop(context);
                          }),
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                          label: Text(
                            "Approuver",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            updateBLStatut("Annulé").then((value) {});
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: red,
                            size: 30,
                          ),
                          label: Text(
                            "Annuler",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              color: red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            if (prefUserInfo['role'] == 'Super Admin') ...[
              if (widget.data['statut'] == "Approuvé") ...[
                Padding(
                  padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: red),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        updateBLStatut("Annulé");
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel_rounded, color: red, size: 30),
                      label: Text(
                        "Annuler",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(color: red, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
