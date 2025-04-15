// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class AddB2B extends StatefulWidget {
  const AddB2B({super.key});

  @override
  State<AddB2B> createState() => _AddB2BState();
}

class _AddB2BState extends State<AddB2B> {
  // List<Station> listB2B = [];
  List<String> marketerIds = [];
  List<String> marketerNom = [];
  int poi = 0;
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
  micAddB2B() async {
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

  micGetSssatList() async {
    var data = await RemoteServices.micGetSsatListStation();
    setState(() {
      listSsatB2B = data;
    });
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

  micGetVille() async {
    var res = await RemoteServices.allGetListeVilles();
    // if (!mounted) return null;
    setState(() {
      listMicVille = res;
    });
    return res;
  }

  @override
  void initState() {
    super.initState();
    micGetSssatList();
    micGetVille();
    txtAdresse = TextEditingController();
    txtIfu = TextEditingController();
    txtVille = TextEditingController();
    txtNom = TextEditingController();
    txtName = TextEditingController();
    txtEmail = TextEditingController();
    txtLogin = TextEditingController();
    txtAgrement = TextEditingController();
    txtRC = TextEditingController();
    txtIfuDocument = TextEditingController();
    txtAgrementDocument = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Ajouter un B2B",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styleAppBar,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              //   child: DropDownMultiSelect<String>(
              //     // mode: Mode.MENU,
              //     whenEmpty: 'Choisir les marketers',
              //     options: listMicMarketer.isEmpty
              //         ? []
              //         : listMicMarketer.map((e) => e.nom).toList(),
              //     // validator: (value) =>
              //     //     value == null ? 'Choisissez le marketer' : null,
              //     onChanged: (List<String> x) {
              //       marketerIds = [];
              //       marketerNom = [];
              //       for (var elt in x) {
              //         setState(() {
              //           int index = listMicMarketer.indexWhere(
              //               (element) => element.nom == elt.toString());

              //           marketerNom.add(listMicMarketer[index].nom);
              //           marketerIds.add(listMicMarketer[index].id.toString());
              //         });
              //       }
              //     },
              //     selectedValues: marketerNom,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       label: Text(
              //         "Marketers",
              //         softWrap: true,
              //         textScaleFactor: 1,
              //         overflow: TextOverflow.ellipsis,
              //         style: styleG,
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
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

              // child: DropdownSearch<String>(
              //   mode: Mode.MENU,
              //   items: listSsatB2B.isEmpty
              //       ? []
              //       : listSsatB2B.map((e) => e.nom).toList(),
              //   validator: (value) =>
              //       value == null ? 'Choisissez le maerketer' : null,
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       int index = listSsatB2B.indexWhere(
              //           (element) => element.nom == newValue.toString());
              //       poi = listSsatB2B[index].id;
              //       latitude = listSsatB2B[index].center.latitude.toString();
              //       longitude = listSsatB2B[index].center.longitude.toString();
              //       txtNom.text = newValue!;
              //     });
              //   },
              //   isFilteredOnline: true,
              //   showSearchBox: true,
              //   showSelectedItems: true,
              //   dropdownSearchDecoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     label: Text(
              //       'Station',
              //       softWrap: true,
              //       textScaleFactor: 1,
              //       overflow: TextOverflow.ellipsis,
              //       style: styleG,
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: DropdownSearch<String>(
                  enabled: true,
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
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
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
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
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
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
                  onChanged: (value) {
                    txtRC.text = value;
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

              /////////////////////////
              /// Ville Station
              /// ////////////////////
              ///////////////////////////////////////////
              // Information de connexion
              //////////////////////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Informations sur l\'utilisateur'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10,
                  // left: 20,
                  // right: 20,
                ),
                child: TextFormField(
                  onChanged: (value) {
                    txtName.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "Nom complet",
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
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                child: TextFormField(
                  onChanged: (value) {
                    txtLogin.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "Login / identifiant",
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
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                child: TextFormField(
                  onChanged: (value) {
                    txtEmail.text = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'L\'e-mail est vide';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "exmeple : xyz@exe.com";
                    }
                    return null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "E-mail",
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
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                      "Enregistrer",
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        micAddB2B();
                        Navigator.pop(context);
                      } else {}
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
