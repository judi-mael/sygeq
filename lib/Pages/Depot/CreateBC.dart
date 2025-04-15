// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Pages/Depot/ValidationBC.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class CreateBC extends StatefulWidget {
  bool depotAppBar;
  CreateBC({Key? key, required this.depotAppBar}) : super(key: key);

  @override
  State<CreateBC> createState() => _CreateBCState();
}

class _CreateBCState extends State<CreateBC> {
  final _searchview = TextEditingController();

  bool _firstSearch = true;
  String _query = "";

  List<Camion> nebulae = [];
  List<Camion> filterList = [];
  _CreateBCState() {
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
  bool _animate = true;
  getAllCaion() async {
    var data = await RemoteServices.allGetListeCamions();
    setState(() {
      nebulae = data;
    });
    Future.delayed(Duration(seconds: 1));
    setState(() {
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
      body:
          _animate == true
              ? animationLoadingData()
              : Container(
                decoration: logoDecoration(),
                child:
                    nebulae.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EmptyList(),
                              EmptyMessage(),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: blue,
                                ),
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
                          children: <Widget>[
                            HeaderMic(),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                                left: 5,
                                right: 5,
                              ),
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
                                      icon: Icon(Icons.search, color: green),
                                    ),
                                    label: Text(
                                      "Rechercher un camion",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: styleG,
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
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: nebulae.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 5, right: 5, left: 5),
            child:
                nebulae[index].deletedAt == ""
                    ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ValidationBC(
                                  car: nebulae[index].id,
                                  capacite: nebulae[index].capacity,
                                  imat: nebulae[index].imat,
                                ),
                          ),
                        );
                      },
                      child: cardCamion(nebulae[index]),
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
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: filterList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 5, right: 5, left: 5),
            child:
                filterList[index].deletedAt == ''
                    ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ValidationBC(
                                  car: filterList[index].id,
                                  capacite: filterList[index].capacity,
                                  imat: filterList[index].imat,
                                ),
                          ),
                        );
                      },
                      child: cardCamion(filterList[index]),
                    )
                    : Container(),
          );
        },
      ),
    );
  }
}
