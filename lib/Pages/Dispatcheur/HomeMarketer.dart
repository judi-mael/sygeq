// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/Detail/DetailBL.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/Detail/DetailBLDispatcheur.dart';
// import 'package:sygeq/Pages/Dispatcher/Contrat.dart';
import 'package:sygeq/Pages/Dispatcheur/Contrat.dart';
import 'package:sygeq/Pages/Dispatcheur/CreateBL.dart';
import 'package:sygeq/Pages/Dispatcheur/DashBordMarketer.dart';
import 'package:sygeq/Pages/Dispatcheur/ListeAgent.dart';
import 'package:sygeq/Pages/Dispatcheur/NewUser.dart';
import 'package:sygeq/Pages/profil/DetailProfil.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Station> listMarkStation = [];
List<Driver> listMarkTransporteur = [];

class HomeDispatcheur extends StatefulWidget {
  const HomeDispatcheur({Key? key}) : super(key: key);

  @override
  State<HomeDispatcheur> createState() => _HomeDispatcheurState();
}

class _HomeDispatcheurState extends State<HomeDispatcheur> {
  List<BonL> listMBL = [];
  bool isSearch = false;
  bool isApprouver = false;
  bool isEnAttent = false;
  bool isCharger = false;
  bool isDecharger = false;
  bool isAnnuler = false;
  bool isOuverte = false;
  bool isBon = false;
  String state = "";
  // bool isSearch = false;
  getBlMarketer() async {
    var data = await MarketerRemoteService.allGetListeBL();
    if (!mounted) return null;
    setState(() {
      listMBL = data;
    });
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getBlMarketer);
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  marketerGetStation() async {
    var data = await RemoteServices.allGetListeStation();
    setState(() {
      listMarkStation = data;
    });
    return data;
  }

  marketerGetTransporteur() async {
    var data = await RemoteServices.allGetListeTransporteur();
    setState(() {
      listMarkTransporteur = data;
    });
    return data;
  }

