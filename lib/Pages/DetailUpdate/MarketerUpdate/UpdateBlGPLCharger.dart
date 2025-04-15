// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, must_be_immutable, unused_local_variable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/StationBL.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateblGPLChatger extends StatefulWidget {
  var data;
  StationBl station;

  UpdateblGPLChatger({Key? key, required this.data, required this.station})
    : super(key: key);

  @override
  State<UpdateblGPLChatger> createState() => _UpdateblGPLChatgerState();
}

class _UpdateblGPLChatgerState extends State<UpdateblGPLChatger> {
  final fromKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  markUpdateBl() async {
    var data = await MarketerRemoteService.markUpdateBLCharger(
      id: widget.data['id'],
      sation: idStation,
    );
    return data;
  }

  marketerGetStation() async {
    var data = await RemoteServices.allGetListeStation();
    // if (!mounted) return null;
    setState(() {
      listMarkStation = data;
    });
    return data;
  }

  String txtStation = "";
  String idStation = "";

  @override
  void initState() {
    txtStation = widget.station.nom;
    idStation = widget.station.id.toString();
    marketerGetStation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Modification du BL",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
          style: styleAppBar,
        ),
      ),
      // backgroundColor: gryClaie,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderMic(),
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 30),
                  child: Text(
                    "Modifier la destination du BL",
                    style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    softWrap: true,
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
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                            ),
                            items:
                                listMarkStation
                                    .map((e) => e.nomStation)
                                    .toList(),
                            validator:
                                (value) =>
                                    value == null
                                        ? 'Choisissez la Station'
                                        : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                int index = listMarkStation.indexWhere(
                                  (element) =>
                                      element.nomStation == newValue.toString(),
                                );
                                // dropdownValue = newValue!;
                                idStation =
                                    listMarkStation[index].id.toString();
                              });
                            },
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            selectedItem: txtStation,
                            // isFilteredOnline: true,
                            // showSearchBox: true,
                            // showSelectedItems: true,
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
                      ],
                    ),
                  ),
                ),
                /////////////////////
                ///  Bouton pour soumettre le formulaire
                /// //////////////////////
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Soumettre",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: btnTxtCOlor,
                      ),
                      onPressed: () {
                        if (fromKey.currentState!.validate()) {
                          // if (mesProduit!.isNotEmpty) {
                          markUpdateBl();
                          Navigator.pop(context);
                        } else {}
                      },
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
