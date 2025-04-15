// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/ModelRapport/ModelTableau.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Pages/Depot/HomeDepot.dart';
import 'package:sygeq/Pages/Station/HomeStation.dart';
import 'package:sygeq/Services/SationRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class DepotConfirmBT extends StatefulWidget {
  final data;
  int bl;
  DepotConfirmBT({Key? key, required this.bl, required this.data})
    : super(key: key);

  @override
  State<DepotConfirmBT> createState() => _DepotConfirmBTState();
}

class _DepotConfirmBTState extends State<DepotConfirmBT> {
  // List blList = [];
  final formKey = GlobalKey<FormState>();
  List<ModelQtteAvantApres> listAvantApres = [];
  List<DetailLivraison>? listDetail = [];
  bool widgetAvant = true;
  bool _floatinaction = false;
  bool widgetApres = false;
  bool _retour = false;
  var blList;
  bool _animate = true;
  getInforBl() async {
    if (widget.data.toString().isEmpty) {
      var data = await RemoteStationService.stationGetBL(code: widget.bl);
      if (!mounted) return null;
      var result = json.decode(data.toString());
      setState(() {
        blList = result["data"];
        // listDetail = blList["produits"] as List<DetailLivraison>;
        listDetail =
            (blList["produits"] as List)
                .map((i) => DetailLivraison.fromJson(i))
                .toList();
      });
      setState(() {
        _animate = false;
      });
    } else {
      setState(() {
        blList = widget.data;
        listDetail =
            (blList["produits"] as List)
                .map((i) => DetailLivraison.fromJson(i))
                .toList();
        _animate = false;
      });
    }
  }

  updateBL() async {
    var data = await RemoteStationService.staionUpdateBL(
      code: widget.bl,
      dataApresAvant: listAvantApres,
    );
    return data;
  }

