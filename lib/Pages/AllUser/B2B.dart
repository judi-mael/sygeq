// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/SsatMarkers.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Pages/AllUser/DetailB2B.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/Pages/AllUser/AddB2B.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

List<SsatMarkers> listSSatB2BNoFilter = [];

class B2B extends StatefulWidget {
  const B2B({Key? key}) : super(key: key);

  @override
  State<B2B> createState() => _B2BState();
}

class _B2BState extends State<B2B> {
  bool _obscuretext = true;
  List<Station> listB2B = [];
  List<Station> filterList = [];
  bool _firstSearch = true;
  String _query = "";
  List<String> marketerIds = [];
  final _searchview = TextEditingController();
  String longitude = "";
  String latitude = "";
  int poi = 0;
  _B2BState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
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
  late TextEditingController txtNom,
      // txtMarketer,
      txtAgrementDocument,
      txtIfuDocument,
      txtAdresse,
      txtIfu,
      txtVille,
      txtLogin,
      txtEmail,
      txtName,
      txtRC,
      txtAgrement;
  final formKey = GlobalKey<FormState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  actionOnTheStation(var data) {
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
              child: DetailB2B(data: data),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await micGetB2B();
      });
    });
  }

  micGetSssatListNoFilter() async {
    var data = await RemoteServices.micGetSsatListStationNoFilter();
    setState(() {
      listSSatB2BNoFilter = data;
    });
    return data;
  }

  @override
  void dispose() {
    super.dispose();
    listSSatB2BNoFilter.clear();
    listSsatB2B.clear();
    listB2B.clear();
  }

  micGetSssatList() async {
    var data = await RemoteServices.micGetSsatListStation();
    setState(() {
      listSsatB2B = data;
    });
    return data;
  }

  micAddStation() async {
    var data = await RemoteServices.micAddB2B(
      txtAgrement.text.toString().trim(),
      txtIfu.text.toString().trim(),
      txtNom.text.toString().trim(),
      txtVille.text.toString().trim(),
      txtAdresse.text.toString().trim(),
      prefUserInfo['marketerId'],
      txtName.text.toString().trim(),
      txtLogin.text.toString().trim(),
      txtEmail.text.toString().trim(),
      poi,
      // latitude,
      // longitude,
      txtRC.text.toString().trim(),
      txtIfuDocument.text.toString(),
      txtAgrementDocument.text.toString(),
    );
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetB2B);
  }

  bool _animate = true;
  micGetB2B() async {
    var data = await RemoteServices.allGetListeB2B();
    // if (!mounted) return null;
    setState(() {
      listB2B = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return listB2B;
  }

  @override
  void initState() {
    super.initState();
    micGetB2B();
    // micGetSssatList();
    // micGetSssatListNoFilter();
    txtAdresse = TextEditingController();
    txtIfu = TextEditingController();
    txtVille = TextEditingController();
    txtNom = TextEditingController();
    txtName = TextEditingController();
    txtEmail = TextEditingController();
    txtLogin = TextEditingController();
    txtAgrement = TextEditingController();
    txtRC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "B2B",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styleAppBar,
        ),
      ),
      // backgroundColor: gryClaie,
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listB2B.isEmpty
                ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EmptyList(),
                        EmptyMessage(),
                        TextButton.icon(
                          style: TextButton.styleFrom(backgroundColor: blue),
                          onPressed: () {
                            setState(() {
                              micGetB2B();
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
                  ),
                )
                : RefreshIndicator(
                  key: refreshKey,
                  onRefresh: refresh,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
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
                                  "Rechercher un B2B",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: styleG,
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 239, 241),
                                hintText: "B2B",
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
                                padding: EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                  itemCount: listB2B.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: ((context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        var data = {
                                          'id': listB2B[index].id,
                                          'agrement': listB2B[index].agrement,
                                          'rccm': listB2B[index].rccm,

                                          'ville': listB2B[index].ville.id,
                                          'villeNom': listB2B[index].ville.nom,
                                          'ifu': listB2B[index].ifu,
                                          'delete': listB2B[index].deletedAt,
                                          'adresse': listB2B[index].adresse,

                                          // 'registre': listB2B[index].,
                                          'nom': listB2B[index].nomStation,
                                        };
                                        actionOnTheStation(data);
                                      },
                                      child: Column(
                                        children: [
                                          listB2BCard(listB2B[index]),
                                          Divider(),
                                        ],
                                      ),
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
                    MaterialPageRoute(builder: (context) => AddB2B()),
                  );
                },
                child: Icon(Icons.add, color: Colors.white),
              )
              : Container(),
    );
  }

  Widget _performSearch() {
    filterList.clear();
    for (int i = 0; i < listB2B.length; i++) {
      var item = listB2B[i];

      if (item.nomStation.toLowerCase().contains(_query.toLowerCase())) {
        filterList.add(item);
      }
    }
    return _filterlist();
  }

  Widget _filterlist() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: filterList.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                var data = {
                  'id': filterList[index].id,
                  'agrement': filterList[index].agrement,
                  'rccm': filterList[index].rccm,
                  // 'marketer': filterList[index].marketer.id,
                  // // 'marketerNom': filterList[index].marketer.nom,
                  // 'ville': filterList[index].ville.id,
                  // 'villeNom': filterList[index].ville.nom,
                  'ifu': filterList[index].ifu,
                  'delete': filterList[index].deletedAt,
                  'adresse': filterList[index].adresse,

                  // 'registre': filterList[index].,
                  'nom': filterList[index].nomStation,
                };
                actionOnTheStation(data);
              },
              child: Column(
                children: [listB2BCard(filterList[index]), Divider()],
              ),
            );
          }),
        ),
      ),
    );
  }
}
