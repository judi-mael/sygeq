// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_field

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Pages/Dispatcheur/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class NewUserDispatcheur extends StatefulWidget {
  const NewUserDispatcheur({Key? key}) : super(key: key);

  @override
  State<NewUserDispatcheur> createState() => _NewUserDispatcheurState();
}

class _NewUserDispatcheurState extends State<NewUserDispatcheur> {
  late TextEditingController txtEmail,
      txtNom,
      txtId,
      txtStation,
      txtType,
      txtDate;
  final fromKey = GlobalKey<FormState>();
  bool _visible = false;
  String dropdownValue = 'Dog';
  marketerGetStation() async {
    var data = await RemoteServices.allGetListeStation();
    setState(() {
      listMarkStation = data;
    });
    return data;
  }

  markAddUser() async {
    var data = MarketerRemoteService.markAddUser(
      txtNom.text.trim().toString().replaceAll(RegExp('[></=]'), ' '),
      txtEmail.text.trim().toString().replaceAll(RegExp('[></=]'), ' '),
      txtType.text.trim().toString().replaceAll(RegExp('[></=]'), ' '),
      txtId.text.trim().toString().replaceAll(RegExp('[></=]'), ' '),
      txtStation.text.trim().toString().replaceAll(RegExp('[></=]'), ' '),
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    if (listMarkStation.isEmpty) {
      marketerGetStation();
    }
    txtEmail = TextEditingController();
    txtNom = TextEditingController();
    txtId = TextEditingController();
    txtType = TextEditingController();
    txtStation = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        title: Text(
          "Nouvel Agent",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textScaleFactor: 1,
          style: styleG,
        ),
      ),
      backgroundColor: gryClaie,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderMic(),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Text(
                  "Formulaire de Création",
                  style: GoogleFonts.montserrat(fontSize: 25),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Form(
                  key: fromKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              "Nom Complet",
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.montserrat(color: green),
                            ),
                          ),
                          validator: (value) {
                            return value!.length < 8 || value.length > 100
                                ? 'Le nom doit comporter au moins 08 caractères & 20 au plus'
                                : null;
                          },
                          onChanged: (value) {
                            txtNom.text = value;
                          },
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              "Identifiant",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.montserrat(color: green),
                            ),
                          ),
                          validator: (value) {
                            return value!.length < 8 || value.length > 50
                                ? 'L\'identifiant doit comporter au moins 08 caractères & 20 au plus'
                                : null;
                          },
                          onChanged: (value) {
                            txtId.text = value;
                          },
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              "E-mail",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.montserrat(color: green),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'L\'e-mail doit comporter au moins 08 caractères & 20 au plus';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return "exmeple : xyz@exe.com";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            txtEmail.text = value;
                          },
                          keyboardType: TextInputType.name,
                        ),
                      ),

                      // Padding(
                      //   padding: EdgeInsets.only(top: 20),
                      //   child: TextFormField(
                      //     decoration: InputDecoration(
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       label: Text(
                      //         "Station",
                      //         overflow: TextOverflow.ellipsis,
                      //         maxLines: 1,
                      //         style: TextStyle(color: green),
                      //       ),
                      //     ),
                      //     validator: (value) {
                      //       return value!.length < 8 || value.length > 20
                      //           ? 'Le nom doit comporter au moins 08 caractères & 20 au plus'
                      //           : null;
                      //     },
                      //     onChanged: (value) {
                      //       txtStation.text = value;
                      //     },
                      //     keyboardType: TextInputType.name,
                      //   ),
                      // ),

                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     top: 20,
                      //   ),
                      //   child: DropdownSearch<String>(
                      //     mode: Mode.MENU,
                      //     items: [
                      //       'Opérateur de Station',
                      //     ],
                      //     validator: (value) =>
                      //         value == null ? 'Choisissez la station' : null,
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         // dropdownValue = newValue!;
                      //         txtType.text = newValue!;
                      //         if (txtType.text.trim().trim() ==
                      //             "Opérateur de Station") {
                      //           _visible = true;
                      //         } else {
                      //           _visible = false;
                      //           txtStation = TextEditingController();
                      //         }
                      //       });
                      //     },
                      //     // popupItemDisabled: (String s) => s.startsWith('I'),
                      //     isFilteredOnline: true,
                      //     showSearchBox: true,
                      //     showSelectedItems: true,
                      //     dropdownSearchDecoration: InputDecoration(
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       hintText: 'Type d\'utilisateur',
                      //     ),
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: _visible,
                      //   child:
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: DropdownSearch<String>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                          ),
                          items:
                              listMarkStation.map((e) => e.nomStation).toList(),
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Choisissez la station'
                                      : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              int index = listMarkStation.indexWhere(
                                (element) => element.nomStation == newValue,
                              );
                              // dropdownValue = newValue!;
                              txtStation.text =
                                  listMarkStation[index].id.toString();
                            });
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Station',
                            ),
                          ),
                        ),
                      ),
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Soumettre",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.montserrat(fontSize: 20),
                    ),
                    onPressed: () {
                      if (fromKey.currentState!.validate()) {
                        markAddUser().then((val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: green,
                              duration: Duration(seconds: 2),
                              content: Text(
                                val["message"],
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: styleG,
                              ),
                            ),
                          );
                        });
                        // Navigator.pop(context);
                      } else {}
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
