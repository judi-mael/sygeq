// ignore_for_file: prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sygeq/Models/BonGPLBouteille.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/Detail/DetailBLGPL.dart';

import 'package:sygeq/Pages/Maketers/MultiBLGplBouteille.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/UiForBL.dart';

class ListBLGPLBouteille extends StatefulWidget {
  const ListBLGPLBouteille({super.key});

  @override
  State<ListBLGPLBouteille> createState() => _ListBLGPLBouteilleState();
}

class _ListBLGPLBouteilleState extends State<ListBLGPLBouteille>
    with TickerProviderStateMixin {
  List<Driver> listTransporteur = [];
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  late List<BonGplBouteille> listMBL = [];
  late List<BonGplBouteille> filterBL = [];
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
    var data = await MarketerRemoteService.allGetListeGPL();
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
                  actionOnTheMarketer(listMBL[index]);
                },
                child: cardMarketerGPL(listMBL[index]),
              );
            } else {
              return Container();
            }
          }),
        );
  }

  actionOnTheMarketer(BonGplBouteille bongpl) {
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
            child: Container(child: DetailBlGPL(bongpl: bongpl)),
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
          'BONS GPL Bouteille',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleAppBar,
          softWrap: true,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.filter, color: blue),
          ),
        ],
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
      floatingActionButton: IconButton(
        // color: blue,
        style: IconButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: blue,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => MultiBLGplBouteille(gazoil: true)),
            ),
          ).then((value) async {
            await getBlMarketer();
          });
        },
        icon: Icon(Icons.add, size: 25, color: white),
      ),
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
                actionOnTheMarketer(listMBL[index]);
              },
              child: cardMarketerGPL(listMBL[index]),
            );
          }),
        );
  }
}
