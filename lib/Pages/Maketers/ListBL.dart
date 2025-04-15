// ignore_for_file: prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/Detail/DetailBL.dart';

import 'package:sygeq/Pages/Maketers/MultiBL.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/UiForBL.dart';

class ListBL extends StatefulWidget {
  const ListBL({super.key});

  @override
  State<ListBL> createState() => _ListBLState();
}

class _ListBLState extends State<ListBL> with TickerProviderStateMixin {
  List<Driver> listTransporteur = [];
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  late List<BonL> listMBL = [];
  late List<BonL> filterBL = [];
  bool _firstSearch = false;
  String _query = "";
  int pagePosition = 0;
  int _selectedIndex = 0;
  bool _animate = true;
  _ListBLState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          _firstSearch = false;
          _query = '';
        });
      } else {
        setState(() {
          _firstSearch = true;
          _query = searchController.text;
        });
      }
    });
  }
  getBlMarketer() async {
    var data = await MarketerRemoteService.allGetListeBL();
    // if (!mounted) return null;
    setState(() {
      listMBL = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getBlMarketer);
  }

  getBlByState(String state) {
    bool isNonNull = true;
    for (var element in listMBL) {
      if (element.statut == state) {
        setState(() {
          isNonNull = false;
        });
      }
    }
    return isNonNull
        ? ListView(
          children: [
            SizedBox(height: 100),
            EmptyList(),
            EmptyMessage(mesaageText: "Vous n'avez aucun BL $state"),
          ],
        )
        : ListView.builder(
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
                  actionOnTheMarketer(
                    data,
                    camion,
                    marketer,
                    transporteur,
                    station,
                    produits,
                    depot,
                  );
                },
                child: cardMarketerBL(listMBL[index]),
              );
            } else {
              return Container();
            }
          }),
        );
  }

  actionOnTheMarketer(
    var data,
    var camion,
    var marketer,
    var transporteur,
    var station,
    var produit,
    var depot,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            insetPadding: EdgeInsets.all(5),
            child: Container(
              child: DetailBL(
                data: data,
                camion: camion,
                depot: depot,
                driver: transporteur,
                marketer: marketer,
                station: station,
                listDetailLivraison: produit,
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await getBlMarketer();
      });
    });
  }

  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    getBlMarketer();
  }

  @override
  void dispose() {
    super.dispose();
    listMBL.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(color: gryClaie),
        centerTitle: true,
        title: Text(
          'BONS DE LIVRAISON',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleAppBar,
          softWrap: true,
        ),
        bottom: TabBar(
          dragStartBehavior: DragStartBehavior.down,
          tabAlignment: TabAlignment.center,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          indicatorColor: red,
          labelColor: white,
          automaticIndicatorColorAdjustment: false,
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
            Tab(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Bon à charger",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Ouvert",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        dragStartBehavior: DragStartBehavior.down,
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: white,
              elevation: 0,
              // leadingWidth: 2,
              automaticallyImplyLeading: false,
              pinned: true,
              centerTitle: true,
              title: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search),
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(9),
                    //     borderSide: BorderSide(width: 0)),
                  ),
                ),
              ),
            ),
          ];
        },
        body:
            _animate == true
                ? veuillezPatienter("Wating ...")
                : _firstSearch
                ? TabBarView(
                  controller: tabController,
                  physics: ScrollPhysics(),
                  children: [
                    getFilterBlByState("Chargé"),
                    getFilterBlByState("Déchargé"),
                    getFilterBlByState("Bon à Charger"),
                    getFilterBlByState("Ouvert"),
                  ],
                )
                : TabBarView(
                  controller: tabController,
                  physics: ScrollPhysics(),
                  children: [
                    getBlByState("Chargé"),
                    getBlByState("Déchargé"),
                    getBlByState("Bon à Charger"),
                    getBlByState("Ouvert"),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: white),
        backgroundColor: blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => MultiBL())),
          ).then((value) async {
            await getBlMarketer();
          });
        },
      ),

      // floatingActionButton: SpeedDial(
      //   icon: Icons.add,

      //   activeIcon: Icons.close,
      //   spacing: 3,

      //   // animatedIcon: AnimatedIcons.arrow_menu,
      //   animatedIconTheme: IconThemeData(size: 22),
      //   foregroundColor: Colors.white,
      //   backgroundColor: blue,

      //   visible: true,
      //   children: [
      //     SpeedDialChild(
      //       backgroundColor: blue,
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: ((context) => MultiBL(
      //                   gazoil: true,
      //                 )),
      //           ),
      //         ).then((value) async {
      //           await getBlMarketer();
      //         });
      //       },
      //       label: 'Gazoil',
      //       labelStyle: TextStyle(
      //           fontWeight: FontWeight.w500,
      //           color: Colors.white,
      //           fontSize: 16.0),
      //       labelBackgroundColor: blue,
      //     ),
      //     // FAB 2
      //     SpeedDialChild(
      //         backgroundColor: blue,
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: ((context) => MultiBL()),
      //             ),
      //           ).then((value) async {
      //             await getBlMarketer();
      //           });
      //         },
      //         label: 'Autres',
      //         labelStyle: TextStyle(
      //             fontWeight: FontWeight.w500,
      //             color: Colors.white,
      //             fontSize: 16.0),
      //         labelBackgroundColor: blue)
      //   ],
      // ),
    );
  }

  getFilterBlByState(String state) {
    filterBL.clear();
    for (var element in listMBL) {
      var item = element;
      if (item.camion.imat.toLowerCase().contains(_query.toLowerCase()) &&
          item.statut == state) {
        filterBL.add(item);
      } else {}
    }
    return filterBL.length == 0
        ? ListView(
          children: [
            SizedBox(height: 100),
            EmptyList(),
            EmptyMessage(mesaageText: "Vous n'avez aucun BL $state"),
          ],
        )
        : ListView.builder(
          itemCount: filterBL.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                var camion = filterBL[index].camion;
                var marketer = filterBL[index].marketer;
                var transporteur = filterBL[index].transporteur;
                var station = filterBL[index].station;
                var produits = filterBL[index].produits;
                var depot = filterBL[index].depot;

                var data = {
                  "id": filterBL[index].id,
                  "commentaire": filterBL[index].commentaire,
                  "numBL": filterBL[index].numeroBl,
                  "date": filterBL[index].date,
                  'statut': filterBL[index].statut,
                };
                actionOnTheMarketer(
                  data,
                  camion,
                  marketer,
                  transporteur,
                  station,
                  produits,
                  depot,
                );
              },
              child: cardMarketerBL(listMBL[index]),
            );
          }),
        );
  }
}
