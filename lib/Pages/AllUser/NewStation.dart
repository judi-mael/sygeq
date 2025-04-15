// ignore_for_file: prefer_const_constructors

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';
class NewStation extends StatefulWidget {
  const NewStation({super.key});

  @override
  State<NewStation> createState() => _NewStationState();
}

class _NewStationState extends State<NewStation> {
  // List<Station> listStation = [];

  bool _pickFileInProgressLicence = false;
  String longitude = "";
  String latitude = "";
  int poi = 0;
  String _licence = '';
  DateTime? ddLicence;
  DateTime? dfLicence;
  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(text: 'mwfbak');

  final _mimeTypeController = TextEditingController(text: 'application/pdf');
  FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
    allowedFileExtensions: ['mwfbak'],
    allowedUtiTypes: ['com.sidlatau.example.mwfbak'],
    allowedMimeTypes: ['application/pdf'],
    invalidFileNameSymbols: ['/'],
  );
  late TextEditingController txtNom,
      txtMarketer,
      txtAdresse,
      txtLicence,
      _finLicence,
      _debutLicence,
      // txtIfu,
      txtVille,
      txtLogin,
      txtEmail,
      txtName,
      // txtRC,
      txtAgrement;
  final formKey = GlobalKey<FormState>();
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = true;
  _pickDocumentAss() async {
    String? result;
    try {
      setState(() {
        _licence = '';
        _pickFileInProgressLicence = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions:
            _checkByCustomExtension
                ? _extensionController.text
                    .split(' ')
                    .where((x) => x.isNotEmpty)
                    .toList()
                : null,
        allowedUtiTypes:
            _iosPublicDataUTI
                ? null
                : _utiController.text
                    .split(' ')
                    .where((x) => x.isNotEmpty)
                    .toList(),
        allowedMimeTypes:
            _checkByMimeType
                ? _mimeTypeController.text
                    .split(' ')
                    .where((x) => x.isNotEmpty)
                    .toList()
                : null,
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgressLicence = false;
      });
    }
    setState(() {
      _licence = result!;
      txtLicence.text = _licence;
    });
  }

  micAddStation() async {
    var data = await RemoteServiceMic.micAddStation(
      txtAgrement.text.toString().trim(),
      // txtIfu.text.toString().trim(),
      txtNom.text.toString().trim(),
      txtVille.text.toString().trim(),
      txtAdresse.text.toString().trim(),
      txtMarketer.text.toString().trim(),
      // txtName.text.toString().trim(),
      // txtLogin.text.toString().trim(),
      // txtEmail.text.toString().trim(),
      poi,
      latitude,
      longitude,
      _licence,
      _debutLicence.text.trim().toString(),
      _finLicence.text.trim().toString(),

      // txtRC.text.toString().trim(),
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtAdresse = TextEditingController();
    txtMarketer = TextEditingController();
    // txtIfu = TextEditingController();
    txtVille = TextEditingController();
    txtNom = TextEditingController();
    txtName = TextEditingController();
    txtEmail = TextEditingController();
    txtLogin = TextEditingController();
    _finLicence = TextEditingController();
    _debutLicence = TextEditingController();
    txtAgrement = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // HeaderMic(),
            Text(
              "Nouvelle Station",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: green,
              ),
            ),
            Divider(),
            /////////////////////////
            ///SSat /
            ///////////////////////
            if (prefUserInfo['marketerId'].toString() == '0') ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  // right: 20,
                  // left: 20,
                ),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    showSearchBox: true,
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
                      txtMarketer.text = listMicMarketer[index].id.toString();
                    });
                  },
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
                        style: styleG,
                      ),
                    ),
                  ),
                ),
              ),
            ],

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
                    listSsatStation.isEmpty
                        ? []
                        : listSsatStation.map((e) => e.nom).toList(),
                validator:
                    (value) => value == null ? 'Choisissez le maerketer' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    int index = listSsatStation.indexWhere(
                      (element) => element.nom == newValue.toString(),
                    );
                    poi = listSsatStation[index].id;
                    latitude =
                        listSsatStation[index].center.latitude.toString();
                    longitude =
                        listSsatStation[index].center.longitude.toString();
                    txtNom.text = newValue!;
                    // txtVille.text = listSsatStation[index].address.city;
                  });
                },
                // popupItemDisabled: (String s) => s.startsWith('I'),
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
                      style: styleG,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // right: 20,
                // left: 20,
              ),
              child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  showSearchBox: true,
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
                    txtVille.text = listMicVille[indx].id.toString();
                  });
                },
                // popupItemDisabled: (String s) => s.startsWith('I'),
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
            ////
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
                onChanged: (value) {
                  txtAdresse.text = value;
                },
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
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  label: Text(
                    "Adresse",
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styleG,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10, left: 30, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_licence.isEmpty) ...[
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        toolbarOptions: ToolbarOptions(
                          copy: false,
                          cut: false,
                          paste: false,
                          selectAll: false,
                        ),
                        enabled: false,
                        onChanged: (value) {
                          txtLicence.text = _licence;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez séléctionner la licence d'exploitation";
                          }
                          return null;
                        },
                        autofocus: true,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Séléctionner la licence d\'exploitation',
                        ),
                      ),
                    ),
                  ],
                  if (_licence.isNotEmpty) ...[
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                _licence,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Icon(Icons.picture_as_pdf, color: red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.download, color: green),
                      // onPressed: () {},
                      onPressed:
                          _pickFileInProgressLicence ? null : _pickDocumentAss,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Entrer la date début",
                      ),
                      controller: _debutLicence,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Entrer la date";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat(
                            'yyyy-MM-dd',
                          ).format(pickedDate);
                          setState(() {
                            ddLicence = pickedDate;
                            _debutLicence.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Entrer la date de fin",
                      ),
                      controller: _finLicence,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Entrer la date";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat(
                            'yyyy-MM-dd',
                          ).format(pickedDate);
                          setState(() {
                            dfLicence = pickedDate;
                            _finLicence.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ),
                ],
              ),
            ),

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
                        overflow: TextOverflow.ellipsis,
                        style: btnTxtCOlor,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: btnTxtCOlor,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          micAddStation();
                          Navigator.pop(context);
                          // Navigator.pop(context);
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
