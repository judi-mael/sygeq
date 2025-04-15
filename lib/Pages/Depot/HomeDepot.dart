// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field, unused_import, deprecated_member_use

// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Helpers/BarChartWidget.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Pages/Depot/CreateBC.dart';
import 'package:sygeq/Pages/Depot/NewBC.dart';
import 'package:sygeq/Pages/Depot/NosBT.dart';
import 'package:sygeq/Pages/Depot/seachGplBouteilleCars.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/Statistiques/MicStatProduit.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/mode/chart_data.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/ListUsers.dart';
import 'package:sygeq/ui/HeaderDrawer.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/Notification.dart';
import 'package:sygeq/ui/Profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

var listOneDepot = {};

class HomeDepot extends StatefulWidget {
  const HomeDepot({Key? key}) : super(key: key);

  @override
  State<HomeDepot> createState() => _HomeDepotState();
}

class _HomeDepotState extends State<HomeDepot> {
  double limit = 0.0;
  List<StaProduit> listSatProductD = [];
  late TooltipBehavior _tooltip;
  final _controller = PageController(initialPage: 0);
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  int pagePosition = 0;
  int _selectedIndex = 0;
  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), starDepotperProduct);
  }

  getOneDepot() async {
    var data = await RemoteDepotService.allOneDepot(
      depotId: prefUserInfo['depotId'].toString(),
    );
    setState(() {
      listOneDepot = data;
    });
    return data;
  }

  starDepotperProduct() async {
    var data = await RemoteDepotService.starDepotperProduct();

    setState(() {
      listSatProductD = data;
    });
    for (var element in listSatProductD) {
      if (element.total.toDouble() > limit) {
        setState(() {
          limit = element.total.toDouble();
        });
      }
    }
    return data;
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

  @override
  void initState() {
    super.initState();
    getOneDepot();
    starDepotperProduct();
    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _retour = false;
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
                                  color: drawerIconColor(),
                                  size: 30,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (prefUserInfo['role'] == "Admin" ||
                          prefUserInfo['role'] == 'Super Admin')
                        Divider(color: blue),
                      // if (prefUserInfo['role'] == "Admin" ||
                      //     prefUserInfo['role'] == 'Super Admin')
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    ((context) => SearchGPLBouteilleCars(
                                      depotAppBar: true,
                                    )),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.spellcheck,
                                  color: drawerIconColor(),
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 4,
                                child: Text(
                                  'Charger du GPL Bouteille',
                                  textScaleFactor: 0.8,
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
                      if (prefUserInfo['role'] == "Admin" ||
                          prefUserInfo['role'] == 'Super Admin')
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 20),
                          child: GestureDetector(
                            onTap: (() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      ((context) => NewBC(depotAppBar: true)),
                                ),
                              );
                            }),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: drawerIconColor(),
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 4,
                                  child: Text(
                                    'Validation BL',
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
                      // if (prefUserInfo['role'] == "User" ||
                      //     prefUserInfo['role'] == 'Super Admin') ...[
                      Divider(color: blue),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    ((context) => CreateBC(depotAppBar: true)),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.sync,
                                  color: drawerIconColor(),
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Chargement BL',
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
                      // ],
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
                                    Icons.account_circle_outlined,
                                    color: drawerIconColor(),
                                    size: 30,
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
                      if (listOneDepot['type'] == "INTERIEUR") ...[
                        Divider(color: blue),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 20),
                          child: GestureDetector(
                            onTap: (() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NosBT(),
                                ),
                              );
                            }),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Icon(
                                    Icons.layers,
                                    color: drawerIconColor(),
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    "Bon de Transfère",
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
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {}),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.help_outline,
                                  color: drawerIconColor(),
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 3,
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
                        ? prefUserInfo['role'] == "User"
                            ? CreateBC(depotAppBar: false)
                            : prefUserInfo['role'] == "Admin"
                            ? NewBC(depotAppBar: false)
                            : acceuilDepot()
                        : pagePosition == 2
                        ? MesNotifications()
                        : Profil(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 10,
              iconSize: 30,
              // backgroundColor: blue,
              unselectedItemColor: gryClaie,
              selectedItemColor: blue,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                // BottomNavigationBarItem(
                //   icon: Icon(
                //     Icons.notification_add_rounded,
                //   ),
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

  Widget acceuilDepot() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // HeaderMic(),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 30,
            //   ),
            //   child: Text(
            //     "TABLEAU DE BORD DEPOT",
            //     softWrap: true,
            //     overflow: TextOverflow.ellipsis,
            //     maxLines: 1,
            //     style: GoogleFonts.montserrat(
            //       fontSize: 25,
            //     ),
            //   ),
            // ),
            Card(
              // elevation: 5,
              color: tbordColor,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  backgroundColor: tbordColor,
                  title: ChartTitle(
                    text: "Quantité vendue par produit",
                    textStyle: styleG,
                  ),
                  tooltipBehavior: _tooltip,
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    labelFormat: '{value}',
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    minimum: 0,
                    maximum: limit + 500,
                    interval: (limit + 500) / 5,
                  ),
                  series: [
                    // series: <ChartSeries<StaProduit, String>>[
                    ColumnSeries<StaProduit, String>(
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      dataSource: listSatProductD,
                      xValueMapper: (StaProduit data, _) => data.produit,
                      yValueMapper: (StaProduit data, _) => data.total,
                      color: Color.fromRGBO(56, 233, 159, 0.922),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Card(
                color: tbordColor,
                child: SfCircularChart(
                  tooltipBehavior: _tooltip,
                  legend: Legend(isVisible: true),
                  series: <CircularSeries<StaProduit, String>>[
                    PieSeries<StaProduit, String>(
                      strokeWidth: 50,
                      dataSource: listSatProductD,
                      xValueMapper: (StaProduit data, _) => data.produit,
                      yValueMapper: (StaProduit data, _) => data.total,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
