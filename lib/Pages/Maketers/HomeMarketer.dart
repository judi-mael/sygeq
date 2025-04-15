// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_final_fields, unused_field

import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Models/TauxForfait.dart';
import 'package:sygeq/Models/Tauxtks.dart';
import 'package:sygeq/Pages/AllUser/Camions.dart';
import 'package:sygeq/Pages/AllUser/Transporteur.dart';
import 'package:sygeq/Pages/Maketers/ListBL.dart';
import 'package:sygeq/Pages/Maketers/ListBT.dart';
import 'package:sygeq/Pages/Maketers/MultiBL.dart';
import 'package:sygeq/Pages/Mic/GestionPerequation.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Pages/AllUser/Stations.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Statistiques/StatistiqueMarketer.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/Pages/AllUser/B2B.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/ListUsers.dart';
import 'package:sygeq/ui/HeaderDrawer.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/Notification.dart';
import 'package:sygeq/ui/Profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<Station> listMarkStation = [];
List<Driver> listMarkTransporteur = [];
List<Driver> listMarkTransporteurNC = [];
List<Driver> listMarkTransporteurC = [];

class HomeMarketer extends StatefulWidget {
  const HomeMarketer({Key? key}) : super(key: key);

  @override
  State<HomeMarketer> createState() => _HomeMarketerState();
}

class _HomeMarketerState extends State<HomeMarketer> {
  String state = "";
  int pagePosition = 0;
  int _selectedIndex = 0;
  bool _animate = true;
  bool _retour = false;
  // bool isSearch = false;

  List<Tauxtks> ttkActive = [];
  List<TauxForfait> tfsActive = [];
  List<int> listDate = [];
  int lastDate = 2100;
  String ttk = '0';
  String tfs = '0';
  late List<StatistiqueMarketer> liststatMark = [];
  int _year = DateTime.now().year;
  getListDate() async {
    for (int i = 2023; lastDate > i; i++) {
      setState(() {
        listDate.add(i);
      });
    }
  }

  getMicStat() async {
    var data = await MarketerRemoteService.statistiqueMarketer(_year);
    // if (!mounted) return null;
    setState(() {
      liststatMark = data;
    });

    return liststatMark;
  }

  getTtkActive() async {
    var data = await RemoteServices.getTtkActive();
    setState(() {
      ttkActive = data;
    });
    if (ttkActive.length > 0) {
      setState(() {
        ttk = ttkActive[0].valeurtk;
      });
    }
    return data;
  }

  getTfsActive() async {
    var data = await RemoteServices.getTfsActive();
    setState(() {
      tfsActive = data;
    });
    if (tfsActive.length > 0) {
      setState(() {
        tfs = tfsActive[0].tauxforfait;
      });
    }
    return data;
  }

