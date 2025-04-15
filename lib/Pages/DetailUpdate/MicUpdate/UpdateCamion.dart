// ignore_for_file: prefer_const_constructors, deprecated_member_use, must_be_immutable, unused_field, body_might_complete_normally_nullable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/Viehicul.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateCamion extends StatefulWidget {
  var data;
  List<Compartiment> listCompartiment = [];
  UpdateCamion({Key? key, required this.data, required this.listCompartiment})
    : super(key: key);

  @override
  State<UpdateCamion> createState() => _UpdateCamionState();
}

class _UpdateCamionState extends State<UpdateCamion> {
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
  String _slp = '';
  String _cetificarDeBar = '';
  String _assurance = '';
  String _visiteTec = '';
  bool _pickFileInProgressB = false;
  bool _pickFileInProgresscdb = false;
  bool _pickFileInProgressAssurance = false;
  bool _pickFileInProgressvt = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = true;
  DateTime? ddVT;
  DateTime? dfVT;
  DateTime? ddCB;
  DateTime? dfCB;
  DateTime? ddSlp;
  DateTime? dfSlp;
  DateTime? ddAss;
  DateTime? dfAss;
  List? listcomp = [];
  List<Vehicule> listMicVehiculNoFilter = [];
  int nbr = 0;
  String ssat = "";
  String num = "";
  String cap = "";
  // String txtMarque = "";
  String txtImmatriclation = "";
  int txtTransporteur = 0;
  String transporteur = "";
  late TextEditingController txtNvrVanne,
      txtAnne,
      txtType,
      txtslp,
      txtCdb,
      txtVt,
      _debutVt,
      _finSpl,
      _debutSpl,
      _finVT,
      _debutCB,
      _finCB,
      _debutAss,
      _finAss,
      txtAssurance,
      txtMarque;
  final formKey = GlobalKey<FormState>();
  final formKeyadd = GlobalKey<FormState>();
  final formKeyupd = GlobalKey<FormState>();
  micUpdateCamion() async {
    var data = await RemoteServiceMic.micUpdateCamion(
      widget.data['id'],
      txtImmatriclation,
      txtNvrVanne.text.toString().trim(),
      txtAnne.text.toString().trim(),
      txtType.text.toString().trim(),
      txtMarque.text.trim(),
      txtTransporteur.toString(),
      ssat,
      listcomp!,
      _slp,
      _cetificarDeBar,
      _visiteTec,
      _assurance,
    );
    return data;
  }

  misGetVehiculListNoFilter() async {
    var data = await RemoteServices.micGetSsatListVehiculNoFilter();
    setState(() {
      listMicVehiculNoFilter = data;
    });
    await getInitTrans();
    return data;
  }

  getInitTrans() async {
    if (listMicTransporteur.isNotEmpty) {
      if (widget.data['driver'] != null) {
        int index = listMicTransporteur.indexWhere(
          (element) => element.nom.trim() == widget.data['driver'],
        );
        if (index >= 0) {
          setState(() {
            txtTransporteur = listMicTransporteur[index].id;
            transporteur = listMicTransporteur[index].nom;
          });
        }
      }
    }
    if (widget.data['immat'] != null) {
      int index = listMicVehiculNoFilter.indexWhere(
        (element) => element.immatricul == widget.data['immat'],
      );
      if (index >= 0) {
        setState(() {
          txtImmatriclation = listMicVehiculNoFilter[index].immatricul;
          txtMarque.text = listMicVehiculNoFilter[index].marque;
          ssat = listMicVehiculNoFilter[index].id.toString();
        });
      }
    }
    // if (listMicVehiculNoFilter.isNotEmpty) {

    // }
  }

  _pickDocumentAss() async {
    String? result;
    try {
      setState(() {
        _assurance = '';
        _pickFileInProgressAssurance = true;
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
        _pickFileInProgressAssurance = false;
      });
    }
    setState(() {
      _assurance = result!;
      txtAssurance.text = _assurance;
    });
  }

  _pickDocumentcdb() async {
    String? result;
    try {
      setState(() {
        _cetificarDeBar = '';
        _pickFileInProgresscdb = true;
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
        _pickFileInProgresscdb = false;
      });
    }
    setState(() {
      _cetificarDeBar = result!;
      txtCdb.text = _cetificarDeBar;
    });
  }

  _pickDocumentVt() async {
    String? result;
    try {
      setState(() {
        _visiteTec = '';
        _pickFileInProgressvt = true;
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
        _pickFileInProgressvt = false;
      });
    }
    setState(() {
      _visiteTec = result!;
      txtVt.text = _visiteTec;
    });
  }

