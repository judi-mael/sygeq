// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Models/StationBL.dart';
import 'package:sygeq/Pages/B2B/B2BScannerQR.dart';
import 'package:sygeq/Pages/DetailUpdate/DetailStation/detailStationBL.dart';

import 'package:sygeq/Services/SationRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/ListUsers.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/HeaderDrawer.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/Notification.dart';
import 'package:sygeq/ui/Profil.dart';
import 'package:sygeq/ui/UiForBL.dart';
import 'package:shared_preferences/shared_preferences.dart';

String potStationLat = "";
String potStationLong = "";
double posStationCompLat = 0.0;
double posStationCompLong = 0.0;
String potUserLat = "";
double posUserCompLat = 0.0;
String potUserLong = "";
double posUserCompLong = 0.0;
String potCamionLat = "";
double posCamionCompLat = 0.0;
String potCamionLong = "";
double posCamionCompLong = 0.0;
List<Station> listOneStation = [];

class HomeB2b extends StatefulWidget {
  const HomeB2b({Key? key}) : super(key: key);

  @override
  State<HomeB2b> createState() => _HomeB2bState();
}

class _HomeB2bState extends State<HomeB2b> {
  List<BonL> listSBL = [];
  bool _retour = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  int pagePosition = 0;
  int _selectedIndex = 0;
  bool _animate = true;
  actionOnTheStationShowDetailBl(
    var data,
    List<DetailLivraison> listDetailLivraison,
    Depot depot,
    Marketer marketer,
    Camion camion,
    StationBl station,
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
              child: DetailStationBL(
                data: data,
                listDetailLivraison: listDetailLivraison,
                camion: camion,
                depot: depot,
                driver: driver,
                marketer: marketer,
                station: station,
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await stationGetBL();
      });
    });
  }

  getOneStation() async {
    var data = await RemoteStationService.allOneStation(
      stationId: prefUserInfo['b2bId'].toString(),
    );
    setState(() {
      listOneStation = data;
    });
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), stationGetBL);
  }

  stationGetBL() async {
    var data = await RemoteStationService.stationGetListeBL();

    setState(() {
      listSBL = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    listSBL = [];
    getOneStation();
    stationGetBL();
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
                    "Vous allez être déconnetcter\n Voulez-vous continuer?",
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return deconnexionState
        ? deconnexionEncours()
        : WillPopScope(
          onWillPop: () async {
            if (_retour == true) {
              return true;
            } else {
              setState(() {
                abandonnerChargement();
              });
              return _retour;
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            drawer: Container(
              color: blue,
              width: _size.width / 1.50,
              child: NestedScrollView(
                controller: _scrollController,
                scrollBehavior: ScrollBehavior(),
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [HaederDrawer()];
                }),
                body: Padding(
                  padding: EdgeInsets.only(),
                  child: ListView(
                    children: [
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.home,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Accueil',
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleDrawer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (prefUserInfo['role'] != 'User') ...[
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 20),
                          child: GestureDetector(
                            onTap: (() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => CreateNewUser()),
                                ),
                              );
                            }),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    'Utilisateur',
                                    // textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: styleDrawer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => B2BScannerQR()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.qr_code_scanner_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Scanner un BC',
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleDrawer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {}),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.help_outline,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  "Besoin d'aide ?",
                                  softWrap: true,
                                  maxLines: 1,
                                  style: styleDrawer,
                                ),
                              ),
                            ],
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
                              Navigator.pop(context);
                              setState(() {
                                deconnexionState = true;
                              });
                              await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                deconnexionState = false;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              prefUserInfo.clear();
                              await clearAllList();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext ctx) => Login(),
                                ),
                                (route) => false,
                              );
                            }),
                            icon: Icon(Icons.logout, color: Colors.white),
                            label: Text(
                              "DECONNEXION",
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // backgroundColor: gryClaie,
            body: NestedScrollView(
              controller: _scrollController,
              scrollBehavior: ScrollBehavior(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: white,
                    elevation: 5,
                    leadingWidth: 2,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            'SyGeQ',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textScaleFactor: 1,
                          ),
                        ),
                        SizedBox(
                          width:
                              _size.height < _size.width
                                  ? _size.width / 2.6
                                  : _size.height / 6.5,
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                pagePosition = 2;
                                _selectedIndex = pagePosition;
                              });
                            },
                            icon: Icon(
                              Icons.notifications_active_outlined,
                              color: blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: Scaffold(
                resizeToAvoidBottomInset: true,
                body:
                    pagePosition == 0
                        ? acceuilStation()
                        : pagePosition == 2
                        ? MesNotifications()
                        : Profil(),
              ),
            ),
            bottomNavigationBar: ClipRRect(
              // borderRadius: BorderRadius.circular(50),
              child: BottomNavigationBar(
                // elevation: 10,
                iconSize: 30,
                backgroundColor: white,
                unselectedItemColor: gryClaie,
                selectedItemColor: blue,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.notification_add_rounded),
                  //   label: 'Notification',
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Menu',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (index) {
                  if (index == 2) {
                    _scaffoldKey.currentState?.openDrawer();
                  } else {
                    setState(() {
                      pagePosition = index;
                      _selectedIndex = pagePosition;
                    });
                  }
                },
              ),
            ),

            floatingActionButton:
                pagePosition == 0
                    ? FloatingActionButton(
                      backgroundColor: blue,
                      onPressed: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => B2BScannerQR()),
                          ),
                        );
                      }),
                      focusColor: blue,
                      child: Icon(Icons.add, color: Colors.white),
                    )
                    : null,
          ),
        );
  }

  Widget acceuilStation() {
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: logoDecoration(),
      child:
          _animate == true
              ? animationLoadingData()
              : listSBL.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyList(),
                    EmptyMessage(),
                    TextButton.icon(
                      style: TextButton.styleFrom(backgroundColor: blue),
                      onPressed: () {
                        setState(() {
                          stationGetBL();
                        });
                      },
                      icon: Icon(Icons.refresh, color: Colors.white, size: 30),
                      label: Text(
                        'Réessayer',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 25,
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
                        padding: EdgeInsets.only(top: 10, right: 5, left: 5),
                        child: Text(
                          "Listes de mes BL",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (listSBL.isNotEmpty)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 5,
                              right: 5,
                            ),
                            child: ListView.builder(
                              itemCount: listSBL.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, i) {
                                if (listSBL[i].statut != "Annulé" ||
                                    listSBL[i].statut != "Rejeté" ||
                                    listSBL[i].statut != "Ouvert") {
                                  return GestureDetector(
                                    onTap: () {
                                      var camion = listSBL[i].camion;
                                      var marketer = listSBL[i].marketer;
                                      var transporteur =
                                          listSBL[i].transporteur;
                                      var station = listSBL[i].station;
                                      var produits = listSBL[i].produits;
                                      var depot = listSBL[i].depot;

                                      var data = {
                                        "id": listSBL[i].id,
                                        "statut": listSBL[i].statut,
                                        "commentaire": listSBL[i].commentaire,
                                        "numBL": listSBL[i].numeroBl,
                                        "date": listSBL[i].date,
                                      };
                                      actionOnTheStationShowDetailBl(
                                        data,
                                        produits,
                                        depot,
                                        marketer,
                                        camion,
                                        station,
                                        transporteur,
                                      );
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         DetailStationBL(
                                      // data: data,
                                      // listDetailLivraison: produits,
                                      // camion: camion,
                                      // depot: depot,
                                      // driver: transporteur,
                                      // marketer: marketer,
                                      // station: station,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: cardStationorB2bBL(listSBL[i]),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ),
                      // if (listSBL.isEmpty)
                      //   Center(
                      //     child: ElevatedButton(
                      //       child: Text(
                      //         'Réessayer',
                      //         softWrap: true,
                      //         overflow: TextOverflow.ellipsis,
                      //         maxLines: 1,style: styleG,
                      //       ),
                      //       onPressed: () {
                      //         refresh();
                      //       },
                      //     ),
                      //   )
                    ],
                  ),
                ),
              ),
    );
  }
}
