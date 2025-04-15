// ignore_for_file: prefer_const_constructors, deprecated_member_use, must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Pages/AllUser/Stations.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateStation extends StatefulWidget {
  var data;
  UpdateStation({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateStation> createState() => _UpdateStationState();
}

class _UpdateStationState extends State<UpdateStation> {
  String longitude = "";
  String latitude = "";
  String txtNom = "";
  int poi = 0;
  int txtVille = 0;
  int txtMarketer = 0;
  String nomMarketer = "";
  String nomVille = "";
  late TextEditingController
      // txtMarketer,
      txtAdresse,
      txtIfu,
      // txtVille,
      txtLogin,
      txtEmail,
      // txtName,
      // txtRC,
      // txtDateStart,
      // txtDateEnd,
      txtAgrement;
  final formKey = GlobalKey<FormState>();
  micUpdateStation() async {
    var data = await RemoteServiceMic.micUpdateStation(
      widget.data['id'],
      txtAgrement.text.toString().trim(),
      // txtIfu.text.toString().trim(),
      txtNom,
      txtVille,
      txtAdresse.text.toString().trim(),
      txtMarketer,
      // txtName.text.toString().trim(),
      // txtLogin.text.toString().trim(),
      // txtEmail.text.toString().trim(),
      poi,
      latitude,
      longitude,
      // txtRC.text.toString().trim(),
    );
    return data;
  }

  getLastStation() {
    // if (listSsatStation.isNotEmpty) {
    if (widget.data['nom'] != null) {
      int index = listSsatStationNoFilter.indexWhere(
        (element) => element.nom == widget.data['nom'],
      );
      if (index >= 0) {
        setState(() {
          txtNom = listSsatStationNoFilter[index].nom;
          poi = listSsatStationNoFilter[index].id;
          longitude =
              listSsatStationNoFilter[index].center.longitude.toString();
          latitude = listSsatStationNoFilter[index].center.latitude.toString();
        });
      }
      // }
    }
  }

  getLastMarketer() {
    if (listMicMarketer.isNotEmpty) {
      if (widget.data['marketer'] != null) {
        int index = listMicMarketer.indexWhere(
          (element) => element.id == widget.data['marketer'],
        );
        setState(() {
          txtMarketer = listMicMarketer[index].id;
          nomMarketer = listMicMarketer[index].nom;
          // poi = listSsatStation[index].id;
          // longitude = listSsatStation[index].center.longitude.toString();
          // latitude = listSsatStation[index].center.latitude.toString();
        });
      }
    }
  }

  getLastVille() {
    if (listMicVille.isNotEmpty) {
      if (widget.data['ville'] != null) {
        int index = listMicVille.indexWhere(
          (element) => element.id == widget.data['ville'],
        );
        setState(() {
          txtVille = listMicVille[index].id;
          nomVille = listMicVille[index].nom;
          // poi = listSsatStation[index].id;
          // longitude = listSsatStation[index].center.longitude.toString();
          // latitude = listSsatStation[index].center.latitude.toString();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // micGetSssatListNoFilter();
    txtAdresse = TextEditingController(text: '${widget.data['adresse']}');
    txtAgrement = TextEditingController(text: "${widget.data['agrement']}");
    txtIfu = TextEditingController(text: "${widget.data['ifu']}");
    // txtRC = TextEditingController(text: "${widget.data['rccm']}");
    // txtNom = TextEditingController(text: "${widget.data['nom']}");
    getLastStation();
    getLastMarketer();
    getLastVille();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            HeaderMic(),
            Text(
              "Modifier la station",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.montserrat(color: green),
            ),
            /////////////////////////
            ///SSat /
            ///////////////////////
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                // right: 20,
                // left: 20,
              ),
              child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                ),
                items:
                    listSsatStationNoFilter.isEmpty
                        ? []
                        : listSsatStationNoFilter.map((e) => e.nom).toList(),
                validator:
                    (value) => value == null ? 'Choisissez la station' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    int index = listSsatStationNoFilter.indexWhere(
                      (element) => element.nom == newValue.toString(),
                    );
                    poi = listSsatStationNoFilter[index].id;
                    latitude =
                        listSsatStationNoFilter[index].center.latitude
                            .toString();
                    longitude =
                        listSsatStationNoFilter[index].center.longitude
                            .toString();
                    txtNom = newValue!;
                  });
                },
                selectedItem: txtNom,
                // isFilteredOnline: true,
                // showSearchBox: true,
                // showSelectedItems: true,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(
                      'Station',
                      softWrap: true,
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),

            /////////////////////////
            /// Adresse Station
            /// ////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtAdresse,
                // onChanged: (value) {
                //   txtAdresse.text = value;
                // },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(
                  copy: false,
                  cut: false,
                  paste: false,
                  selectAll: false,
                ),
                // maxLength: 12,
                minLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Adresse",
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            if (prefUserInfo['marketerId'].toString() == "0") ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  // right: 20,
                  // left: 20,
                ),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    fit: FlexFit.loose,
                  ),
                  items:
                      listMicMarketer.isEmpty
                          ? []
                          : listMicMarketer.map((e) => e.nom).toList(),
                  validator:
                      (value) =>
                          value == null ? 'Choisissez le marketer' : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      int index = listMicMarketer.indexWhere(
                        (element) => element.nom == newValue.toString(),
                      );

                      // dropdownValue = newValue!;
                      txtMarketer = listMicMarketer[index].id;
                    });
                  },
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  selectedItem: nomMarketer,
                  // isFilteredOnline: true,
                  // showSearchBox: true,
                  // showSelectedItems: true,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        "Marketers",
                        softWrap: true,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            /////////////////////////
            /// Ville Station
            /// ////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // right: 20,
                // left: 20,
              ),
              child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                ),
                items:
                    listMicVille.isEmpty
                        ? []
                        : listMicVille.map((e) => e.nom).toList(),
                validator:
                    (value) => value == null ? 'Choisissez la ville' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    int indx = listMicVille.indexWhere(
                      (element) => element.nom == newValue.toString(),
                    );
                    txtVille = listMicVille[indx].id;
                  });
                },
                // popupItemDisabled: (String s) => s.startsWith('I'),
                selectedItem: nomVille,
                // isFilteredOnline: true,
                // showSearchBox: true,
                // showSelectedItems: true,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Ville',
                  ),
                ),
              ),
            ),

            ///////////////////////////////////////////////
            /// Information de connexion
            /// //////////////////////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Annuler",
                        softWrap: true,
                        maxLines: 1,
                        style: btnTxtCOlor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Enregistrer",
                        softWrap: true,
                        style: btnTxtCOlor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          micUpdateStation();
                          Navigator.of(context, rootNavigator: true).pop();
                        } else {}
                      },
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