  _pickDocumentSlp() async {
    String? result;
    try {
      setState(() {
        _slp = '';
        _pickFileInProgressB = true;
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
      // result = 'Error: $e';
      _slp = '';
    } finally {
      setState(() {
        _slp = '';
        _pickFileInProgressB = false;
      });
    }
    setState(() {
      _slp = result!;
      txtslp.text = _slp;
    });
  }

  @override
  void initState() {
    if (widget.listCompartiment.isNotEmpty) {
      for (var element in widget.listCompartiment) {
        listcomp!.add("${element.numero};${element.capacite}");
      }
    }
    super.initState();
    _debutCB = TextEditingController();
    _debutVt = TextEditingController();
    _debutSpl = TextEditingController();
    _debutAss = TextEditingController();
    _finCB = TextEditingController();
    _finVT = TextEditingController();
    _finSpl = TextEditingController();
    _finAss = TextEditingController();
    txtCdb = TextEditingController();
    txtslp = TextEditingController();
    txtVt = TextEditingController();
    txtAssurance = TextEditingController();
    txtNvrVanne = TextEditingController(text: "${widget.data['nbrVanne']}");
    txtAnne = TextEditingController(text: "${widget.data['annee']}");
    txtType = TextEditingController(text: "${widget.data['type']}");
    txtMarque = TextEditingController(text: "${widget.data['marque']}");
    txtImmatriclation = widget.data['immat'];
    nbr = int.parse("${widget.data['nbrVanne']}");
    misGetVehiculListNoFilter();
    // ssat = listMicVehiculNoFilter[listMicVehiculNoFilter.indexWhere(
    //         (element) => element.immatricul == txtImmatriclation.toString())]
    //     .id
    //     .toString();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: gryClaie,
      appBar: AppBar(
        iconTheme: IconThemeData(color: gryClaie),
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Modifier le  Camion",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: styleAppBar,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // HeaderMic(),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    showSearchBox: true,
                  ),
                  items:
                      listMicTransporteur.isEmpty
                          ? []
                          : listMicTransporteur.map((e) => e.nom).toList(),
                  validator:
                      (value) =>
                          value == null ? 'Choisissez le transporeur' : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      int index = listMicTransporteur.indexWhere(
                        (element) => element.nom == newValue.toString(),
                      );
                      // dropdownValue = newValue!;
                      txtTransporteur = listMicTransporteur[index].id;
                    });
                  },
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  selectedItem: transporteur,
                  // isFilteredOnline: true,
                  // showSearchBox: true,
                  // showSelectedItems: true,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Transporteur',
                    ),
                  ),
                ),
              ),
              ///////////////////////////////
              /// Immetriculation Comion
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    showSearchBox: true,
                  ),
                  items:
                      listMicVehiculNoFilter.isEmpty
                          ? []
                          : listMicVehiculNoFilter
                              .map((e) => e.immatricul)
                              .toList(),
                  validator:
                      (value) =>
                          value == null ? 'Choisissez le transporteur' : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      int index = listMicVehiculNoFilter.indexWhere(
                        (element) => element.immatricul == newValue.toString(),
                      );
                      // dropdownValue = newValue!;
                      txtImmatriclation =
                          listMicVehiculNoFilter[index].immatricul.toString();
                      txtMarque.text =
                          listMicVehiculNoFilter[index].marque.toString();
                      ssat = listMicVehiculNoFilter[index].id.toString();
                    });
                  },
                  selectedItem: txtImmatriclation,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        "Immatriculation",
                        softWrap: true,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_assurance.isEmpty) ...[
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
                            txtAssurance.text = _assurance;
                          },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Veuillez séléctionner l'assurance";
                          //   }
                          // },
                          autofocus: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Séléctionner l\'assurance',
                          ),
                        ),
                      ),
                    ],
                    if (_assurance.isNotEmpty) ...[
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  _assurance,
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
                            _pickFileInProgressAssurance
                                ? null
                                : _pickDocumentAss,
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
                        controller: _debutAss,
                        validator: (value) {
                          if (_assurance.isEmpty) {
                            return null;
                          } else {
                            if (value!.isEmpty) {
                              return "Entrer la date";
                            }
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
                              ddAss = pickedDate;
                              _debutAss.text = formattedDate;
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
                        controller: _finAss,
                        validator: (value) {
                          if (_assurance.isEmpty) {
                            return null;
                          } else {
                            if (value!.isEmpty) {
                              return "Entrer la date";
                            }
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
                              dfAss = pickedDate;
                              _finAss.text = formattedDate;
                            });
                          } else {}
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_slp.isEmpty) ...[
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
                            txtslp.text = _slp;
                          },
                          autofocus: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Séléctionner le Passport',
                          ),
                        ),
                      ),
                    ],
                    if (_slp.isNotEmpty) ...[
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  _slp,
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
                        onPressed:
                            _pickFileInProgressB ? null : _pickDocumentSlp,
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
                        controller: _debutSpl,
                        validator: (value) {
                          if (_slp.isEmpty) {
                            return null;
                          } else {
                            if (value!.isEmpty) {
                              return "Entrer la date";
                            }
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
                              ddSlp = pickedDate;
                              _debutSpl.text = formattedDate;
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
                        controller: _finSpl,
                        validator: (value) {
                          if (_slp.isEmpty) {
                            return null;
                          } else {
                            if (value!.isEmpty) {
                              return "Entrer la date";
                            }
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
                              dfSlp = pickedDate;
                              _finSpl.text = formattedDate;
                            });
                          } else {}
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_visiteTec.isEmpty) ...[
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
                            txtVt.text = _visiteTec;
                          },
                          // validator: (value) {
                          //   if (_visiteTec.isEmpty) {
                          //     return "Veuillez séléctionner la visite technique";
                          //   }
                          // },
                          autofocus: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Séléctionner la visite technique',
                          ),
                        ),
                      ),
                    ],
                    if (_visiteTec.isNotEmpty) ...[
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  _visiteTec,
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
                        onPressed:
                            _pickFileInProgressvt ? null : _pickDocumentVt,
                      ),
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////
              ///partie de la visite technique
              //////////////////////////////////////////
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
                        controller: _debutVt,
                        validator: (value) {
                          if (_visiteTec.isEmpty) {
                            return null;
                          } else {
                            if (value!.isEmpty) {
                              return "Entrer la date";
                            }
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
                              ddVT = pickedDate;
                              _debutVt.text = formattedDate;
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
                        controller: _finVT,
                        validator: (value) {
                          if (_visiteTec.isEmpty) {
                            return null;
                          } else {
                            if (value!.isEmpty) {
                              return "Entrer la date";
                            }
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
                              dfVT = pickedDate;
                              _finVT.text = formattedDate;
                            });
                          } else {}
                        },
                      ),
                    ),
                  ],
                ),
              ),

              ///

              ///////////////////////////////
              /// TYype Comion
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: txtType,
                  // onChanged: (value) {
                  //   txtType.text = value;
                  // },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: Text(
                      "Type",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              /////////////////////////////////////////
              /// Annee Comion
              /// ////////////////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: txtAnne,
                  // onChanged: (value) {
                  //   txtAnne.text = value;
                  // },
                  validator: (value) {
                    return value!.length < 4
                        ? "La Valeur est incorrecte"
                        : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    label: Text(
                      "Année",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              /////////////////////////////////////////
              /// Nombre de compartiments Comion
              /// ////////////////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: txtNvrVanne,
                  onChanged: (value) {
                    txtNvrVanne.text = value;
                    setState(() {
                      if (txtNvrVanne.text.isNotEmpty) {
                        nbr = int.parse(txtNvrVanne.text.toString().trim());
                      }
                    });
                    // nbr = int.parse(txtNvrVanne.text);
                    // setState(() {
                    //   if (txtNvrVanne.text.isNotEmpty) {
                    //     nbr = int.parse(txtNvrVanne.text.trim());
                    //   }
                    // });
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text(
                      "Nombres de Compartiment",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: listcomp!.length < nbr ? true : false,
                      child: ElevatedButton(
                        onPressed: () {
                          if (txtNvrVanne.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: red,
                                duration: Duration(seconds: 3),
                                content: Text(
                                  "Le champs nombre de compartiment est vide",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  scrollable: true,
                                  content: Form(
                                    key: formKeyadd,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: TextFormField(
                                            toolbarOptions: ToolbarOptions(
                                              copy: false,
                                              cut: false,
                                              paste: false,
                                              selectAll: false,
                                            ),
                                            maxLength: 10,
                                            decoration: InputDecoration(
                                              label: Text(
                                                "Numèro de la vanne",
                                                style: TextStyle(color: green),
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              return value!.isEmpty
                                                  ? 'Entré le numéro de la vanne'
                                                  : null;
                                            },
                                            onChanged: (value) {
                                              num = value;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            toolbarOptions: ToolbarOptions(
                                              copy: false,
                                              cut: false,
                                              paste: false,
                                              selectAll: false,
                                            ),
                                            maxLength: 10,
                                            decoration: InputDecoration(
                                              label: Text(
                                                "Capacité",
                                                style: TextStyle(color: green),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              return value!.isEmpty
                                                  ? 'Entré la capacité du compartiment'
                                                  : null;
                                            },
                                            onChanged: (value) {
                                              cap = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[400],
                                      ),
                                      child: Text(
                                        "Annuler",
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        var detail = "";
                                        if (formKeyadd.currentState!
                                            .validate()) {
                                          setState(() {
                                            detail = "$num;$cap";
                                            listcomp!.add(detail);
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: green,
                                      ),
                                      child: Text(
                                        "Ajouter",
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                    Text("${listcomp!.length} / ${nbr}"),
                  ],
                ),
              ),

              ////////////////////////////////////////////////
              ////// Liste des compartiments déjà ajouté
              ////////////////////////////////////////////
              if (listcomp!.isNotEmpty)
                for (int index = 0; listcomp!.length > index; index++)
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      verticalDirection: VerticalDirection.down,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width:
                              _size.height > _size.width
                                  ? MediaQuery.of(context).size.width * 0.25
                                  : MediaQuery.of(context).size.width * 0.25,
                          child: Text(
                            "${index + 1}-  ${listcomp![index].toString().split(';')[0]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(
                          width:
                              _size.height > _size.width
                                  ? MediaQuery.of(context).size.width * 0.25
                                  : MediaQuery.of(context).size.width * 0.25,
                          child: Text(
                            listcomp![index].toString().split(';')[1],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                          ),
                        ),

                        //////////////////////////////////////////////////////
                        /// supprission et modification d'un compartiment déjà ajouter
                        /// /////////////////////////////////////////////////
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        scrollable: true,
                                        content: Container(
                                          child: Form(
                                            key: formKeyupd,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  // inputFormatters: [
                                                  //   FilteringTextInputFormatter
                                                  //       .digitsOnly
                                                  // ],
                                                  initialValue:
                                                      listcomp![index]
                                                          .toString()
                                                          .split(';')[0],
                                                  toolbarOptions:
                                                      ToolbarOptions(
                                                        copy: false,
                                                        cut: false,
                                                        paste: false,
                                                        selectAll: false,
                                                      ),
                                                  maxLength: 10,
                                                  decoration: InputDecoration(
                                                    label: Text(
                                                      "Numéro de la vanne",
                                                      style: TextStyle(
                                                        color: green,
                                                      ),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    return value!.isEmpty
                                                        ? 'Entré le numéro de la vanne'
                                                        : null;
                                                  },
                                                  onChanged: (value) {
                                                    num = value;
                                                  },
                                                ),
                                                TextFormField(
                                                  initialValue:
                                                      listcomp![index]
                                                          .toString()
                                                          .split(';')[1],
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  toolbarOptions:
                                                      ToolbarOptions(
                                                        copy: false,
                                                        cut: false,
                                                        paste: false,
                                                        selectAll: false,
                                                      ),
                                                  maxLength: 10,
                                                  decoration: InputDecoration(
                                                    label: Text(
                                                      "Capacité",
                                                      style: TextStyle(
                                                        color: green,
                                                      ),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    return value!.isEmpty
                                                        ? 'Entré la capacité du compartiment'
                                                        : null;
                                                  },
                                                  onChanged: (value) {
                                                    cap = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[400],
                                            ),
                                            child: Text(
                                              "Annuler",
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              var detail = "";
                                              if (formKeyupd.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  detail = "$num;$cap";
                                                  listcomp!.remove(
                                                    listcomp![index],
                                                  );
                                                  listcomp!.insert(
                                                    index,
                                                    detail,
                                                  );
                                                });
                                                Navigator.pop(context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: green,
                                            ),
                                            child: Text(
                                              "Ajouter",
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit_sharp, color: blue),
                              ),
                              IconButton(
                                onPressed: (() {
                                  listcomp!.remove(listcomp![index]);
                                  setState(() {});
                                }),
                                icon: Icon(Icons.cancel_rounded, color: red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

              Padding(
                padding: EdgeInsets.only(top: 30, right: 20, left: 20),
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
                      style: btnTxtCOlor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (listcomp!.length != nbr) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                scrollable: true,
                                content: Column(
                                  children: [
                                    Icon(Icons.dangerous, color: red, size: 60),
                                    Text(
                                      "Le nombre des compartiments ne correspond pas aux nombres de lignes",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          micUpdateCamion();
                          Navigator.pop(context);
                        }
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
