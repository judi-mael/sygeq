// ignore_for_file: must_be_immutable, prefer_const_constructors, unnecessary_null_comparison

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/BonGPLBouteille.dart';
import 'package:sygeq/Models/dispactblgpl.dart';
import 'package:sygeq/Pages/Dispatcheur/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class DispatchBlGplBouteille extends StatefulWidget {
  BonGplBouteille bonGplBouteil;
  DispatchBlGplBouteille({super.key, required this.bonGplBouteil});

  @override
  State<DispatchBlGplBouteille> createState() => _DispatchBlGplBouteilleState();
}

class _DispatchBlGplBouteilleState extends State<DispatchBlGplBouteille> {
  List<Dispactblgpl> listValue = [];
  int position = 1;
  int qteRestante = 0;
  marketerGetStation() async {
    if (listMarkStation.isEmpty) {
      var data = await RemoteServices.allGetListeStation();
      setState(() {
        listMarkStation = data;
      });
    }
    return listMarkStation;
  }

  marketerDispatchBl() async {
    var data = await MarketerRemoteService.dispactGPLBouteille(
      widget.bonGplBouteil.id,
      listValue,
    );
    return data;
  }

  void initState() {
    super.initState();
    listValue.add(Dispactblgpl(0, 0));
    marketerGetStation();
    qteRestante = widget.bonGplBouteil.produits.first.qtte;
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(color: gryClaie),
        centerTitle: true,
        title: Text(
          'Distribution',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleAppBar,
          softWrap: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Text(
                  "Quantité disponible : ${widget.bonGplBouteil.produits.first.qtte}",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 30,
                                  right: 8,
                                  left: 8,
                                ),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                  ),
                                  items:
                                      listMarkStation == null
                                          ? []
                                          : listMarkStation
                                              .map((e) => e.nomStation)
                                              .toList(),
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Choisissez la Station'
                                              : null,
                                  onChanged: (String? newValue) {
                                    int index = listMarkStation.indexWhere(
                                      (element) =>
                                          element.nomStation ==
                                          newValue.toString(),
                                    );
                                    listValue[0].stationid =
                                        listMarkStation[index].id;
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: 'Station',
                                            ),
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Quantité",
                                      textScaleFactor: 1,
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: styleG,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? 'Mettez la quantité'
                                        : null;
                                  },
                                  onChanged: (valu) {
                                    listValue[0].quantite = int.parse(valu);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (int p = 1; position > p; p++) ...[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 30,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: DropdownSearch<String>(
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      fit: FlexFit.loose,
                                    ),
                                    items:
                                        listMarkStation == null
                                            ? []
                                            : listMarkStation
                                                .map((e) => e.nomStation)
                                                .toList(),
                                    validator:
                                        (value) =>
                                            value == null
                                                ? 'Choisissez la Station'
                                                : null,
                                    onChanged: (String? newValue) {
                                      int index = listMarkStation.indexWhere(
                                        (element) =>
                                            element.nomStation ==
                                            newValue.toString(),
                                      );
                                      listValue[p].stationid =
                                          listMarkStation[index].id;
                                    },
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Station',
                                              ),
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "Quantité",
                                        textScaleFactor: 1,
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleG,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? 'Mettez la quantité'
                                          : null;
                                    },
                                    onChanged: (valu) {
                                      listValue[p].quantite = int.parse(valu);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 5,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              elevation: 20,
                              backgroundColor: white.withOpacity(0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                listValue.removeAt(p);
                                position = position - 1;
                              });
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.times,
                              color: red,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            position = position + 1;
                            listValue.add(Dispactblgpl(0, 0));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          'Ajouter',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(color: white),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          int total = 0;
                          for (var elementy in listValue) {
                            total = total + elementy.quantite;
                          }

                          if (total >
                              widget.bonGplBouteil.produits.first.qtte) {
                            showToast(
                              "La quantité demandée dépasse celle disponible",
                              
                            );
                          } else {
                            marketerDispatchBl();
                            Navigator.pop(context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Soumettre',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: white,
                          fontSize: 18,
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
    );
  }
}
