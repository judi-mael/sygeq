// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, deprecated_member_use, unused_field, body_might_complete_normally_nullable, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/SsatMarkers.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Pages/AllUser/DetailStation.dart';
import 'package:sygeq/Pages/AllUser/NewStation.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

List<SsatMarkers> listSsatStationNoFilter = [];

class MicAddStation extends StatefulWidget {
  const MicAddStation({Key? key}) : super(key: key);

  @override
  State<MicAddStation> createState() => _MicAddStationState();
}

class _MicAddStationState extends State<MicAddStation> {
  bool _obscuretext = true;
  // List<Station> listStation = [];
  List<Station> filterList = [];
  bool _firstSearch = true;
  String _query = "";
  final _searchview = TextEditingController();
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
  _MicAddStationState() {
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
  final refreshKey = GlobalKey<RefreshIndicatorState>();
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

  actionOnTheStation(var data) {
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
              child: DetailStation(data: data),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await micGetStation();
      });
    });
  }

  micGetSssatListNoFilter() async {
    var data = await RemoteServices.micGetSsatListStationNoFilter();
    setState(() {
      listSsatStationNoFilter = data;
    });
    return data;
  }

  @override
  void dispose() {
    super.dispose();
    listSsatStationNoFilter.clear();
    listSsatStation.clear();
    listStation.clear();
  }

  micGetSssatList() async {
    var data = await RemoteServices.micGetSsatListStation();
    setState(() {
      listSsatStation = data;
    });
    return data;
  }

  // micAddStation() async {
  //   var data = await RemoteServiceMic.micAddStation(
  //     txtAgrement.text.toString().trim(),
  //     // txtIfu.text.toString().trim(),
  //     txtNom.text.toString().trim(),
  //     txtVille.text.toString().trim(),
  //     txtAdresse.text.toString().trim(),
  //     txtMarketer.text.toString().trim(),
  //     // txtName.text.toString().trim(),
  //     // txtLogin.text.toString().trim(),
  //     // txtEmail.text.toString().trim(),
  //     poi,
  //     latitude,
  //     longitude,
  //     _licence,
  //     _debutLicence.text.trim().toString(),
  //     _finLicence.text.trim().toString(),

  //     // txtRC.text.toString().trim(),
  //   );
  //   return fToast.showToast(
  //     child: toastWidget(data['message']),
  //     gravity: ToastGravity.BOTTOM,
  //     toastDuration: Duration(seconds: 5),
  //   );
  // }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetStation);
  }

  bool _animate = true;
  micGetStation() async {
    var data = await RemoteServices.allGetListeStation();
    // if (!mounted) return null;
    setState(() {
      listStation = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return listStation;
  }

  @override
  void initState() {
    listStation = [];
    super.initState();
    micGetStation();
    micGetSssatList();
    micGetSssatListNoFilter();
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
    // txtRC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Stations",
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
                : listStation.isEmpty
                ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EmptyList(),
                        EmptyMessage(),
                        TextButton.icon(
                          style: TextButton.styleFrom(backgroundColor: blue),
                          onPressed: () {
                            setState(() {
                              micGetStation();
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
                        //     "Liste des Stations",
                        //     maxLines: 1,
                        //     softWrap: true,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: styleG,
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 10,
                            right: 10,
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
                                  icon: Icon(Icons.search, color: green),
                                ),
                                label: Text(
                                  "Rechercher une Station",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: styleG,
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 239, 241),
                                hintText: "Station",
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
                                  left: 10,
                                  right: 10,
                                ),
                                child: ListView.builder(
                                  itemCount: listStation.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: ((context, index) {
                                    return listStation[index].type == 'STATION'
                                        ? GestureDetector(
                                          onTap: () {
                                            var data = {
                                              'id': listStation[index].id,
                                              'agrement':
                                                  listStation[index].agrement,
                                              'rccm': listStation[index].rccm,
                                              'marketer':
                                                  listStation[index]
                                                      .marketer
                                                      .id,
                                              'marketerNom':
                                                  listStation[index]
                                                      .marketer
                                                      .nom,
                                              'ville':
                                                  listStation[index].ville.id,
                                              'villeNom':
                                                  listStation[index].ville.nom,
                                              'ifu': listStation[index].ifu,
                                              'delete':
                                                  listStation[index].deletedAt,
                                              'adresse':
                                                  listStation[index].adresse,

                                              // 'registre': listStation[index].,
                                              'nom':
                                                  listStation[index].nomStation,
                                            };
                                            actionOnTheStation(data);
                                          },
                                          child: Column(
                                            children: [
                                              listStationCard(
                                                listStation[index],
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        )
                                        : Container();
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
                            child: NewStation(),
                          ),
                        ),
                      );
                    },
                  );
                  setState(() {
                    micGetStation();
                  });
                },
                child: Icon(Icons.add, color: Colors.white),
              )
              : Container(),
    );
  }

  Widget _performSearch() {
    filterList.clear();
    for (int i = 0; i < listStation.length; i++) {
      var item = listStation[i];

      if (item.nomStation.toLowerCase().contains(_query.toLowerCase()) ||
          item.marketer.nom.toLowerCase().contains(_query.toLowerCase())) {
        filterList.add(item);
      }
    }
    return _filterlist();
  }

  Widget _filterlist() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: ListView.builder(
          itemCount: filterList.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            return filterList[index].type == 'STATION'
                ? GestureDetector(
                  onTap: () {
                    var data = {
                      'id': filterList[index].id,
                      'agrement': filterList[index].agrement,
                      'rccm': filterList[index].rccm,
                      'marketer': filterList[index].marketer.id,
                      'marketerNom': filterList[index].marketer.nom,
                      'ville': filterList[index].ville.id,
                      'villeNom': filterList[index].ville.nom,
                      'ifu': filterList[index].ifu,
                      'delete': filterList[index].deletedAt,
                      'adresse': filterList[index].adresse,

                      // 'registre': filterList[index].,
                      'nom': filterList[index].nomStation,
                    };
                    actionOnTheStation(data);
                  },
                  child: Column(
                    children: [listStationCard(filterList[index]), Divider()],
                  ),
                )
                : Container();
          }),
        ),
      ),
    );
  }

  // Widget createStation() {
  //   return SingleChildScrollView(
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     child: Form(
  //       key: formKey,
  //       child: Column(
  //         children: [
  //           // HeaderMic(),
  //           Text(
  //             "Nouvelle Station",
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //             softWrap: true,
  //             style: GoogleFonts.montserrat(
  //                 fontWeight: FontWeight.bold, color: green),
  //           ),
  //           Divider(),
  //           /////////////////////////
  //           ///SSat /
  //           ///////////////////////
  //           if (prefUserInfo['marketerId'].toString() == '0') ...[
  //             Padding(
  //               padding: const EdgeInsets.only(
  //                 top: 10,
  //                 // right: 20,
  //                 // left: 20,
  //               ),
  //               child: DropdownSearch<String>(
  //                 popupProps: PopupProps.menu(showSearchBox: true,),
  //                 items: listMicMarketer.isEmpty
  //                     ? []
  //                     : listMicMarketer.map((e) => e.nom).toList(),
  //                 validator: (value) =>
  //                     value == null ? 'Choisissez le marketer' : null,
  //                 onChanged: (String? newValue) {
  //                   setState(() {
  //                     int index = listMicMarketer.indexWhere(
  //                         (element) => element.nom == newValue.toString());

  //                     // dropdownValue = newValue!;
  //                     txtMarketer.text = listMicMarketer[index].id.toString();
  //                   });
  //                 },

  //                 dropdownDecoratorProps: DropDownDecoratorProps(
  //                   dropdownSearchDecoration: InputDecoration(
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     label: Text(
  //                       "Marketers",
  //                       softWrap: true,
  //                       textScaleFactor: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: styleG,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],

  //           Padding(
  //             padding: const EdgeInsets.only(
  //               top: 10,
  //               // right: 20,
  //               // left: 20,
  //             ),
  //             child: DropdownSearch<String>(
  //               popupProps: PopupProps.menu(showSearchBox: true,),
  //               items: listSsatStation.isEmpty
  //                   ? []
  //                   : listSsatStation.map((e) => e.nom).toList(),
  //               validator: (value) =>
  //                   value == null ? 'Choisissez le maerketer' : null,
  //               onChanged: (String? newValue) {
  //                 setState(() {
  //                   int index = listSsatStation.indexWhere(
  //                       (element) => element.nom == newValue.toString());
  //                   poi = listSsatStation[index].id;
  //                   latitude =
  //                       listSsatStation[index].center.latitude.toString();
  //                   longitude =
  //                       listSsatStation[index].center.longitude.toString();
  //                   txtNom.text = newValue!;
  //                   // txtVille.text = listSsatStation[index].address.city;
  //                 });
  //               },
  //               // popupItemDisabled: (String s) => s.startsWith('I'),
  //               // isFilteredOnline: true,
  //               // showSearchBox: true,
  //               // showSelectedItems: true,
  //               dropdownDecoratorProps: DropDownDecoratorProps(

  //               dropdownSearchDecoration: InputDecoration(
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 label: Text(
  //                   'Station',
  //                   softWrap: true,
  //                   textScaleFactor: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: styleG,
  //                 ),
  //               ),
  //               ),
  //             ),
  //           ),

  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 10,
  //               // right: 20,
  //               // left: 20,
  //             ),
  //             child: DropdownSearch<String>(
  //               popupProps: PopupProps.menu(showSearchBox: true,),
  //               items: listMicVille.isEmpty
  //                   ? []
  //                   : listMicVille.map((e) => e.nom).toList(),
  //               validator: (value) =>
  //                   value == null ? 'Choisissez la ville' : null,
  //               onChanged: (String? newValue) {
  //                 setState(() {
  //                   int indx = listMicVille.indexWhere(
  //                       (element) => element.nom == newValue.toString());
  //                   txtVille.text = listMicVille[indx].id.toString();
  //                 });
  //               },
  //               // popupItemDisabled: (String s) => s.startsWith('I'),
  //               // isFilteredOnline: true,
  //               // showSearchBox: true,
  //               // showSelectedItems: true,
  //               dropdownDecoratorProps: DropDownDecoratorProps(

  //               dropdownSearchDecoration: InputDecoration(
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 hintText: 'Ville',
  //               ),
  //               ),
  //             ),
  //           ),
  //           ////
  //           /////////////////////////
  //           /// Adresse Station
  //           /// ////////////////////
  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 10,
  //               // left: 20,
  //               // right: 20,
  //             ),
  //             child: TextFormField(
  //               onChanged: (value) {
  //                 txtAdresse.text = value;
  //               },
  //               validator: (value) {
  //                 return value!.isEmpty ? "Ce champs est obligatoire" : null;
  //               },
  //               toolbarOptions: ToolbarOptions(
  //                 copy: false,
  //                 cut: false,
  //                 paste: false,
  //                 selectAll: false,
  //               ),
  //               // maxLength: 12,
  //               minLines: 1,
  //               keyboardType: TextInputType.streetAddress,
  //               decoration: InputDecoration(
  //                 label: Text(
  //                   "Adresse",
  //                   textScaleFactor: 1,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: styleG,
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //               ),
  //             ),
  //           ),

  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 10,
  //               left: 30,
  //               right: 20,
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 if (_licence.isEmpty) ...[
  //                   Flexible(
  //                     flex: 3,
  //                     child: TextFormField(
  //                       toolbarOptions: ToolbarOptions(
  //                         copy: false,
  //                         cut: false,
  //                         paste: false,
  //                         selectAll: false,
  //                       ),
  //                       enabled: false,
  //                       onChanged: (value) {
  //                         txtLicence.text = _licence;
  //                       },
  //                       validator: (value) {
  //                         if (value!.isEmpty) {
  //                           return "Veuillez séléctionner la licence d'exploitation";
  //                         }
  //                       },
  //                       autofocus: true,
  //                       readOnly: true,
  //                       decoration: InputDecoration(
  //                           hintText:
  //                               'Séléctionner la licence d\'exploitation'),
  //                     ),
  //                   )
  //                 ],
  //                 if (_licence.isNotEmpty) ...[
  //                   Flexible(
  //                     flex: 3,
  //                     child: Container(
  //                       child: Row(
  //                         children: [
  //                           Flexible(
  //                             flex: 3,
  //                             child: Text(_licence,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 softWrap: true,
  //                                 maxLines: 1,
  //                                 style: styleG),
  //                           ),
  //                           Flexible(
  //                             flex: 1,
  //                             child: Icon(
  //                               Icons.picture_as_pdf,
  //                               color: red,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //                 Flexible(
  //                   flex: 1,
  //                   child: IconButton(
  //                     icon: Icon(
  //                       Icons.download,
  //                       color: green,
  //                     ),
  //                     // onPressed: () {},
  //                     onPressed:
  //                         _pickFileInProgressLicence ? null : _pickDocumentAss,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),

  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 5,
  //               left: 20,
  //               right: 20,
  //             ),
  //             child: Row(
  //               children: [
  //                 Flexible(
  //                   flex: 2,
  //                   child: TextFormField(
  //                     readOnly: true,
  //                     decoration: InputDecoration(
  //                       icon: Icon(Icons.calendar_today),
  //                       labelText: "Entrer la date début",
  //                     ),
  //                     controller: _debutLicence,
  //                     validator: (value) {
  //                       if (value!.isEmpty) {
  //                         return "Entrer la date";
  //                       }
  //                     },
  //                     onTap: () async {
  //                       DateTime? pickedDate = await showDatePicker(
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(2000),
  //                         lastDate: DateTime(2101),
  //                       );
  //                       if (pickedDate != null) {
  //                         String formattedDate =
  //                             DateFormat('yyyy-MM-dd').format(pickedDate);
  //                         setState(() {
  //                           ddLicence = pickedDate;
  //                           _debutLicence.text = formattedDate;
  //                         });
  //                       } else {}
  //                     },
  //                   ),
  //                 ),
  //                 Flexible(
  //                   flex: 2,
  //                   child: TextFormField(
  //                     readOnly: true,
  //                     decoration: InputDecoration(
  //                       icon: Icon(Icons.calendar_today),
  //                       labelText: "Entrer la date de fin",
  //                     ),
  //                     controller: _finLicence,
  //                     validator: (value) {
  //                       if (value!.isEmpty) {
  //                         return "Entrer la date";
  //                       }
  //                     },
  //                     onTap: () async {
  //                       DateTime? pickedDate = await showDatePicker(
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(2000),
  //                         lastDate: DateTime(2101),
  //                       );
  //                       if (pickedDate != null) {
  //                         String formattedDate =
  //                             DateFormat('yyyy-MM-dd').format(pickedDate);
  //                         setState(() {
  //                           dfLicence = pickedDate;
  //                           _finLicence.text = formattedDate;
  //                         });
  //                       } else {}
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),

  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 10,
  //               // left: 20,
  //               // right: 20,
  //             ),
  //             child: SizedBox(
  //               width: double.infinity,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: blue,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       "Annuler",
  //                       softWrap: true,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: styleG,
  //                     ),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                   ),
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: green,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       "Enregistrer",
  //                       softWrap: true,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: styleG,
  //                     ),
  //                     onPressed: () {
  //                       if (formKey.currentState!.validate()) {
  //                         micAddStation();
  //                         Navigator.pop(context);
  //                         // Navigator.pop(context);
  //                       } else {}
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
