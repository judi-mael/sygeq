// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/DetailChargement.dart';
import 'package:sygeq/Models/DetailCodeBarre.dart';
import 'package:sygeq/Pages/Depot/UpdateDetailChargement.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateBLCharge extends StatefulWidget {
  BonL bonLivraison;
  UpdateBLCharge({super.key, required this.bonLivraison});

  @override
  State<UpdateBLCharge> createState() => _UpdateBLChargeState();
}

class _UpdateBLChargeState extends State<UpdateBLCharge> {
  List<DetailChargement> listDetail = [];
  updateBardeCode(DetailCodeBarre detailCode) {
    showGeneralDialog(
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      context: context,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              insetPadding: EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Updatedetailchargement(detailCode: detailCode),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        getDetailChargement();
      });
    });
  }

  rejeterChargement() async {
    var data = await RemoteDepotService.rejeterChagement(
      widget.bonLivraison.id,
    );
    return data;
  }

  alertEnnulation() {
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
                  "Vous allez annuler le chargement du BL",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
                Text(
                  "Vous-êtes sûr(e) de vouloir continuer ?",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await rejeterChargement();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: blue),
              child: Text("Oui", style: GoogleFonts.montserrat(color: white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text("Non", style: GoogleFonts.montserrat(color: white)),
            ),
          ],
        );
      },
    );
  }

  getDetailChargement() async {
    var data = await RemoteDepotService.getDetailChargement(
      widget.bonLivraison.id,
    );
    setState(() {
      listDetail = data;
    });
    return listDetail;
  }

  @override
  void initState() {
    super.initState();
    getDetailChargement();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () {
                alertEnnulation();
              },
              child: Text(
                'Annuler le chargement',
                textScaleFactor: 0.8,
                style: GoogleFonts.montserrat(color: white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  widget.bonLivraison.numeroBl,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (int u = 0; listDetail.length > u; u++)
                Card(
                  elevation: 3,
                  // color: blue.withOpacity(0.1),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          listDetail[u].produits.nom,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Détails chargement',
                          textScaleFactor: 0.9,
                          style: GoogleFonts.montserrat(
                            color: blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            for (
                              int i = 0;
                              listDetail[u].detailcodeBarre.length > i;
                              i++
                            )
                              Container(
                                width:
                                    _size.height > _size.width
                                        ? _size.width / 2.3
                                        : _size.height / 2.5,
                                // width: ,
                                child: GestureDetector(
                                  onTap: () {
                                    updateBardeCode(
                                      listDetail[u].detailcodeBarre[i],
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    color: blue,
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              "Compartiment N°${listDetail[u].detailcodeBarre[i].compartiment.numero}",
                                              style: GoogleFonts.montserrat(
                                                color: white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Code barre',
                                                        textScaleFactor: 0.8,
                                                        style:
                                                            GoogleFonts.montserrat(
                                                              color: white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                      Text(
                                                        "${listDetail[u].detailcodeBarre[i].barcode}",
                                                        textScaleFactor: 0.7,
                                                        style:
                                                            GoogleFonts.montserrat(
                                                              color: white,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Flexible(
                                                  flex: 1,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Creu chargé',
                                                        textScaleFactor: 0.8,
                                                        style:
                                                            GoogleFonts.montserrat(
                                                              color: white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                      Text(
                                                        "${listDetail[u].detailcodeBarre[i].creuCharger}",
                                                        textScaleFactor: 0.7,
                                                        style:
                                                            GoogleFonts.montserrat(
                                                              color: white,
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
}
