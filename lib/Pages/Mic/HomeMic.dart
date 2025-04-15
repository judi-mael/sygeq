// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_field, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Models/CircularStart.dart';
import 'package:sygeq/Models/CountElement.dart';
import 'package:sygeq/Models/TauxForfait.dart';
import 'package:sygeq/Models/Tauxtks.dart';
import 'package:sygeq/Pages/AllUser/B2B.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Statistiques/StartPerRegion.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:http/http.dart' as http;
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Models/SsatMarkers.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Models/Viehicul.dart';
import 'package:sygeq/Models/Ville.dart';
import 'package:sygeq/Pages/AllUser/Camions.dart';
import 'package:sygeq/Pages/Mic/DepotDouanier.dart';
import 'package:sygeq/Pages/Mic/Marketer.dart';
import 'package:sygeq/Pages/Mic/Produit.dart';
import 'package:sygeq/Pages/AllUser/Stations.dart';
import 'package:sygeq/Pages/Mic/TauxForfait.dart';
import 'package:sygeq/Pages/Mic/TauxTK.dart';
import 'package:sygeq/Pages/AllUser/Transporteur.dart';
import 'package:sygeq/Pages/Mic/Villes.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Statistiques/MicStatProduit.dart';
import 'package:sygeq/Statistiques/MicStatProduitMarketer.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/ListUsers.dart';
import 'package:sygeq/ui/HeaderDrawer.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/Notification.dart';
import 'package:sygeq/ui/Profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<SsatMarkers> listSsatStation = [];
List<SsatMarkers> listSsatB2B = [];
List<Marketer> listMicMarketer = [];

List<Depot> listMicDepot = [];
List<Ville> listMicVille = [];
List<Station> listStation = [];
List<Vehicule> listMicVehicul = [];
List<Produit> listProduit = [];

class HomeMic extends StatefulWidget {
  const HomeMic({Key? key}) : super(key: key);

  @override
  State<HomeMic> createState() => _HomeMicState();
}

