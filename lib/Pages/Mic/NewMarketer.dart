import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class NewMarketer extends StatefulWidget {
  const NewMarketer({super.key});

  @override
  State<NewMarketer> createState() => _NewMarketerState();
}

class _NewMarketerState extends State<NewMarketer> {
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

  void initState() {
    super.initState();
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
                              return null;
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
                              return null;
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
                      return null;
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
