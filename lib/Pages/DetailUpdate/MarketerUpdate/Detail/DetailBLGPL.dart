// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/BonGPLBouteille.dart';
import 'package:sygeq/Pages/Maketers/dispactBlGPLBouteille.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailBlGPL extends StatefulWidget {
  BonGplBouteille bongpl;
  DetailBlGPL({Key? key, required this.bongpl}) : super(key: key);
  @override
  State<DetailBlGPL> createState() => _DetailBlGPLState();
}

class _DetailBlGPLState extends State<DetailBlGPL> {
  int id = 0;
  updateBLStatut(String statut) async {
    var data = await MarketerRemoteService.markUpdateBLStatut(
      widget.bongpl.id,
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
            widget.bongpl.statut == "Ouvert" ||
                    widget.bongpl.statut == "Approuvé" ||
                    widget.bongpl.statut == "Chargé" ||
                    widget.bongpl.statut == "Bon à Charger"
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Détail BL GPL",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: styleG,
                      ),
                    ),
                    // if (widget.data["statut"] == "Chargé") ...[
                    Flexible(
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        icon: FaIcon(FontAwesomeIcons.cut, color: white),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DispatchBlGplBouteille(
                                    bonGplBouteil: widget.bongpl,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    // ],
                    if (widget.bongpl.statut == "Chargé" ||
                        widget.bongpl.statut == "Bon à Charger")
                      Flexible(
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: Icon(Icons.edit, color: white),
                          onPressed: () {
                            // Navigator.pushReplacement(
                            // context,
                            // MaterialPageRoute(
                            //   builder: (context) => UpdateBLCharger(
                            //     data: widget.data,
                            //     station: widget.station,
                            //   ),
                            // ),
                            // );
                          },
                        ),
                      ),
                    if (widget.bongpl.statut == "Ouvert" ||
                        widget.bongpl.statut == "Approuvé")
                      Flexible(
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: Icon(Icons.edit, color: white, size: 25),
                          onPressed: () {
                            // Navigator.pushReplacement(
                            // context,
                            // MaterialPageRoute(
                            //   builder: (context) => UpdateBL(
                            //     data: widget.data,
                            //     listDetailLivraison:
                            //         widget.listDetailLivraison,
                            //     camion: widget.camion,
                            //     depot: widget.depot,
                            //     driver: widget.driver,
                            //     marketer: widget.marketer,
                            //     station: widget.station,
                            //   ),
                            // ),
                            // );
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
                  "Détail BL GPL",
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
                            "${widget.bongpl.numeroBl}",
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
                        widget.bongpl.marketer.nom,
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
                        widget.bongpl.depot.nom,
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
                        "Station : ",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        widget.bongpl.station.nom,
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
                  for (int i = 0; widget.bongpl.produits.length > i; i++)
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
                                "${i + 1} - ${widget.bongpl.produits[i].produit.nom} ",
                                softWrap: true,
                                maxLines: 2,
                                style: styleG,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                "qtés :   ${widget.bongpl.produits[i].qtte} ${widget.bongpl.produits[i].produit.unite}",
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
              if (widget.bongpl.statut == "Ouvert") ...[
                Center(
                  child: Padding(
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
                ),
              ],
            ],
            if (prefUserInfo['role'] == 'Super Admin') ...[
              if (widget.bongpl.statut == "Ouvert") ...[
                Center(
                  child: Padding(
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
                ),
              ],
            ],
            if (prefUserInfo['role'] == 'Super Admin') ...[
              if (widget.bongpl.statut == "Approuvé") ...[
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