  micGetVille() async {
    var res = await RemoteServices.allGetListeVilles();
    // if (!mounted) return null;
    setState(() {
      listMicVille = res;
    });
    return res;
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  marketerGetStation() async {
    var data = await RemoteServices.allGetListeStation();

    setState(() {
      listMarkStation = data;
    });
    setState(() {
      listMarkStation.removeWhere((element) => element.id == 0);
    });
  }

  @override
  void initState() {
    super.initState();
    marketerGetStation();
    getTtkActive();
    getTfsActive();
    getListDate();
    getMicStat();
    micGetVille();
  }

  @override
  void dispose() {
    super.dispose();
    // listCar.clear();
    listMarkStation.clear();
    listMarkTransporteurC.clear();
    listMarkTransporteurNC.clear();
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
                                  // textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: styleDrawer,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => MultiBL()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.add_box_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Ajouter un BL',
                                  // textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: styleDrawer,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => ListBT()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.library_add,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Bon de Transfère',
                                  // textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: styleDrawer,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Divider(
                      //   color: blue,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 10.0, left: 20),
                      //   child: GestureDetector(
                      //     onTap: (() {
                      //       Navigator.pop(context);
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: ((context) => ListBLGPLBouteille()),
                      //         ),
                      //       );
                      //     }),
                      //     child: Row(
                      //       children: [
                      //         Flexible(
                      //           child: Icon(Icons.oil_barrel,
                      //               size: 30, color: Colors.white),
                      //         ),
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         Flexible(
                      //           flex: 3,
                      //           child: Text(
                      //             'Bon GPL Bouteille',
                      //             overflow: TextOverflow.ellipsis,
                      //             maxLines: 1,
                      //             style: styleDrawer,
                      //             softWrap: true,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => ListBL()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.insert_drive_file_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Mes BL',
                                  // textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: styleDrawer,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => MicAddStation()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.local_gas_station_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Stations',
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
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: ((context) => B2B())),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.card_membership_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'B2B',
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
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => Transporteur()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.drive_eta_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Transporteur',
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
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => MicAddCamion()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.fire_truck_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Camions',
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
                      if (prefUserInfo['role'] != 'User') ...[
                        Divider(color: blue),
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
                      Divider(color: blue),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    ((context) => GestionPerequation(
                                      marketerId: prefUserInfo['marketerId'],
                                    )),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Icon(
                                  Icons.stacked_bar_chart,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Rapports',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
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
                                child: Text(
                                  "Besoin d'aide ?",
                                  style: styleDrawer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: blue),
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
                              // });
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
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
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
                body: Container(
                  decoration: logoDecoration(),
                  child:
                      pagePosition == 0
                          ? acceuilMarketer()
                          : pagePosition == 2
                          ? MesNotifications()
                          : Profil(),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              // elevation: 10,
              iconSize: 30,
              unselectedItemColor: gryClaie,
              selectedItemColor: blue,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.notification_add_rounded),
                //   label: 'Notification',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profil',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                // setState(() {
                //   _selectedIndex == index;
                // });
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
        );
  }

  Widget acceuilMarketer() {
    Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
            child: Wrap(
              // shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              // dragStartBehavior: DragStartBehavior.start,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: [
                Card(
                  color: tbordColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: blue,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        width:
                            _size.height < _size.width
                                ? _size.width / 2.5
                                : _size.height / 8,
                        child: Column(
                          children: [
                            Text(
                              "Stations",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textScaleFactor: 1,
                            ),
                            TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.route, color: blue),
                              label: Text(
                                "${listMarkStation.length}",
                                textScaleFactor: 1.2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: tbordColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        width:
                            _size.height < _size.width
                                ? _size.width / 2.5
                                : _size.height / 8,
                        child: Column(
                          // direction: Axis.vertical,
                          children: [
                            Text(
                              "Ttk encours",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textScaleFactor: 1,
                            ),
                            TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.swap_vert, color: blue),
                              label: Text(
                                ttk,
                                textScaleFactor: 1.2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: tbordColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: blue,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        width:
                            _size.height < _size.width
                                ? _size.width / 2.5
                                : _size.height / 8,
                        child: Column(
                          children: [
                            Text(
                              "Tf encours",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textScaleFactor: 1,
                            ),
                            TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.swap_horiz, color: blue),
                              label: Text(
                                "$tfs f/L",
                                textScaleFactor: 1.2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
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
          Padding(
            padding: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Container(
              // width: _size.height < _size.width ? _size.width : _size.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: tbordColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                    child: Container(
                      width:
                          _size.height > _size.width
                              ? _size.width / 3
                              : _size.width / 5,
                      child: DropdownSearch<int>(
                        selectedItem: _year,
                        // showSelectedItems: true,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            label: Text(
                              "Année",
                              softWrap: true,
                              textScaleFactor: 1,
                              overflow: TextOverflow.ellipsis,
                              style: styleG,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        popupProps: PopupProps.menu(),
                        items:
                            listDate.isEmpty
                                ? []
                                : listDate.map((e) => e).toList(),
                        onChanged: (value) {
                          setState(() {
                            _year = value!;
                            getMicStat();
                          });
                        },
                        // validator: (value) =>
                        //     value == null ? 'Choisissez le marketer' : null,
                        // onChanged: (String newValue) {
                        //   setState(() {

                        //   });
                        // },
                      ),
                    ),
                  ),
                  SfCartesianChart(
                    onMarkerRender: (MarkerRenderArgs markerargs) {},
                    plotAreaBorderWidth: 0,
                    legend: Legend(
                      title: LegendTitle(
                        alignment: ChartAlignment.near,
                        text: 'Statistique par produit',
                        textStyle: TextStyle(backgroundColor: Colors.white),
                      ),
                      alignment: ChartAlignment.center,
                      textStyle: TextStyle(color: blue),
                      isVisible: true,
                      position: LegendPosition.top,
                    ),
                    palette: [
                      Color.fromRGBO(75, 135, 185, 1),
                      Color.fromRGBO(192, 108, 132, 1),
                      Color.fromRGBO(246, 114, 128, 1),
                      Color.fromRGBO(248, 177, 149, 1),
                      Color.fromRGBO(116, 180, 155, 1),
                      Color.fromRGBO(0, 168, 181, 1),
                      Color.fromRGBO(73, 76, 162, 1),
                      Color.fromRGBO(255, 205, 96, 1),
                      Color.fromRGBO(255, 240, 219, 1),
                      Color.fromRGBO(238, 238, 238, 1),
                    ],
                    primaryXAxis: CategoryAxis(),
                    series: [
                      // series: <ChartSeries>[
                      if (liststatMark.length > 0) ...[
                        // for (int i = 0; i < liststatMark.length; i++) ...[
                        for (
                          int g = 0;
                          g < liststatMark[0].state.length;
                          g++
                        ) ...[
                          // for (var ele in liststatMark[i].state) ...[
                          StackedLineSeries<StatistiqueMarketer, String>(
                            groupName: liststatMark[0].state[g].produit,
                            isVisibleInLegend: true,
                            dataSource: liststatMark,
                            xValueMapper:
                                (StatistiqueMarketer sm, _) => sm.month,
                            yValueMapper:
                                (StatistiqueMarketer sm, _) =>
                                    sm.state[g].total,
                            name: liststatMark[0].state[g].produit,
                          ),
                        ],
                        // ]
                        // ]
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
