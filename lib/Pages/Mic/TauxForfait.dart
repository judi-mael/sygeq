// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, body_might_complete_normally_nullable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/TauxForfait.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailTauxForfait.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class MicAddTauxForfait extends StatefulWidget {
  const MicAddTauxForfait({Key? key}) : super(key: key);

  @override
  State<MicAddTauxForfait> createState() => _MicAddTauxForfaitState();
}

class _MicAddTauxForfaitState extends State<MicAddTauxForfait> {
  List<TauxForfait> listTauxForfait = [];
  List<TauxForfait> listTauxForfaitActif = [];
  DateTime? dt1;
  DateTime? dt2;
  bool _animate = true;
  bool _isActif = true;
  bool _isInactif = false;
  late TextEditingController txtTauxForfait, txtDateStart, txtDateEnd;
  final formkey = GlobalKey<FormState>();
  micAddTauxforfait() {
    var data = RemoteServiceMic.micAddTauxForfait(
      txtTauxForfait.text.toString().trim(),
      // txtDistance.text.toString().trim(),
      txtDateStart.text.toString().trim(),
      txtDateEnd.text.toString().trim(),
    );
    return data;
  }

  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'tfs');
    return data;
  }

  micgetTauxForfait() async {
    var dataActif = await RemoteServices.allGetListeTauxForfaitActif();
    var data = await RemoteServices.allGetListeTauxForfait();
    // if (!mounted) return null;
    setState(() {
      listTauxForfaitActif = dataActif;
      listTauxForfait = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  actionOnTheTauxForfait(var data) {
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
              child: DetailTauxForfait(data: data),
            ),
          ),
        );
      },
    ).then((value){
      setState(()async {
        refreshKey;
        await micgetTauxForfait;
      });
    });
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micgetTauxForfait);
  }

  @override
  void initState() {
    super.initState();
    micgetTauxForfait();
    txtDateEnd = TextEditingController();
    txtTauxForfait = TextEditingController();
    txtDateStart = TextEditingController();
    // txtDistance = TextEditingController();
  }

  //////////////////////////////////
  ///////////// get all Taux Forfait //////////
  /// ////////////////////

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
          "Tarif forfaitaire",
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
                : listTauxForfait.isEmpty
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
                            micgetTauxForfait();
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
                        HeaderMic(),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 30,
                            right: 30,
                          ),
                          child: Container(
                            color: defautlCardColors,
                            height:
                                _size.height > _size.width
                                    ? _size.height / 15
                                    : _size.width / 15,
                            child: Row(
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isActif = true;
                                        _isInactif = false;
                                      });
                                    },
                                    child: Container(
                                      height:
                                          _size.height > _size.width
                                              ? _size.height / 15
                                              : _size.width / 15,
                                      decoration:
                                          _isActif
                                              ? BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: blue,
                                                borderRadius:
                                                    BorderRadius.vertical(),
                                              )
                                              : null,
                                      child: Center(
                                        child: Text(
                                          'Actif',
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.2,
                                          style: GoogleFonts.montserrat(
                                            color:
                                                _isActif ? Colors.white : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isActif = false;
                                        _isInactif = true;
                                      });
                                    },
                                    child: Container(
                                      height:
                                          _size.height > _size.width
                                              ? _size.height / 15
                                              : _size.width / 15,
                                      child: Center(
                                        child: Text(
                                          'Inactif',
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.2,
                                          style: GoogleFonts.montserrat(
                                            color:
                                                _isInactif
                                                    ? Colors.white
                                                    : null,
                                          ),
                                        ),
                                      ),
                                      decoration:
                                          _isInactif
                                              ? BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: blue,
                                                borderRadius:
                                                    BorderRadius.vertical(),
                                              )
                                              : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (listTauxForfait.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 20,
                                right: 20,
                              ),
                              child:
                                  _isActif
                                      ? GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 0,
                                              childAspectRatio:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  (MediaQuery.of(
                                                        context,
                                                      ).size.height /
                                                      4),
                                            ),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: listTauxForfaitActif.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              var data = {
                                                'dateEnd':
                                                    listTauxForfaitActif[index]
                                                        .dateExpiration,
                                                'dateStart':
                                                    listTauxForfaitActif[index]
                                                        .dateVigeur,
                                                'tauxForfait':
                                                    listTauxForfaitActif[index]
                                                        .tauxforfait,
                                                // 'distance':li,
                                                'id': listTauxForfait[index].id,
                                                'distance':
                                                    listTauxForfaitActif[index]
                                                        .distance,
                                              };
                                              actionOnTheTauxForfait(data);
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             DetailTauxForfait(data: data)));
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    listTauxForfaitActif[index]
                                                        .tauxforfait,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                      : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 0,
                                              childAspectRatio:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  (MediaQuery.of(
                                                        context,
                                                      ).size.height /
                                                      4),
                                            ),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: listTauxForfait.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              var data = {
                                                'dateEnd':
                                                    listTauxForfait[index]
                                                        .dateExpiration,
                                                'dateStart':
                                                    listTauxForfait[index]
                                                        .dateVigeur,
                                                'tauxForfait':
                                                    listTauxForfait[index]
                                                        .tauxforfait,
                                                // 'distance':li,
                                                'id': listTauxForfait[index].id,
                                                'distance':
                                                    listTauxForfait[index]
                                                        .distance,
                                              };
                                              actionOnTheTauxForfait(data);
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             DetailTauxForfait(data: data)));
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    listTauxForfait[index]
                                                        .tauxforfait,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                            ),
                          ),
                        // if (listTauxForfait.isEmpty)
                        //   Center(
                        //     child: ElevatedButton(
                        //       child: Text(
                        //         'Réessayer',
                        //         softWrap: true,
                        //         overflow: TextOverflow.ellipsis,
                        //         maxLines: 1,
                        //       ),
                        //       onPressed: () {
                        //         refresh();
                        //       },
                        //     ),
                        //   )
                      ],
                    ),
                  ),
                ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: blue,
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Dialog(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.all(
      //                   Radius.circular(10),
      //                 ),
      //               ),
      //               insetPadding: EdgeInsets.all(10),
      //               child: Container(
      //                 padding: EdgeInsets.all(10),
      //                 child: createTauxForfait(),
      //               ),
      //             ),
      //           );
      //         }).then((value) {
      //       setState(() async {
      //         await micgetTauxForfait();
      //       });
      //     });

      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }

  Widget createTauxForfait() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formkey,
        child: Column(
          children: [
            HeaderMic(),
            /////////////////////////
            /// taux Forfait
            /// ////////////////////
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                onChanged: (value) {
                  txtTauxForfait.text = value;
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
                maxLength: 12,
                minLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text(
                    "Taux forfait",
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
            /// Distance
            /// ////////////////////

            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 20,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: TextFormField(
            //     onChanged: (value) {
            //       txtDistance.text = value;
            //     },
            //     validator: (value) {
            //       return value!.isEmpty ? "Ce champs est obligatoire" : null;
            //     },
            //     toolbarOptions: ToolbarOptions(
            //       copy: false,
            //       cut: false,
            //       paste: false,
            //       selectAll: false,
            //     ),
            //     maxLength: 12,
            //     minLines: 1,
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Distance",
            //         textScaleFactor: 1,
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //         style: styleG,
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //   ),
            // ),

            //////////////////////////
            ///Date de début
            /////////////////////////
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
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
                    initialDate: DateTime.now().subtract(Duration(days: 1)),
                    firstDate: DateTime(2022).subtract(Duration(days: 1)),
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
            ///Date de FIn
            /////////////////////////
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    overflow: TextOverflow.ellipsis,
                    style: btnTxtCOlor,
                  ),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      micAddTauxforfait().then((val) {
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
