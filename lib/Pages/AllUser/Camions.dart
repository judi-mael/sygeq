// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';

import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailCamion.dart';
import 'package:sygeq/Pages/AllUser/Compartiment.dart';
import 'package:sygeq/Services/RemoteService.dart';

import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';



class MicAddCamion extends StatefulWidget {
  const MicAddCamion({Key? key}) : super(key: key);

  @override
  State<MicAddCamion> createState() => _MicAddCamionState();
}

class _MicAddCamionState extends State<MicAddCamion> {
  final _searchview = TextEditingController();
  List<Camion> listCamion = [];
  List<Camion> filterList = [];
  bool _firstSearch = true;
  String _query = "";
  // List listCapacite = [];
  // List listnb = [];
  List? listcomp = [];
  bool _animate = true;
  int nbr = 0;
  String ssat = "";
  String num = "";
  String cap = "";
  _MicAddCamionState() {
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
  late TextEditingController txtImmatriclation,
      txtNvrVanne,
      txtAnne,
      txtType,
      txtMarque,
      txtTransporteur;
  final formKey = GlobalKey<FormState>();
  final formKeyadd = GlobalKey<FormState>();
  final formKeyupd = GlobalKey<FormState>();

  micGetTransporteurList() async {
    var data = await RemoteServices.allGetListeTransporteur();
    setState(() {
      listMicTransporteur = data;
    });
    return data;
  }

  micGetCamion() async {
    var res = await RemoteServices.allGetListeCamions();
    List<Camion> camiondata = [];
    for (var element in res) {
      if (element.deletedAt == "") {
        camiondata.add(element);
      }
    }
    // if (!mounted) return null;
    setState(() {
      listCamion = camiondata;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return res;
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetCamion);
  }

  actionOnTheCamion(var data, List<Compartiment> listCompartiment) {
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
              padding: EdgeInsets.all(10),
              child: DetailCamion(
                data: data,
                listCompartiment: listCompartiment,
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await micGetCamion();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    micGetCamion();
    micGetTransporteurList();
    txtImmatriclation = TextEditingController();
    txtMarque = TextEditingController();
    txtType = TextEditingController();
    txtTransporteur = TextEditingController();
    txtAnne = TextEditingController();
    txtNvrVanne = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Camions",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styleAppBar,
        ),
      ),
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listCamion.length <= 0
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
                            micGetCamion();
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
                : RefreshIndicator(
                  key: refreshKey,
                  onRefresh: refresh,
                  child: SafeArea(
                    child: Column(
                      children: [
                        HeaderMic(),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     top: 20,
                        //     left: 30,
                        //     right: 30,
                        //   ),
                        //   child: Text(
                        //     "Liste des comions",
                        //     maxLines: 1,
                        //     softWrap: true,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: styleG,
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 5, right: 5),
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
                                fillColor: Color.fromARGB(255, 248, 248, 248),
                                hintText: "Camion",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        !_firstSearch
                            ? _performSearch()
                            : Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 5,
                                  right: 5,
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: listCamion.length,
                                  itemBuilder: ((context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        List<Compartiment> listCompartiment =
                                            listCamion[index].vannes;
                                        var data = {
                                          'id': listCamion[index].id,
                                          'immat': listCamion[index].imat,
                                          'marque': listCamion[index].marque,
                                          'annee': listCamion[index].annee,
                                          'type': listCamion[index].type,
                                          'delete': listCamion[index].deletedAt,
                                          'nbrVanne':
                                              listCamion[index].nbreVanne
                                                  .toString(),
                                          'driver':
                                              listCamion[index]
                                                  .transporteur
                                                  .nom,
                                        };
                                        actionOnTheCamion(
                                          data,
                                          listCompartiment,
                                        );
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             DetailCamion(
                                        //                 data: data,
                                        //                 listCompartiment:
                                        //                     listCompartiment)));
                                      },
                                      child: cardCamion(listCamion[index]),
                                    );
                                  }),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
      ),
      floatingActionButton:
          prefUserInfo['type'] == "Marketer"
              ? FloatingActionButton(
                backgroundColor: blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => MicAddCompartiments()),
                    ),
                  ).then((value) => micGetCamion());
                },
                child: Icon(Icons.add, color: Colors.white),
              )
              : Container(),
    );
  }

  Widget _performSearch() {
    filterList.clear();
    for (int i = 0; i < listCamion.length; i++) {
      var item = listCamion[i];

      if (item.imat.toLowerCase().contains(_query.toLowerCase()) ||
          item.transporteur.nom.toLowerCase().contains(_query.toLowerCase())) {
        filterList.add(item);
      }
    }
    return _filterlist();
  }

  Widget _filterlist() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: filterList.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                var listCompartiment = filterList[index].vannes;
                var data = {
                  'id': filterList[index].id,
                  'immat': filterList[index].imat,
                  'marque': filterList[index].marque,
                  'annee': filterList[index].annee,
                  'type': filterList[index].type,
                  'delete': filterList[index].deletedAt,
                  'nbrVanne': filterList[index].nbreVanne.toString(),
                  'driver': filterList[index].transporteur.nom,
                };

                actionOnTheCamion(data, listCompartiment);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => DetailCamion(
                //             data: data, listCompartiment: listCompartiment)));
              },
              child: cardCamion(filterList[index]),
            );
          }),
        ),
      ),
    );
  }
}
