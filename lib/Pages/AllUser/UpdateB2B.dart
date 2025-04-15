// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Pages/AllUser/Stations.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateB2B extends StatefulWidget {
  var data;
  UpdateB2B({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateB2B> createState() => _UpdateB2BState();
}

class _UpdateB2BState extends State<UpdateB2B> {
  String longitude = "";
  String latitude = "";
  // String txtNom = "";
  int poi = 0;
  int txtVille = 0;
  int txtMarketer = 0;
  String nomMarketer = "";
  String nomVille = "";
  String _ifuDocument = '';
  String _agrementDocument = '';
  bool _pickFileInProgressifu = false;
  bool _pickFileInProgressagrement = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = true;
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
  late TextEditingController
      // txtMarketer,
      txtAgrementDocument,
      txtIfuDocument,
      txtAdresse,
      txtIfu,
      // txtVille,
      txtLogin,
      txtEmail,
      txtNom,
      // txtRC,
      // txtDateStart,
      // txtDateEnd,
      txtAgrement;
  final formKey = GlobalKey<FormState>();
  micUpdateB2B() async {
    var data = await RemoteServiceMic.micUpdateStation(
      widget.data['id'],
      txtAgrement.text.toString().trim(),
      // txtIfu.text.toString().trim(),
      txtNom.text,
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

  _pickDocumentIfu() async {
    String? result;
    try {
      setState(() {
        _ifuDocument = '';
        _pickFileInProgressifu = true;
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
        _pickFileInProgressifu = false;
      });
    }
    setState(() {
      _ifuDocument = result!;
      txtIfuDocument.text = _ifuDocument;
    });
  }

  _pickDocumentAgrement() async {
    String? result;
    try {
      setState(() {
        _agrementDocument = '';
        _pickFileInProgressagrement = true;
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
        _pickFileInProgressagrement = false;
      });
    }
    setState(() {
      _agrementDocument = result!;
      txtAgrementDocument.text = _agrementDocument;
    });
  }

  getLastStation() {
    // if (listSsatStation.isNotEmpty) {
    if (widget.data['nom'] != null) {
      int index = listSsatStationNoFilter.indexWhere(
        (element) => element.nom == widget.data['nom'],
      );
      if (index >= 0) {
        setState(() {
          txtNom.text = listSsatStationNoFilter[index].nom;
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
    txtVille = widget.data['id'];
    nomVille = widget.data['villeNom'];
    txtAdresse = TextEditingController(text: '${widget.data['adresse']}');
    txtAgrement = TextEditingController(text: "${widget.data['rccm']}");
    txtIfu = TextEditingController(text: "${widget.data['ifu']}");
    txtNom = TextEditingController(text: "${widget.data['nom']}");
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
              "Modifier un B2B",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.montserrat(color: green),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: txtNom,
                onChanged: (value) {
                  txtNom.text = value;
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
                    "Nom",
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
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: txtIfu,
                onChanged: (value) {
                  txtIfu.text = value;
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
                    "IFU",
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
              padding: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_ifuDocument.isEmpty) ...[
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
                          txtIfuDocument.text = _ifuDocument;
                        },
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "Veuillez séléctionner le document IFU";
                        //   }
                        // },
                        autofocus: true,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Séléctionner l\'Ifu',
                        ),
                      ),
                    ),
                  ],
                  if (_ifuDocument.isNotEmpty) ...[
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                _ifuDocument,
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
                          _pickFileInProgressifu ? null : _pickDocumentIfu,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: txtAgrement,
                onChanged: (value) {
                  txtAgrement.text = value;
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
                    "RCCM",
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
              padding: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_agrementDocument.isEmpty) ...[
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
                          txtAgrementDocument.text = _agrementDocument;
                        },
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "Veuillez séléctionner le RCCM";
                        //   }
                        // },
                        autofocus: true,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Séléctionner le RCCM',
                        ),
                      ),
                    ),
                  ],
                  if (_agrementDocument.isNotEmpty) ...[
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                _agrementDocument,
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
                          _pickFileInProgressagrement
                              ? null
                              : _pickDocumentAgrement,
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
                        maxLines: 1,
                        style: btnTxtCOlor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          micUpdateB2B();
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
