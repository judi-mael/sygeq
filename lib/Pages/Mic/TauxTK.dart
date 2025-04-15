// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Tauxtks.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailTauxTK.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class TauxTK extends StatefulWidget {
  const TauxTK({Key? key}) : super(key: key);

  @override
  State<TauxTK> createState() => _TauxTKState();
}

class _TauxTKState extends State<TauxTK> {
  List<Tauxtks> listTauxTK = [];
  List<Tauxtks> listTauxTKActif = [];
  late TextEditingController txtValeurTK, txtRef, txtDateStart, txtDateEnd;
  final formKey = GlobalKey<FormState>();
  bool _isActif = true;
  bool _isInactif = false;
  DateTime? dt1;
  DateTime? dt2;
  bool _animate = true;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  micAddTauxTK() async {
    var data = RemoteServiceMic.micAddTauxTK(
      txtValeurTK.text.toString().trim(),
      txtRef.text.toString().trim(),
      txtDateStart.text.toString().trim(),
      txtDateEnd.text.toString().trim(),
    );
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetListTaxTKS);
  }

  actionOnTheTaux(var data) {
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
              child: DetailTauxtK(data: data),
            ),
          ),
        );
      },
    );
  }

  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'ttks');
    return data;
  }

  micGetListTaxTKS() async {
    var dataActif = await RemoteServices.allGetListeTauxTKActif();
    var data = await RemoteServices.allGetListeTauxTK();

    // if (!mounted) return null;
    setState(() {
      listTauxTKActif = dataActif;
      listTauxTK = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    micGetListTaxTKS();
    txtDateEnd = TextEditingController();
    txtDateStart = TextEditingController();
    txtValeurTK = TextEditingController();
    txtRef = TextEditingController();
  }

  //////////////////////////////////
  ///////////// get all taux tk //////////
  /// ////////////////////

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
          "TAUX TK",
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
                : listTauxTK.isEmpty
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
                            micGetListTaxTKS();
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
                                      reverse: false,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.height /
                                                    2.75),

                                            // crossAxisSpacing: 0,
                                          ),
                                      itemCount: listTauxTKActif.length,
                                      // shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            var data = {
                                              'valeurTK':
                                                  listTauxTKActif[index]
                                                      .valeurtk,
                                              'ref': listTauxTKActif[index].ref,
                                              'id': listTauxTKActif[index].id,
                                              'dateStart':
                                                  listTauxTKActif[index]
                                                      .dateDebut,
                                              'dateEnd':
                                                  listTauxTKActif[index]
                                                      .dateFin,
                                            };
                                            actionOnTheTaux(data);
                                          },
                                          child: Card(
                                            semanticContainer: false,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  listTauxTKActif[index]
                                                      .valeurtk,
                                                  maxLines: 1,
                                                  textScaleFactor: 1.2,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    : GridView.builder(
                                      reverse: false,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.height /
                                                    2.75),

                                            // crossAxisSpacing: 0,
                                          ),
                                      itemCount: listTauxTK.length,
                                      // shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            var data = {
                                              'valeurTK':
                                                  listTauxTK[index].valeurtk,
                                              'ref': listTauxTK[index].ref,
                                              'id': listTauxTK[index].id,
                                              'dateStart':
                                                  listTauxTK[index].dateDebut,
                                              'dateEnd':
                                                  listTauxTK[index].dateFin,
                                            };
                                            actionOnTheTaux(data);
                                          },
                                          child: Card(
                                            semanticContainer: false,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  listTauxTK[index].valeurtk,
                                                  maxLines: 1,
                                                  textScaleFactor: 1.2,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
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
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.all(
      //                     Radius.circular(10),
      //                   ),
      //                 ),
      //                 insetPadding: EdgeInsets.all(10),
      //                 child: Container(
      //                   padding: EdgeInsets.all(10),
      //                   child: createTauxTK(),
      //                 )),
      //           );
      //         });
      //     setState(() {
      //       micGetListTaxTKS();
      //     });

      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }

  Widget createTauxTK() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            HeaderMic(),
            Text(
              "Nouveau  Taux TK",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: styleG,
            ),
            ///////////////////////////////
            /// Taux TK
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                onChanged: (value) {
                  txtValeurTK.text = value;
                },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(paste: false),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text(
                    "Taux TK",
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

            /////////////////////////
            /// Refrence du taux TK
            /// ////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                onChanged: (value) {
                  txtRef.text = value;
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
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Référence",
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

            //////////////////////////
            ///Date debut
            /////////////////////////
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
                          micAddTauxTK().then((val) {
                            fToast.showToast(
                              child: toastWidget(val['message']),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 5),
                            );
                          });
                          Navigator.pop(context);
                        } else {}
                        setState(() {
                          micAddTauxTK();
                        });
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
