// ignore_for_file: prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sygeq/Models/BonT.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/Detail/DetailBT.dart';

import 'package:sygeq/Pages/Maketers/MultiBT.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/UiForBL.dart';

class ListBT extends StatefulWidget {
  const ListBT({super.key});

  @override
  State<ListBT> createState() => _ListBTState();
}

class _ListBTState extends State<ListBT> with TickerProviderStateMixin {
  List<Driver> listTransporteur = [];
  late TabController tabController;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  late List<BonT> listMBT = [];
  late List<BonT> filterMBT = [];
  bool _firstSearch = false;
  String _query = "";
  int pagePosition = 0;
  int _selectedIndex = 0;
  bool _animate = true;
  _ListBTState() {
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
    var data = await MarketerRemoteService.allGetListeBT();
    // if (!mounted) return null;
    setState(() {
      listMBT = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  micGetTransporteur() async {
    var res = await RemoteServices.allGetListeTransporteur();
    setState(() {
      listTransporteur = res;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return listTransporteur;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getBlMarketer);
  }

  getBlByState(String state) {
    bool isNonNull = true;
    for (var element in listMBT) {
      if (element.statut == state) {
        setState(() {
          isNonNull = false;
        });
      }
    }
    return !isNonNull
        ? ListView.builder(
          itemCount: listMBT.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            if (listMBT[index].statut == state) {
              return GestureDetector(
                onTap: () {
                  var camion = listMBT[index].camion;
                  var marketer = listMBT[index].marketer;
                  var transporteur = listMBT[index].transporteur;
                  var station = listMBT[index].destination;
                  var produits = listMBT[index].produits;
                  var depot = listMBT[index].depot;

                  var data = {
                    "id": listMBT[index].id,
                    "commentaire": listMBT[index].commentaire,
                    "numBL": listMBT[index].numeroBl,
                    "date": listMBT[index].date,
                    'statut': listMBT[index].statut,
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
                child: cardMarketerBT(listMBT[index]),
              );
            } else {
              return Container();
            }
          }),
        )
        : ListView(
          children: [
            SizedBox(height: 100),
            EmptyList(),
            EmptyMessage(mesaageText: "Vous n'avez aucun BL $state"),
          ],
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
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            insetPadding: EdgeInsets.all(5),
            // scrollable: true,
            child: Container(
              // width: double.infinity,
              child: DetailBT(
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

  List<Depot> listDepotInterieur = [];
  depotInterieur() async {
    var data = await RemoteServices.allGetDepotInterieur();

    setState(() {
      listDepotInterieur = data;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    getBlMarketer();
  }

  @override
  void dispose() {
    super.dispose();
    listMBT.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          'BONS DE TRANSFERE',
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
                  ),
                ),
              ),
            ),
          ];
        },
        body:
            _animate == true
                ? veuillezPatienter("Wating...")
                : !_firstSearch
                ? TabBarView(
                  controller: tabController,
                  physics: ScrollPhysics(),
                  children: [
                    getBlByState("Chargé"),
                    getBlByState("Déchargé"),
                    getBlByState("Bon à Charger"),
                    getBlByState("Ouvert"),
                  ],
                )
                : TabBarView(
                  controller: tabController,
                  physics: ScrollPhysics(),
                  children: [
                    getFilterBlByState("Chargé"),
                    getFilterBlByState("Déchargé"),
                    getFilterBlByState("Bon à Charger"),
                    getFilterBlByState("Ouvert"),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: blue,
        onPressed: () {
          // if()
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => MultiBT())),
          ).then((value) => getBlMarketer());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  getFilterBlByState(String state) {
    filterMBT.clear();
    for (var element in listMBT) {
      if (element.destination.nom.toLowerCase().contains(
            _query.toLowerCase(),
          ) ||
          element.camion.imat.toLowerCase().contains(_query.toLowerCase())) {
        filterMBT.add(element);
      }
    }
    return filterMBT.isNotEmpty
        ? ListView.builder(
          itemCount: filterMBT.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            if (filterMBT[index].statut == state) {
              return GestureDetector(
                onTap: () {
                  var camion = filterMBT[index].camion;
                  var marketer = filterMBT[index].marketer;
                  var transporteur = filterMBT[index].transporteur;
                  var station = filterMBT[index].destination;
                  var produits = filterMBT[index].produits;
                  var depot = filterMBT[index].depot;

                  var data = {
                    "id": filterMBT[index].id,
                    "commentaire": filterMBT[index].commentaire,
                    "numBL": filterMBT[index].numeroBl,
                    "date": filterMBT[index].date,
                    'statut': filterMBT[index].statut,
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
                child: cardMarketerBT(filterMBT[index]),
              );
            } else {
              return Container();
            }
          }),
        )
        : ListView(
          children: [
            SizedBox(height: 100),
            EmptyList(),
            EmptyMessage(mesaageText: "Vous n'avez aucun BL $state"),
          ],
        );
  }
}
