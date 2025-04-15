// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, unused_field, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Pages/Mic/NewMarketer.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailMarketer.dart';

import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class MicAddMarketer extends StatefulWidget {
  const MicAddMarketer({Key? key}) : super(key: key);

  @override
  State<MicAddMarketer> createState() => _MicAddMarketerState();
}

class _MicAddMarketerState extends State<MicAddMarketer> {
  final _searchview = TextEditingController();
  List<Marketer> listMarketer = [];
  List<Marketer> filterList = [];
  bool _firstSearch = true;
  String _query = "";
  DateTime? dt1;
  DateTime? dt2;
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
  _MicAddMarketerState() {
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
  String messageText = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  actionOnTheMarketer(var data) {
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
              padding: EdgeInsets.all(8.0),
              child: DetailMarketer(data: data),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await micGetMarketer();
      });
    });
  }

  String message = '';

  Widget toast = Container(
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: defautlCardColors,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: green, size: 20),
        SizedBox(width: 12.0),
        Text(
          "Marketer ajouter avec succès",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
      ],
    ),
  );

  late TextEditingController txtAgrement,
      txtAgrementDocument,
      txtIfu,
      txtIfuDocument,
      txtDateStart,
      txtNom,
      txtAdresse,
      txtDateEnd,
      txtLogin,
      txtEmail,
      txtName;
  final formKey = GlobalKey<FormState>();

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
    setState(() {});
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

  micAddMarketer() async {
    var data = await RemoteServiceMic.micAddMarketer(
      txtNom.text.toString().trim(),
      txtIfu.text.toString().trim(),
      txtAgrement.text.toString().trim(),
      txtEmail.text.toString().trim(),
      txtAdresse.text.toString().trim(),
      txtDateStart.text.toString().trim(),
      txtDateEnd.text.toString().trim(),
      txtName.text.toString().trim(),
      txtLogin.text.toString().trim(),
      txtIfuDocument.text.toString(),
      txtAgrementDocument.text.toString(),
    );
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetMarketer);
  }

  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'marketers');
    return data;
  }

  bool _animate = true;
  @override
  void initState() {
    super.initState();
    micGetMarketer();
    txtAdresse = TextEditingController();
    txtNom = TextEditingController();
    txtAgrement = TextEditingController();
    txtDateStart = TextEditingController();
    txtDateEnd = TextEditingController();
    txtIfu = TextEditingController();
    txtLogin = TextEditingController();
    txtEmail = TextEditingController();
    txtIfuDocument = TextEditingController();
    txtAgrementDocument = TextEditingController();
    txtName = TextEditingController();
  }

  micGetMarketer() async {
    List list = [];

    var valu = await RemoteServices.getAllMarketerList();
    setState(() {
      listMarketer = valu;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return valu;
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  // @override
  // void dispose() {
  //   txtLogin.dispose();
  //   super.dispose();
  // }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        title: Text(
          "Marketers",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styleAppBar,
        ),
      ),
      backgroundColor: gryClaie,
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listMarketer.isEmpty
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
                            micGetMarketer();
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
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 22,
                            right: 22,
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
                                  icon: Icon(
                                    Icons.search,
                                    color: green,
                                    size: 35,
                                  ),
                                ),
                                label: Text(
                                  "Rechercher un Marketer",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: styleG,
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 245, 246, 247),
                                hintText: "Marketer",
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
                                  itemCount: listMarketer.length,
                                  itemBuilder: (context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        var data = {
                                          'id': listMarketer[index].id,
                                          'nom': listMarketer[index].nom,
                                          'agrement':
                                              listMarketer[index].agrement,
                                          'registre':
                                              listMarketer[index].registre,
                                          'adresse':
                                              listMarketer[index].adresse,
                                          'delete':
                                              listMarketer[index].deletedAt,
                                          'DateStart':
                                              listMarketer[index].dateVigueur,
                                          'ifu': listMarketer[index].ifu,
                                          'DateEnd':
                                              listMarketer[index]
                                                  .dateExpiration,
                                        };
                                        actionOnTheMarketer(data);
                                      },
                                      child: listDesMarketer(
                                        listMarketer[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMarketer()),
          ).then((value) {
            setState(() async {
              await micGetMarketer();
            });
          });
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return Dialog(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(10),
          //           ),
          //         ),
          //         insetPadding: EdgeInsets.all(5),
          //         child: Container(
          //           padding: EdgeInsets.all(10),
          //           child: createMarketer(),
          //         ),
          //       );
          //   }).then((value) {
          // setState(() async {
          //   await micGetMarketer();
          // });
          // });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _performSearch() {
    filterList.clear();
    for (int i = 0; i < listMarketer.length; i++) {
      var item = listMarketer[i];

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
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                var data = {
                  'id': filterList[index].id,
                  'nom': filterList[index].nom,
                  'agrement': filterList[index].agrement,
                  'registre': filterList[index].registre,
                  'adresse': filterList[index].adresse,
                  'delete': filterList[index].deletedAt,
                  'DateStart': filterList[index].dateVigueur,
                  'ifu': filterList[index].ifu,
                  'DateEnd': filterList[index].dateExpiration,
                };
                actionOnTheMarketer(data);
              },
              child: listDesMarketer(filterList[index]),
            );
          },
        ),
      ),
    );
  }

  Widget createMarketer() {
    bool obscure = true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Nouveau Marketer",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: styleAppBar,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Text(
                //   "Nouveau Marketer",
                //   overflow: TextOverflow.ellipsis,
                //   softWrap: true,
                //   maxLines: 1,
                //   style: GoogleFonts.montserrat(
                //       fontWeight: FontWeight.bold, color: green),
                // ),
                // Divider(),
                // HeaderMic(),
                ///////////////////////////////
                /// Nom du marketer
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
                      return value!.isEmpty
                          ? "Ce champs est obligatoire"
                          : null;
                    },
                    toolbarOptions: ToolbarOptions(paste: false),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      label: Text(
                        "Nom Marketer",
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
                /// Adresse
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
                      return value!.isEmpty
                          ? "Ce champs est obligatoire"
                          : null;
                    },
                    toolbarOptions: ToolbarOptions(paste: false),
                    keyboardType: TextInputType.emailAddress,
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
                /// Ifu
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
                      if (value!.length < 13) {
                        return "Ce champs est obligatoire";
                      }
                      if (value.length < 13) {
                        return "Ce champs doit comporter au moins 14 caractères";
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    toolbarOptions: ToolbarOptions(paste: false),
                    maxLength: 13,
                    keyboardType: TextInputType.emailAddress,
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
                /// Ifu
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
                      return value!.isEmpty
                          ? "Ce champs est obligatoire"
                          : null;
                    },
                    toolbarOptions: ToolbarOptions(paste: false),
                    keyboardType: TextInputType.emailAddress,
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
                //// Date Start
                ////////////////////////////////
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
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2102),
                        initialDatePickerMode: DatePickerMode.day,
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
                        "Date de Début",
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
                ///////////////////////////////
                //// Date de fin d'agrément
                ////////////////////////////////
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
                        keyboardType: TextInputType.none,
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022).subtract(Duration(days: 1)),
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
                /// Information de connexion
                /// //////////////////////////////////////////
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    // left: 20,
                    // right: 20,
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      txtName.text = value;
                    },
                    validator: (value) {
                      return value!.isEmpty
                          ? "Ce champs est obligatoire"
                          : null;
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
                  padding: EdgeInsets.only(
                    top: 10,
                    // left: 20,
                    // right: 20,
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      txtLogin.text = value;
                    },
                    validator: (value) {
                      return value!.isEmpty
                          ? "Ce champs est obligatoire"
                          : null;
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
                  padding: EdgeInsets.only(
                    top: 10,
                    // left: 20,
                    // right: 20,
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      txtEmail.text = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'e-mail doit comporter au moins 08 caractères & 20 au plus';
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
                            setState(() {
                              micGetMarketer();
                            });
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
                              micAddMarketer().then((val) {
                                fToast.showToast(
                                  child: toast,
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 5),
                                );
                              });
                              Navigator.pop(context);
                            } else {}
                            // setState(() {
                            //   micGetMarketer();
                            // });
                          },
                        ),
                      ],
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
