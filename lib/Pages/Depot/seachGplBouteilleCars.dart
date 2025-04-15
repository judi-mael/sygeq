// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Pages/Depot/ChargerGPLBouteille.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class SearchGPLBouteilleCars extends StatefulWidget {
  bool depotAppBar;
  SearchGPLBouteilleCars({Key? key, required this.depotAppBar})
    : super(key: key);

  @override
  State<SearchGPLBouteilleCars> createState() => _SearchGPLBouteilleCarsState();
}

class _SearchGPLBouteilleCarsState extends State<SearchGPLBouteilleCars> {
  final _searchview = TextEditingController();

  bool _firstSearch = true;
  String _query = "";

  List<Camion> nebulae = [];
  List<Camion> filterList = [];
  bool _animate = true;

  getAllCaion() async {
    var data = await RemoteServices.allGetListeCamions();
    setState(() {
      nebulae = data;
      _animate = false;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    nebulae = <Camion>[];
    getAllCaion();
    nebulae.sort();
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  _SearchGPLBouteilleCarsState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getAllCaion);
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: gryClaie,
      appBar:
          widget.depotAppBar == true
              ? AppBar(
                backgroundColor: white,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: gryClaie, //change your color here
                ),
                title: Text(
                  "Chargement",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleAppBar,
                ),
              )
              : null,
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : nebulae.isEmpty
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
                            getAllCaion();
                          });
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 30,
                        ),
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
                : Column(
                  children: [
                    HeaderMic(),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                      child: SizedBox(
                        height:
                            _size.height < _size.width
                                ? _size.width / 17
                                : _size.height / 17,
                        child: TextFormField(
                          controller: _searchview,
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Le champs est obligatoir'
                                : null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (() {}),
                              icon: Icon(
                                Icons.search,
                                // color: green,
                                size: 30,
                              ),
                            ),
                            label: Text(
                              "Rechercher",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: styleG,
                              softWrap: true,
                            ),
                            filled: true,
                            // fillColor: Color.fromARGB(255, 162, 175, 235),
                            hintText: "Camion",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _firstSearch ? _createListView() : _performSearch(),
                  ],
                ),
      ),
    );
  }

  Widget _createListView() {
    Size _size = MediaQuery.of(context).size;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: nebulae.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              // top: 5,
              right: 5,
              left: 5,
            ),
            child:
                nebulae[index].deletedAt == ''
                    ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChargerGPLBouteille(
                                  car: nebulae[index].id,
                                  capacite: nebulae[index].capacity,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [cardCamion(nebulae[index]), Divider()],
                      ),
                    )
                    : Container(),
          );
        },
      ),
    );
  }

  //Perform actual search
  Widget _performSearch() {
    filterList.clear();
    for (int i = 0; i < nebulae.length; i++) {
      var item = nebulae[i];

      if (item.imat.toLowerCase().contains(_query.toLowerCase()) ||
          item.transporteur.nom.toLowerCase().contains(_query.toLowerCase())) {
        filterList.add(item);
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    Size _size = MediaQuery.of(context).size;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: filterList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              // top: 5,
              right: 10,
              left: 10,
            ),
            child:
                filterList[index].deletedAt == ''
                    ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChargerGPLBouteille(
                                  car: filterList[index].id,
                                  capacite: filterList[index].capacity,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [cardCamion(filterList[index]), Divider()],
                      ),
                    )
                    : Container(),
          );
        },
      ),
    );
  }
}