  getBlByState() {
    return ListView.builder(
      itemCount: listMBL.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: ((context, index) {
        if (listMBL[index].statut == state) {
          return GestureDetector(
            onTap: () {
              var camion = listMBL[index].camion;
              var marketer = listMBL[index].marketer;
              var transporteur = listMBL[index].transporteur;
              var station = listMBL[index].station;
              var produits = listMBL[index].produits;
              var depot = listMBL[index].depot;

              var data = {
                "id": listMBL[index].id,
                "commentaire": listMBL[index].commentaire,
                "numBL": listMBL[index].numeroBl,
                "date": listMBL[index].date,
                'statut': listMBL[index].statut,
              };
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailBLDispatcheur(
                        data: data,
                        listDetailLivraison: produits,
                        camion: camion,
                        depot: depot,
                        driver: transporteur,
                        marketer: marketer,
                        station: station,
                      ),
                ),
              ).then((value) => getBlMarketer());
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              listMBL[index].numeroBl,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              listMBL[index].marketer.nom,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              listMBL[index].station.nom,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              listMBL[index].statut,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              listMBL[index].transporteur.nom,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              listMBL[index].camion.imat,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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
        } else {
          return Container();
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    getBlMarketer();
    marketerGetStation();
    marketerGetTransporteur();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: gryClaie,
      primary: true,
      drawer: Container(
        color: gryClaie,
        width: _size.width / 1.25,
        child: ListView(
          children: [
            Container(
              height:
                  _size.height < _size.width
                      ? MediaQuery.of(context).size.width / 10
                      : MediaQuery.of(context).size.height / 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/Images/gov_logo.png",
                    width: MediaQuery.of(context).size.width / 5,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ministère de l'Industrie et du Commerce",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: styleG,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height:
                                    _size.height < _size.width
                                        ? MediaQuery.of(context).size.width /
                                            150
                                        : MediaQuery.of(context).size.height /
                                            150,
                                width:
                                    _size.height < _size.width
                                        ? MediaQuery.of(context).size.width / 10
                                        : MediaQuery.of(context).size.height /
                                            20,
                                // height: 5,
                                // width: 40,
                                color: green,
                              ),
                              Container(
                                height:
                                    _size.height < _size.width
                                        ? MediaQuery.of(context).size.width /
                                            150
                                        : MediaQuery.of(context).size.height /
                                            150,
                                width:
                                    _size.height < _size.width
                                        ? MediaQuery.of(context).size.width / 10
                                        : MediaQuery.of(context).size.height /
                                            20,
                                color: yello,
                              ),
                              Container(
                                height:
                                    _size.height < _size.width
                                        ? MediaQuery.of(context).size.width /
                                            150
                                        : MediaQuery.of(context).size.height /
                                            150,
                                width:
                                    _size.height < _size.width
                                        ? MediaQuery.of(context).size.width / 10
                                        : MediaQuery.of(context).size.height /
                                            20,
                                color: red,
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
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                }),
                child: Text(
                  'Accueil',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => DashBordDispatcheur()),
                    ),
                  ).then((value) => getBlMarketer());
                }),
                child: Text(
                  'Tableau de bord',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => CreateBLDispatcheur()),
                    ),
                  ).then((value) => getBlMarketer());
                }),
                child: Text(
                  'Nouveau BL',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => NewUserDispatcheur()),
                    ),
                  );
                }),
                child: Text(
                  'Nouvel Agent',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => ListeAgentDispatcheur()),
                    ),
                  );
                }),
                child: Text(
                  'Liste des Agents',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransMarkContratDispatcheur(),
                    ),
                  );
                }),
                child: Text(
                  'Contrat',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailProfil()),
                  );
                }),
                child: Text(
                  'Mon profil',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20),
              child: GestureDetector(
                onTap: (() {}),
                child: Text(
                  "Besoin d'aide ?",
                  style: styleDrawer,
                  softWrap: true,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: red,
                ),
                child: TextButton.icon(
                  // style: TextButton.styleFrom(),
                  onPressed: (() async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext ctx) => Login()),
                      (route) => false,
                    );
                  }),
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    "DECONNEXION",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Bonjour ${prefUserInfo['name']}",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refresh,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderMic(),
              Padding(
                padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                child: Text(
                  "BONS DE LIVRAISON",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                  bottom: 5,
                ),
                child: Container(
                  height: 40,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearch = false;
                            isAnnuler = false;
                            isApprouver = false;
                            isBon = false;
                            isCharger = false;
                            isDecharger = false;
                            isEnAttent = false;
                            isOuverte = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isSearch
                                    ? Color.fromARGB(55, 202, 136, 240)
                                    : green,
                          ),
                          child: Text(
                            "Tout mes BL",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: styleG,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearch = true;
                            isApprouver = true;
                            isAnnuler = false;
                            isBon = false;
                            isCharger = false;
                            isDecharger = false;
                            isEnAttent = false;
                            isOuverte = false;
                            state = "Approuvé";
                            getBlByState();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isApprouver
                                    ? green
                                    : Color.fromARGB(55, 202, 136, 240),
                          ),
                          child: Text(
                            "Relâché",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: isApprouver ? stylecolorText : styleG,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            state = "En attente";
                            isSearch = true;
                            isApprouver = false;
                            isAnnuler = false;
                            isBon = false;
                            isCharger = false;
                            isDecharger = false;
                            isEnAttent = true;
                            isOuverte = false;
                            getBlByState();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isEnAttent
                                    ? green
                                    : Color.fromARGB(55, 202, 136, 240),
                          ),
                          child: Text(
                            "En attente",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: isEnAttent ? stylecolorText : styleG,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            state = "Chargé";
                            isSearch = true;
                            isApprouver = false;
                            isAnnuler = false;
                            isBon = false;
                            isCharger = true;
                            isDecharger = false;
                            isEnAttent = false;
                            isOuverte = false;
                            getBlByState();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isCharger
                                    ? green
                                    : Color.fromARGB(55, 202, 136, 240),
                          ),
                          child: Text(
                            "Chargé",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: isCharger ? stylecolorText : styleG,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            state = "Bon à chargé";
                            isSearch = true;
                            isApprouver = false;
                            isAnnuler = false;
                            isBon = true;
                            isCharger = false;
                            isDecharger = false;
                            isEnAttent = false;
                            isOuverte = false;
                            getBlByState();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isBon
                                    ? green
                                    : Color.fromARGB(55, 202, 136, 240),
                          ),
                          child: Text(
                            "Bon à chargé",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: isBon ? stylecolorText : styleG,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            state = "Déchargé";
                            isSearch = true;
                            isApprouver = false;
                            isAnnuler = false;
                            isBon = false;
                            isCharger = false;
                            isDecharger = true;
                            isEnAttent = false;
                            isOuverte = false;
                            getBlByState();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isDecharger
                                    ? green
                                    : Color.fromARGB(55, 202, 136, 240),
                          ),
                          child: Text(
                            "Déchargé",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: isDecharger ? stylecolorText : styleG,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            state = "Annulé";
                            isSearch = true;
                            isApprouver = false;
                            isAnnuler = true;
                            isBon = false;
                            isCharger = false;
                            isDecharger = false;
                            isEnAttent = false;
                            isOuverte = false;
                            getBlByState();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isAnnuler
                                    ? green
                                    : Color.fromARGB(55, 202, 136, 240),
                          ),
                          child: Text(
                            "Annuler",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: isAnnuler ? stylecolorText : styleG,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            state = "Ouvert";
                            isSearch = true;
                            isApprouver = false;
                            isAnnuler = false;
                            isBon = false;
                            isCharger = false;
                            isDecharger = false;
                            isEnAttent = false;
                            isOuverte = true;
                            getBlByState();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                          ),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                isOuverte
                                    ? green
                                    : Color.fromARGB(55, 202, 136, 240),
                          ),
                          child: Text(
                            "Ouvert",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: isOuverte ? stylecolorText : styleG,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(211, 150, 148, 148),
                height: _size.height / 200,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Container(
                  color: gryClaie,
                  child:
                      isSearch
                          ? getBlByState()
                          : ListView.builder(
                            itemCount: listMBL.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                onTap: () {
                                  var camion = listMBL[index].camion;
                                  var marketer = listMBL[index].marketer;
                                  var transporteur =
                                      listMBL[index].transporteur;
                                  var station = listMBL[index].station;
                                  var produits = listMBL[index].produits;
                                  var depot = listMBL[index].depot;

                                  var data = {
                                    "id": listMBL[index].id,
                                    "commentaire": listMBL[index].commentaire,
                                    "numBL": listMBL[index].numeroBl,
                                    "date": listMBL[index].date,
                                    'statut': listMBL[index].statut,
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailBL(
                                            data: data,
                                            listDetailLivraison: produits,
                                            camion: camion,
                                            depot: depot,
                                            driver: transporteur,
                                            marketer: marketer,
                                            station: station,
                                          ),
                                    ),
                                  ).then((value) => getBlMarketer());
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  listMBL[index].numeroBl,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  listMBL[index].marketer.nom,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  listMBL[index].station.nom,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  listMBL[index].statut,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  listMBL[index]
                                                      .transporteur
                                                      .nom,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  listMBL[index].camion.imat,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
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
                            }),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => CreateBLDispatcheur())),
          ).then((value) => getBlMarketer());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