  actionQtteApres() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Après déchargemment \nVeuillez renseigner la quantité au niveau des curves pour les produits suivants",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            for (int a = 0; listDetail!.length > a; a++) ...[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: TextFormField(
                  // onChanged: (value) {
                  //   setState(() {
                  //     listAvantApres[a] = ModelQtteAvantApres(
                  //         listDetail![a].id.toString(),
                  //         listAvantApres[a].qteAvant,
                  //         value);
                  //   });
                  // },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Ce champs est obligatoire";
                    } else {
                      setState(() {
                        listAvantApres[a] = ModelQtteAvantApres(
                          listDetail![a].id.toString(),
                          listAvantApres[a].qteAvant,
                          value,
                        );
                      });
                      return null;
                    }
                    // return value!.isEmpty ? "Ce champs est obligatoire" :;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text(
                      " Quantité de ${listDetail![a].produit.nom}",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    backgroundColor: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Soumettre",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(fontSize: 25, color: white),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      alertDechargement();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  actionQtteAvant() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Avant déchargemment\n Veuillez renseigner la quantité au niveau des curves pour les produits suivants",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            for (int a = 0; listDetail!.length > a; a++) ...[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: TextFormField(
                  // onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Ce champs est obligatoire";
                    } else {
                      setState(() {
                        listAvantApres.insert(
                          a,
                          ModelQtteAvantApres(
                            listDetail![a].id.toString(),
                            value,
                            '0',
                          ),
                        );
                      });
                      return null;
                    }
                    // return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text(
                      " Quantité de ${listDetail![a].produit.nom}",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    backgroundColor: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Suivant",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(fontSize: 25, color: white),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // setState(() {
                      //   _wilAvant = true;
                      // });
                      // Navigator.pop(context);
                      setState(() {
                        _floatinaction = true;
                        widgetAvant = false;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  alertDechargement() {
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
                  "Je certifie les informations du BL",
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
                await updateBL();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeDepot()),
                );
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

  @override
  void initState() {
    getInforBl();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  abandonnerChargement() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Container(
            child: Column(
              children: [
                Icon(Icons.dangerous, color: red, size: 30),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Voulez-vous annuler le processus de déchargement  en cours?",
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: styleG,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: blue),
              onPressed: () {
                setState(() {
                  _retour = true;
                });
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "Oui",
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styleG,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: gry),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Non",
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styleG,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_retour == true) {
          return true;
        } else {
          setState(() {
            abandonnerChargement();
          });
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          iconTheme: IconThemeData(
            color: gryClaie, //change your color here
          ),
          centerTitle: true,
          title: Text("Confirmation du BL", style: styleAppBar),
        ),
        // backgroundColor: gryClaie,
        body: Container(
          decoration: logoDecoration(),
          margin: EdgeInsets.only(bottom: 100),
          child:
              _animate == true
                  ? animationLoadingData()
                  : blList != null
                  ? blList['statut'] != "Chargé"
                      ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding:
                              _size.height < _size.width
                                  ? EdgeInsets.only(top: _size.width / 7)
                                  : EdgeInsets.only(top: _size.height / 3),
                          child: Column(
                            children: [
                              Center(
                                // heightFactor: _size.height < _size.width
                                //     ? _size.width / 100
                                //     : _size.height / 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Impossible de rétrouvé les informations de ce BL car il a déjà été décharger.\n Merci de bien vouloir Scanner un autre BL",
                                    softWrap: true,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    // style: styleG,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  updateBL().then((val) {
                                    fToast.showToast(
                                      child: toastWidget(val),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration: Duration(seconds: 5),
                                    );
                                  });
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeStation(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blue,
                                ),
                                child: Text("Quitter"),
                              ),
                            ],
                          ),
                        ),
                      )
                      : widgetAvant == true
                      ? actionQtteAvant()
                      : widgetApres == true
                      ? actionQtteApres()
                      : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Numéro :${blList["numeroBL"]}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Camion',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right: 5,
                                  left: 5,
                                ),
                                child: Card(
                                  // color: Color.fromRGBO(255, 255, 255, 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Card(
                                            color: blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.drive_eta,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${blList["camion"]["marque"]} - ${blList["camion"]["imat"]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Transporteur :${blList["transporteur"]["nom"]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w200,
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
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Station',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right: 5,
                                  left: 5,
                                ),
                                child: Card(
                                  // color: Color.fromRGBO(255, 255, 255, 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Card(
                                            color: blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Icon(
                                                Icons
                                                    .local_gas_station_outlined,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'A destination de :',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                              Text(
                                                '${blList["station"]["nom"]}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
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
                              Card(
                                color: Color.fromRGBO(236, 233, 233, 1),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0xFF555555)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      for (
                                        int a = 0;
                                        listDetail!.length > a;
                                        a++
                                      ) ...[
                                        Card(
                                          // color: Color.fromRGBO(255, 255, 255, 0.4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Card(
                                                    color: blue,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      child: Icon(
                                                        Icons
                                                            .water_drop_outlined,
                                                        color: Colors.white,
                                                        size: 35,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Flexible(
                                                  flex: 6,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${listDetail![a].qtte} ${listDetail![a].produit.unite} de ${listDetail![a].produit.nom} ",
                                                        softWrap: true,
                                                        maxLines: 3,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        // style: GoogleFonts
                                                        //     .montserrat(
                                                        //   fontSize: 15,
                                                        //   fontWeight:
                                                        //       FontWeight.bold,
                                                        // ),
                                                      ),

                                                      // Spacer(),
                                                      for (
                                                        int b = 0;
                                                        listDetail![a]
                                                                .barecode
                                                                .length >
                                                            b;
                                                        b++
                                                      ) ...[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                flex: 2,
                                                                child: Icon(
                                                                  Icons
                                                                      .dashboard,
                                                                  size: 18,
                                                                  color: red,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Flexible(
                                                                flex: 4,
                                                                child: Text(
                                                                  "Compartiment : ${listDetail![a].barecode[b].compartiment.numero}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  softWrap:
                                                                      true,
                                                                  // style: styleG,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Icon(
                                                                  Icons.scanner,
                                                                  size: 18,
                                                                  color: green,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Flexible(
                                                                flex: 4,
                                                                child: Text(
                                                                  "Code barre : ${listDetail![a].barecode[b].barcorde}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  softWrap:
                                                                      true,
                                                                  // style: styleG,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding:
                          _size.height < _size.width
                              ? EdgeInsets.only(top: _size.width / 7)
                              : EdgeInsets.only(top: _size.height / 3),
                      child: Column(
                        children: [
                          Center(
                            // heightFactor: _size.height < _size.width
                            //     ? _size.width / 100
                            //     : _size.height / 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Impossible de rétrouvé les informations de ce BL car il a déjà été décharger.\n Merci de bien vouloir Scanner un autre BL",
                                softWrap: true,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                // style: styleG,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              updateBL().then((val) {
                                fToast.showToast(
                                  child: toastWidget(val),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 5),
                                );
                              });
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeStation(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                            ),
                            child: Text("Quitter"),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
        floatingActionButton:
            blList != null
                ? _floatinaction == false
                    ? null
                    : Visibility(
                      visible: blList['statut'] == "Chargé" ? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 224, 217, 217),
                          ),
                          margin: EdgeInsets.only(left: 30),
                          // decoration: ,
                          // color: Colors.white,
                          width: double.infinity,

                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: red),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: (() {
                                    abandonnerChargement();
                                  }),
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
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: (() {
                                    setState(() {
                                      _floatinaction = false;
                                      widgetApres = true;
                                    });
                                    // alertDechargement();
                                    // updateBL().then((value) {});
                                  }),
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  label: Text(
                                    "Confirmer",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: btnTxtCOlor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                : null,
      ),
    );
  }
}
