// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/BonT.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
// import 'package:sygeq/Pages/Depot/DepotScannerQR.dart';
import 'package:sygeq/Pages/Depot/HomeDepot.dart';
import 'package:sygeq/Pages/Depot/detailDepotBT.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/UiForBL.dart';

class NosBT extends StatefulWidget {
  const NosBT({super.key});

  @override
  State<NosBT> createState() => _NosBTState();
}

class _NosBTState extends State<NosBT> {
  List<BonT> listSBT = [];
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  int pagePosition = 0;
  int _selectedIndex = 0;
  bool _retour = false;
  bool _animate = true;
  getOneDepot() async {
    var data = await RemoteDepotService.allOneDepot(
      depotId: prefUserInfo['depotId'].toString(),
    );
    setState(() {
      listOneDepot = data;
    });
    return data;
  }

  actionOnTheStationShowDetailBT(
    var data,
    List<DetailLivraison> listDetailLivraison,
    Depot depot,
    Marketer marketer,
    Camion camion,
    Depot destination,
    Driver driver,
  ) {
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
              padding: EdgeInsets.all(8.0),
              child: DetailDestinationBT(
                data: data,
                listDetailLivraison: listDetailLivraison,
                camion: camion,
                depot: depot,
                driver: driver,
                marketer: marketer,
                station: destination,
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await depotGetBT();
      });
    });
  }

  depotGetBT() async {
    var data = await RemoteDepotService.depotGetListeBT();
    setState(() {
      listSBT = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), depotGetBT);
  }

  @override
  void initState() {
    super.initState();
    listSBT = [];
    depotGetBT();
  }

  @override
  Widget build(BuildContext context) {
    // Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listSBT.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyList(),
                      EmptyMessage(mesaageText: "Vous n'avez aucun BT"),
                      TextButton.icon(
                        style: TextButton.styleFrom(backgroundColor: blue),
                        onPressed: () {
                          setState(() {
                            depotGetBT();
                          });
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: Text(
                          'Réessayer',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : RefreshIndicator(
                  onRefresh: refresh,
                  key: refreshKey,
                  child: SafeArea(
                    child: Column(
                      children: [
                        HeaderMic(),
                        Padding(
                          padding: EdgeInsets.only(top: 5, right: 30, left: 30),
                          child: Text(
                            "Bordereau de Transfère",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (listSBT.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                left: 3,
                                right: 3,
                              ),
                              child: ListView.builder(
                                itemCount: listSBT.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, i) {
                                  if (listSBT[i].statut != "Annulé" ||
                                      listSBT[i].statut != "Rejeté" ||
                                      listSBT[i].statut != "Ouvert") {
                                    return GestureDetector(
                                      onTap: () {
                                        var camion = listSBT[i].camion;
                                        var marketer = listSBT[i].marketer;
                                        var transporteur =
                                            listSBT[i].transporteur;
                                        var destination =
                                            listSBT[i].destination;
                                        var produits = listSBT[i].produits;
                                        var depot = listSBT[i].depot;

                                        var data = {
                                          'type': listSBT[i].marketer.type,
                                          'statut': listSBT[i].statut,
                                          "id": listSBT[i].id,
                                          "commentaire": listSBT[i].commentaire,
                                          "numBL": listSBT[i].numeroBl,
                                          "date": listSBT[i].date,
                                        };
                                        actionOnTheStationShowDetailBT(
                                          data,
                                          produits,
                                          depot,
                                          marketer,
                                          camion,
                                          destination,
                                          transporteur,
                                        );
                                      },
                                      child: cardDepotBT(listSBT[i]),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: blue,
      //   onPressed: (() {
      //     if (listOneDepot.isEmpty) {
      //       getOneDepot();
      //       setState(() {});
      //     } else {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: ((context) => DepotScannerQR()),
      //         ),
      //       ).then((value) {
      //         setState(() async {
      //           await depotGetBT();
      //         });
      //       });
      //     }
      //   }),
      //   focusColor: blue,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
