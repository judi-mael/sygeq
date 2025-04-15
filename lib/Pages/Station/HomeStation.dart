// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field, unused_local_variable, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Models/StationBL.dart';
import 'package:sygeq/Pages/DetailUpdate/DetailStation/detailStationBL.dart';

import 'package:sygeq/Pages/Station/ScannerQR.dart';
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

class HomeStation extends StatefulWidget {
  final bool refreshData;
  const HomeStation({Key? key, this.refreshData = false}) : super(key: key);

  @override
  State<HomeStation> createState() => _HomeStationState();
}

class _HomeStationState extends State<HomeStation>
    with TickerProviderStateMixin {
  List<BonL> listSBL = [];
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  int pagePosition = 0;
  int _selectedIndex = 0;
  bool _retour = false;
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

  void didUpdateWidget(covariant HomeStation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshData) {
      setState(() {
        _animate = true;
      });
      stationGetBL();
    }
  }

  getOneStation() async {
    var data = await RemoteStationService.allOneStation(
      stationId: prefUserInfo['stationId'].toString(),
    );
    setState(() {
      listOneStation = data;
    });
    return data;
  }

  verifyOneStation() async {
    var data = await RemoteStationService.allOneStation(
      stationId: prefUserInfo['stationId'].toString(),
    );
    if (data == 'Station introuvable') {
      return false;
    } else {
      setState(() {
        listOneStation = data;
      });
      return true;
    }
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
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    tabController.addListener(() {
      stationGetBL();
    });
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

  late TabController tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    // Size _sizeh = _size.height < _size.width
    //     ? MediaQuery.of(context).size.width * 0.21
    //     : MediaQuery.of(context).
    //size.height * 0.21;
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
            appBar: AppBar(
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
              bottom:
                  pagePosition != 0
                      ? null
                      : TabBar(
                        dragStartBehavior: DragStartBehavior.start,
                        tabAlignment: TabAlignment.center,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        labelColor: white,
                        unselectedLabelStyle: TextStyle(color: Colors.black),
                        isScrollable: true,
                        indicator: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        controller: tabController,
                        tabs: [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Chargés",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Déchargés",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
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
                                builder: ((context) => ScannerQR()),
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
            body:
                pagePosition == 0
                    ? acceuilStation()
                    : pagePosition == 1
                    ? Profil()
                    : MesNotifications(),

            bottomNavigationBar: BottomNavigationBar(
              // elevation: 10,
              iconSize: 30,
              // backgroundColor: blue,
              unselectedItemColor: gryClaie,
              selectedItemColor: blue,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profil',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
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

            floatingActionButton:
                pagePosition == 0
                    ? FloatingActionButton(
                      backgroundColor: blue,
                      onPressed: (() {
                        _getCurrentPosition();
                        // stateUserPassiontion();
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
                    EmptyMessage(mesaageText: "Vous n'avez aucun BL"),
                    TextButton.icon(
                      style: TextButton.styleFrom(backgroundColor: blue),
                      onPressed: () {
                        setState(() {
                          stationGetBL();
                        });
                      },
                      icon: Icon(Icons.refresh, color: Colors.white, size: 25),
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
              : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: TabBarView(
                          controller: tabController,
                          physics: ScrollPhysics(),
                          children: [
                            getBLStatut("Chargé"),
                            getBLStatut("Déchargé"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      serviceEnabled = await Geolocator.openAppSettings();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            content: Text(
              "Les services de localisation sont nécessaires pour utiliser cette fonctionnalité.",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        );
      }
    }
    if (!mounted) return null;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission asked = await Geolocator.requestPermission();
    } else if (serviceEnabled == true &&
        (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse)) {
      Position currentPosotion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        localisation = "$currentPosotion";
        positionLat = currentPosotion.latitude;
        positionLog = currentPosotion.longitude;
      });
      verifyOneStation().then((value) {
        if (value == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
              content: Text(
                "Station introuvable",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => ScannerQR())),
          ).then((value) {
            setState(() async {
              await stationGetBL();
            });
          });
        }
      });
    }
  }

  getBLStatut(String statut) {
    bool isNonNull = true;
    for (var element in listSBL) {
      if (element.statut == statut) {
        setState(() {
          isNonNull = false;
        });
      }
    }
    return isNonNull == false
        ? ListView.builder(
          itemCount: listSBL.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, i) {
            if (listSBL[i].statut == statut) {
              return GestureDetector(
                onTap: () {
                  var camion = listSBL[i].camion;
                  var marketer = listSBL[i].marketer;
                  var transporteur = listSBL[i].transporteur;
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
                },
                child: cardStationorB2bBL(listSBL[i]),
              );
            } else {
              return Container();
            }
          },
        )
        : ListView(
          children: [
            SizedBox(height: 100),
            EmptyList(),
            EmptyMessage(mesaageText: "Vous n'avez aucun BL $statut"),
          ],
        );
  }
}
