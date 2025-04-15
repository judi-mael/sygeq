// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, unused_field, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailTransporteur.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class Transporteur extends StatefulWidget {
  const Transporteur({Key? key}) : super(key: key);

  @override
  State<Transporteur> createState() => _TransporteurState();
}

class _TransporteurState extends State<Transporteur> {
  List<Driver> listTransporteur = [];
  List<Driver> filterList = [];
  DateTime? dt1;
  DateTime? dt2;
  final _searchview = TextEditingController();
  bool _firstSearch = true;
  bool _animate = true;
  String _query = "";
  bool _obscuretext = true;
  String _ifuDocument = '';
  String _agrementDocument = '';
  bool _iosPublicDataUTI = true;
  bool _pickFileInProgressifu = false;
  bool _pickFileInProgressagrement = false;
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
      txtAgrementDocument,
      txtIfuDocument,
      txtIfu,
      txtAdresse,
      txtAgrement,
      txtRegistre,
      txtDateStart,
      txtDateEnd,
      txtLogin,
      txtEmail,
      txtName;
  final formKey = GlobalKey<FormState>();
  _TransporteurState() {
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
  @override
  void dispose() {
    super.dispose();
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

  actionOnTheTransporteur(var data) {
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
              child: DetailTransporteur(data: data),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await micGetTransporteur();
      });
    });
  }

  micAddTransporteur() {
    var data = RemoteServiceMic.micAddTransporteur(
      txtNom.text.toString().trim(),
      txtIfu.text.toString().trim(),
      txtAgrement.text.toString().trim(),
      // txtEmail.text.toString().trim(),
      txtAdresse.text.toString().trim(),
      txtDateStart.text.toString().trim(),
      txtDateEnd.text.toString().trim(),
      txtIfuDocument.text.toString(),
      txtAgrementDocument.text.toString(),
      // txtName.text.toString().trim(),
      // txtLogin.text.toString().trim(),
    );
    return data;
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    micGetTransporteur();
    txtDateEnd = TextEditingController();
    txtDateStart = TextEditingController();
    txtNom = TextEditingController();
    txtIfu = TextEditingController();
    txtNom = TextEditingController();
    txtAgrement = TextEditingController();
    txtAdresse = TextEditingController();
    txtIfu = TextEditingController();
    txtName = TextEditingController();
    txtLogin = TextEditingController();
    txtEmail = TextEditingController();
    listTransporteur.sort();
  }

  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'trs');
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetTransporteur);
  }

  //////////////////////////////////
  ///////////// get all Transporteur //////////
  /// ////////////////////
  micGetTransporteur() async {
    var res = await RemoteServices.allGetListeTransporteur();
    // if (!mounted) return null;
    setState(() {
      listTransporteur = res;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return listTransporteur;
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
        title: Text(
          "Transporteur",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styleAppBar,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listTransporteur.isEmpty
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
                            micGetTransporteur();
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
                        // HeaderMic(),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     top: 20,
                        //     left: 30,
                        //     right: 30,
                        //   ),
                        //   child: Text(
                        //     "Liste des transporteurs",
                        //     maxLines: 1,
                        //     softWrap: true,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: styleG,
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
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
                                  "Rechercher un Transporteur",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: styleG,
                                ),
                                filled: true,
                                // fillColor: Color.fromARGB(255, 162, 175, 235),
                                hintText: "Transporteur",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                  itemCount: listTransporteur.length,
                                  itemBuilder: ((context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        var data = {
                                          'id': listTransporteur[index].id,
                                          'nom': listTransporteur[index].nom,
                                          'agrement':
                                              listTransporteur[index].agrement,
                                          'DateStart':
                                              listTransporteur[index]
                                                  .dateVigeur,
                                          'DateEnd':
                                              listTransporteur[index].dateExp,
                                          'ifu': listTransporteur[index].ifu,
                                          'adresse':
                                              listTransporteur[index].adresse,
                                          'delete':
                                              listTransporteur[index].deletedAt,
                                        };

                                        actionOnTheTransporteur(data);
                                      },
                                      child: listDesTransporteurs(
                                        listTransporteur[index],
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
                            child: createTransporteur(),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.add, color: Colors.white),
              )
              : Container(),
    );
  }

  Widget _performSearch() {
    filterList.clear();
    for (int i = 0; i < listTransporteur.length; i++) {
      var item = listTransporteur[i];

      if (item.nom.toLowerCase().contains(_query.toLowerCase())) {
        filterList.add(item);
      }
    }
    return _filterlist();
  }

  Widget _filterlist() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: filterList.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                var data = {
                  'id': filterList[index].id,
                  'nom': filterList[index].nom,
                  'agrement': filterList[index].agrement,
                  'DateStart': filterList[index].dateVigeur,
                  'DateEnd': filterList[index].dateExp,
                  'ifu': filterList[index].ifu,
                  'adresse': filterList[index].adresse,
                  'delete': filterList[index].deletedAt,
                  // 'adress':listTransporteur[index].
                };
                actionOnTheTransporteur(data);
              },
              child: listDesTransporteurs(filterList[index]),
            );
          }),
        ),
      ),
    );
  }

  Widget createTransporteur() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // HeaderMic(),
            Text(
              "Nouveau Transporteur ",
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: green,
              ),
            ),
            Divider(),
            ///////////////////////////////
            /// Nom Transporteur
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                onChanged: (value) {
                  txtNom.text = value;
                },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(paste: false),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Nom transporteur",
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
            ///////////////////////////////
            /// Adresse Transporteur
            /// /////////////////////////
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
                toolbarOptions: ToolbarOptions(paste: false),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Adresse",
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
            ///////////////////////////////
            /// Agrement Transporteur
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                onChanged: (value) {
                  txtAgrement.text = value;
                },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(paste: false),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Agrément",
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez séléctionner le RCCM";
                          }
                        },
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

            ///////////////////////////////
            /// IFU Transporteur
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                onChanged: (value) {
                  txtIfu.text = value;
                },
                validator: (value) {
                  if (value!.length > 14) {
                    return "Ce champs est obligatoire";
                  }
                  if (value.length < 14) {
                    return "Ce champs doit comporter au moins 14 caractères";
                  }
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                toolbarOptions: ToolbarOptions(paste: false),
                maxLength: 14,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Ifu",
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez séléctionner le document IFU";
                          }
                        },
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

            ///////////////////////////////
            ////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtDateStart,
                keyboardType: TextInputType.none,
                // textAlign: TextAlign.start,
                toolbarOptions: ToolbarOptions(
                  copy: false,
                  cut: false,
                  paste: false,
                  selectAll: false,
                ),
                validator:
                    (value) => value == null ? 'Choisissez la date' : null,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 0)),
                    lastDate: DateTime(2102),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dt1 = pickedDate;
                      txtDateStart.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () {},
                  ),
                  label: Text(
                    "Date de début",
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: GoogleFonts.montserrat(color: green),
                  ),
                ),
                // onChanged: (value) {},
              ),
            ),

            //////////////////////////
            ///Date de fin
            /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtDateEnd,
                keyboardType: TextInputType.none,
                // textAlign: TextAlign.start,
                toolbarOptions: ToolbarOptions(
                  copy: false,
                  cut: false,
                  paste: false,
                  selectAll: false,
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Choisissez la date';
                  }
                  if (dt1!.compareTo(dt2!) > 0) {
                    return 'La date de début ne peut pas être anterieur à la date de fin';
                  }
                  null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2102),
                    initialDatePickerMode: DatePickerMode.day,
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dt2 = pickedDate;
                      txtDateEnd.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () {},
                  ),
                  label: Text(
                    "Date de Fin",
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: GoogleFonts.montserrat(color: green),
                  ),
                ),
                // onChanged: (value) {},
              ),
            ),

            ///////////////////////////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // right: 20,
                // left: 20,
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
                          micAddTransporteur().then((val) {
                            fToast.showToast(
                              child: toastWidget(val['message']),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 5),
                            );
                          });
                          Navigator.pop(context);
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