class _HomeMicState extends State<HomeMic> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  static var client = http.Client();
  List<Tauxtks> ttkActive = [];
  List<TauxForfait> tfsActive = [];
  List<StaProduit> listSatProduct = [];
  List<StartPerRegion> listPerRegion = [];
  List<StarProduitMarketer> listSatProductMarketer = [];
  List<String>? titles = [];
  late TooltipBehavior _tooltip;
  List<CircularDataStart> circularData = [];
  double limit = 0.0;
  int pagePosition = 0;
  int _selectedIndex = 0;
   CountElement nombreElement=CountElement(marketer: 0, station: 0, transporteur: 0, depot: 0, b2b: 0, camion: 0);
  String ttk = '0';
  String tfs = '0';
  int _distance = 0;
  String _filterStartDebutDate = "";
  String _filterStartFinDate = "";
  final DateTime _filterDateDebut = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  final DateTime _filterDateFin = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  );
  String _dateStart = "";
  String _dateFin = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
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
        _distance = double.parse(tfsActive[0].distance).round();
      });
    }
    return data;
  }

  misGetVehiculList() async {
    var data = await RemoteServices.micGetSsatListVehicul();
    setState(() {
      listMicVehicul = data;
    });
    return data;
  }

  micGetStation() async {
    var data = await RemoteServices.allGetListeStation();
    // if (!mounted) return null;
    setState(() {
      listStation = data;
    });
    return data;
  }

  // String
  micGetMarketerList() async {
    var data = await RemoteServices.getAllMarketerList();

    // if (!mounted) return null;
    setState(() {
      listMicMarketer = data;
    });
    return data;
  }

  micGetProduit() async {
    var res = await RemoteServices.allGetListeProduits();
    // if (!mounted) return null;
    setState(() {
      listProduit = res;
    });
    return listProduit;
  }

  micGetTransporteurList() async {
    var data = await RemoteServices.allGetListeTransporteur();
    setState(() {
      listMicTransporteur = data;
    });
    return data;
  }

  micGetDepotList() async {
    var data = await RemoteServices.allGetListedepot();
    // if (!mounted) return null;
    setState(() {
      listMicDepot = data;
    });
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

  getStatPer() async {
    var data = await RemoteServices.statPerProduit(_dateStart, _dateFin);
    var starMark = await RemoteServices.statPerProduitMarketer(
      _dateStart,
      _dateFin,
    );
    var starPerRegion = await RemoteServices.statPerRegion(
      _dateStart,
      _dateFin,
    );
    // if (!mounted) return null;
    setState(() {
      listSatProduct = data;
      listPerRegion = starPerRegion;
      listSatProductMarketer = starMark;
      circularData = [];
    });

    if (listSatProductMarketer.isEmpty) {
      setState(() {
        circularData = [];
      });
    } else {
      for (var element in listSatProductMarketer) {
        double total_Value = 0;
        for (var value in element.produit) {
          // setState(() {
          total_Value += value.total;
          // });
        }
        setState(() {
          circularData.add(CircularDataStart(element.marketer, total_Value));
          ;
        });
      }
    }

    return data;
  }
  
  getCountElement()async{
    var data = await RemoteServiceMic.miccCountElement();
    setState(() {
      nombreElement = data;
    });
    return nombreElement;
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateStart =
        "${_filterDateDebut.month}-${_filterDateDebut.day}-${_filterDateDebut.year}";
    _dateFin =
        "${_filterDateFin.month}-${_filterDateFin.day}-${_filterDateFin.year}";
    getTfsActive();
    getTtkActive();
    // micGetStation();
    micGetProduit;
    getCountElement();
    DateTime _now = DateTime.now();
    // DateTime(_now.year, _now.month, 1);
    _filterStartDebutDate = DateFormat(
      'dd  MMM yyyy',
    ).format(DateTime.parse(DateTime(_now.year, _now.month, 1).toString()));
    _filterStartFinDate = DateFormat(
      'dd  MMM yyyy',
    ).format(DateTime.parse(DateTime(_now.year, _now.month + 1, 0).toString()));
    micGetMarketerList();
    // micGetSssatList();
    getStatPer();
    // micGetTransporteurList();
    // misGetVehiculList();
    // micGetVille();
    // micGetDepotList();

    _tooltip = TooltipBehavior(enable: true);
  }

  series(List<StaProduit> listM) {
    return ColumnSeries<StaProduit, String>(
      dataLabelSettings: DataLabelSettings(isVisible: true),
      // isTrackVisible: true,
      isTrackVisible: true,
      isVisibleInLegend: true,
      dataSource: listM,
      xValueMapper: (StaProduit data, _) => data.produit,
      yValueMapper: (StaProduit data, _) => data.total,
      // name: ,
      color: Color.fromRGBO(8, 142, 255, 1),
    );
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

  bool _retour = false;
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
                            Navigator.of(context, rootNavigator: true).pop();
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
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
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: ((context) => MicMarketers())));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => MicAddMarketer()),
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
                                  'Marketers',
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
                      Divider(),
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
                                  Icons.card_membership_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Station services',
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
                      Divider(),
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
                                  Icons.layers_outlined,
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
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => DepotDouanier()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.warehouse_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Dépôt de stockage',
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
                      Divider(),
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
                                  'Société de Transport',
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
                      Divider(),
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
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => TauxTK()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.rate_review,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Taux TK',
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
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => MicAddTauxForfait()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.palette,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Taux forfait',
                                  softWrap: true,
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
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => Villes()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.location_city,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Villes',
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
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => Produits()),
                              ),
                            );
                          }),
                          child: Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  Icons.production_quantity_limits,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Produits',
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
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: red,
                          ),
                          child: TextButton.icon(
                            // style: TextButton.styleFrom(),
                            onPressed: () async {
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
                            },
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
              headerSliverBuilder: ((context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    shape: RoundedRectangleBorder(),

                    backgroundColor: white, //Color(0xFF390047),
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
              }),
              body: Scaffold(
                resizeToAvoidBottomInset: true,
                body: Container(
                  decoration: logoDecoration(),
                  child:
                      pagePosition == 0
                          ? acceuilMic()
                          : pagePosition == 2
                          ? MesNotifications()
                          : Profil(),
                ),
              ),
              // Scaffold(
              // body:
              // ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedLabelStyle: TextStyle(color: gryClaie),
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
                BottomNavigationBarItem(
                  backgroundColor: gryClaie,
                  icon: Icon(Icons.menu),
                  label: 'Menu',
                ),
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

  ////////////////////////////////////////////
  //// Representation des graphiques et autre de la partie Administration de MIC
  ////////////////////////////////
  Widget charCircular() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tbordColor,
        ),
        child: SfCircularChart(
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          palette: [
            Color.fromRGBO(206, 83, 218, 1),
            Color.fromRGBO(230, 117, 73, 1),
            Color.fromRGBO(136, 196, 173, 1),
            Color.fromRGBO(38, 44, 224, 1),
            Color.fromRGBO(255, 205, 96, 1),
            Color.fromRGBO(196, 44, 150, 1),
            Color.fromRGBO(7, 219, 53, 0.336),
            Color.fromRGBO(216, 62, 62, 1),
          ],
          series: <CircularSeries>[
            PieSeries<CircularDataStart, String>(
              explode: true,
              enableTooltip: true,
              dataSource: circularData,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                overflowMode: OverflowMode.trim,
                labelIntersectAction: LabelIntersectAction.none,
                showZeroValue: false,
                labelPosition: ChartDataLabelPosition.inside,
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.line,
                ),
              ),
              xValueMapper: (CircularDataStart data, _) => data.x,
              yValueMapper: (CircularDataStart data, _) => data.y,
            ),
          ],
        ),
      ),
    );
  }

  Widget chartToMarketer() {
    Size _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tbordColor,
        ),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          legend: Legend(
            title: LegendTitle(
              alignment: ChartAlignment.near,
              text: 'Statistique de produit par marketer',
              textStyle: TextStyle(backgroundColor: Colors.white),
            ),
            alignment: ChartAlignment.center,
            // backgroundColor: Colors.cyan,
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
            Color.fromRGBO(196, 44, 150, 1),
            Color.fromRGBO(192, 145, 15, 1),
            Color.fromRGBO(7, 219, 53, 0.336),
            Color.fromRGBO(19, 29, 77, 1),
            Color.fromRGBO(112, 76, 76, 1),
            Color.fromRGBO(216, 62, 62, 1),
          ],
          primaryXAxis: CategoryAxis(),
          series: [
            // series: <ChartSeries>[
            if (listSatProductMarketer.length > 0) ...[
              for (
                int i = 0;
                i < listSatProductMarketer[0].produit.length;
                i++
              ) ...[
                StackedColumnSeries<StarProduitMarketer, String>(
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    showZeroValue: false,
                  ),
                  isTrackVisible: true,
                  isVisibleInLegend: true,
                  dataSource: listSatProductMarketer,
                  xValueMapper: (StarProduitMarketer sm, _) => sm.marketer,
                  yValueMapper:
                      (StarProduitMarketer sm, _) => sm.produit[i].total,
                  name: listSatProductMarketer[0].produit[i].produit,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget chartToProduit() {
    Size _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 5),
      child: Container(
        // width: _size.height < _size.width ? _size.width : _size.height / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tbordColor,
        ),
        child: SfCartesianChart(
          onMarkerRender: (MarkerRenderArgs markerargs) {},
          plotAreaBorderWidth: 0,
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
            if (listSatProduct.isNotEmpty) ...[
              StackedColumnSeries<StaProduit, String>(
                isVisibleInLegend: true,
                dataSource: listSatProduct,
                xValueMapper: (StaProduit sm, _) => sm.produit,
                yValueMapper: (StaProduit sm, _) => sm.total,
              ),

              // ]
            ],
          ],
        ),
      ),
    );
  }

  Widget chartToRegion() {
    Size _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 5),
      child: Container(
        // width: _size.height < _size.width ? _size.width : _size.height / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tbordColor,
        ),
        child: SfCartesianChart(
          onMarkerRender: (MarkerRenderArgs markerargs) {},
          plotAreaBorderWidth: 0,
          palette: [
            Color.fromRGBO(241, 84, 36, 0.795),
            Color.fromRGBO(51, 138, 43, 1),
            Color.fromRGBO(100, 238, 208, 1),
            Color.fromRGBO(33, 107, 79, 1),
            Color.fromRGBO(212, 236, 73, 0.596),
            Color.fromRGBO(205, 147, 207, 1),
            Color.fromRGBO(9, 5, 238, 1),
          ],
          legend: Legend(
            position: LegendPosition.top,
            isVisible: true,
            isResponsive: true,
          ),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries>[
            if (listPerRegion.isNotEmpty) ...[
              for (int i = 0; i < listPerRegion[0].produits.length; i++) ...[
                BarSeries<StartPerRegion, String>(
                  isVisibleInLegend: true,
                  dataSource: listPerRegion,
                  xValueMapper: (StartPerRegion sm, _) => sm.region,
                  yValueMapper: (StartPerRegion sm, _) => sm.produits[i].qty,
                  name: listPerRegion[0].produits[i].produit,
                ),
              ],
            ],
          ],
          title: ChartTitle(text: 'Quantité vendu par région'),
          tooltipBehavior: TooltipBehavior(enable: true),
        ),
      ),
    );
  }

  Widget acceuilMic() {
    Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height:
                _size.height < _size.width
                    ? _size.width / 12
                    : _size.height / 12,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF8F8FB),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: blue,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _filterStartDebutDate,
                          style: TextStyle(color: blue),
                        ),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              // _filterDateDebut = pickedDate;
                              _filterStartDebutDate = DateFormat(
                                'dd  MMM yyyy',
                              ).format(
                                DateTime.parse(
                                  DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                  ).toString(),
                                ),
                              );
                              _dateStart =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text('à', textScaleFactor: 1),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF8F8FB),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: blue,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _filterStartFinDate,
                          style: TextStyle(color: blue),
                        ),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dateFin =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              _filterStartFinDate = DateFormat(
                                'dd  MMM yyyy',
                              ).format(
                                DateTime.parse(
                                  DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                  ).toString(),
                                ),
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // shape: BoxShape.circle,
                        color: blue,
                      ),
                      width: double.infinity,
                      height:
                          _size.height < _size.width
                              ? _size.width / 18
                              : _size.height / 20,
                      child: IconButton(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        color: Colors.white,
                        icon: Icon(
                          Icons.autorenew_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_filterDateDebut.compareTo(_filterDateFin) > 0) {
                            fToast.showToast(
                              child: toastWidget('Interval de date incorrect'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 5),
                            );
                          } else {
                            getStatPer();
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: blue,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (listPerRegion.length > 0 ||
              listSatProduct.length > 0 ||
              listSatProductMarketer.length > 0 ||
              circularData.length > 0)
            Container(
              height:
                  _size.height < _size.width
                      ? _size.width / 2.60
                      : _size.height / 2,
              child: ListView(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  if (circularData.length > 0) ...[charCircular()],
                  SizedBox(width: 5),
                  if (listSatProductMarketer.length > 0) ...[chartToMarketer()],
                  SizedBox(width: 5),
                  if (listSatProduct.length > 0) ...[chartToProduit()],
                  SizedBox(width: 5),
                  if (listPerRegion.length > 0) ...[chartToRegion()],
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
            child: Container(
              height:
                  _size.height < _size.width
                      ? _size.width / 7
                      : _size.height / 8,
              child: ListView(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                dragStartBehavior: DragStartBehavior.start,
                children: [
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
                                  : _size.height / 4,
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
                  SizedBox(width: 5),
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
                                  : _size.height / 4,
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
                  SizedBox(width: 5),
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
                                  : _size.height / 4,
                          child: Column(
                            children: [
                              Text(
                                "Distance",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textScaleFactor: 1,
                              ),
                              TextButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.route, color: blue),
                                label: Text(
                                  "$_distance km",
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
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              color: tbordColor,
              // elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            'Sociétés pétrolières',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Card(
                          color: blue,
                          // elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              nombreElement.marketer.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: tbordColor,
              // elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            'Sociétés de transports',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Card(
                          color: blue,
                          // elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              nombreElement.transporteur.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: tbordColor,
              // elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            'Dépôts d\'hydrocarbures',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Card(
                          color: blue,
                          // elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              nombreElement.depot.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: tbordColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            'Stations services',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Card(
                          color: blue,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              nombreElement.station.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
        ],
      ),
    );
  }
}
