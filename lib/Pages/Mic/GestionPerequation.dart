// ignore_for_file: prefer_const_constructors, unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/ModelRapport/ModelTableau.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Statistiques/RapportPerMarketer.dart';
import 'package:sygeq/Statistiques/StartPerProduit.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GestionPerequation extends StatefulWidget {
  int marketerId;
  GestionPerequation({super.key, required this.marketerId});
  @override
  State<GestionPerequation> createState() => _GestionPerequationState();
}

class _GestionPerequationState extends State<GestionPerequation> {
  // List<Employee> employees = <Employee>[];
  late RapportMicMarketer rapportDataSource;
  late bool isLandscapeInMobileView;
  late bool isWebOrDesktop;
  String _filterStartDebutDate = "";
  String _filterStartFinDate = "";
  List marketerIds = [];
  var rapportPerMarketer;
  bool _animate = true;
  String _qty = "0";
  String _collet_fond = "0";
  String _prevision_frais = "0";
  String _differentiel = "0";
  String _caisse_perequation = "0";
  String _bilan = '';
  List<RapportPerMarketer> rapportMarketer = [];
  List<ModelTableauRapport> listRapportbls = [];
  List<TotalRapportMarketer> totalRapportMarketer = [];
  final DateTime _filterDateDebut = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  final DateTime _filterDateFin = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  );
  String _dateStart = "";
  String _dateFin = "";
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  getRapportPerMarketer() async {
    listRapportbls = [];
    var data = await RemoteServices.getRapportPerMarketer(
      _dateStart,
      _dateFin,
      [widget.marketerId],
    );
    setState(() {
      _bilan = data['bilan'];
      _collet_fond = data['cbl_tp'].toString();
      _prevision_frais = data['ftbl'].toString();
      _differentiel = data['cbl_tdt'].toString();
      _caisse_perequation = data['cp'].toString();
      rapportPerMarketer = data;
    });
    var list = rapportPerMarketer['data'] as List;
    setState(() {
      rapportMarketer =
          list.map((e) => RapportPerMarketer.fromJson(e)).toList();
    });

    for (var element in rapportMarketer) {
      setState(() {
        _bilan = element.bilan!;
        _collet_fond = element.cblTp!;
        _prevision_frais = element.ftbl!;
        _differentiel = element.cblTdt!;
      });
      for (var elets in element.bls) {
        var dif = elets.cblTp - elets.ftbl;
        List<SartProduit> product = [];
        for (var element in elets.detailsLivraisonsRappot) {
          product.add(element.produit);
        }
        setState(() {
          listRapportbls.add(
            ModelTableauRapport(
              element.marketer!,
              elets.numeroBl!,
              elets.date.toString(),
              elets.ftbl,
              elets.cblTp,
              elets.cblTtid,
              elets.cblTdt,
              elets.qty,
              elets.date_chargement!,
              elets.date_dechargement!,
              elets.station!.ville.nom,
              elets.station!.ville.detailVille![0].distance.toString(),
              elets.station!.ville.detailVille![0].tarifProduitsBlanc
                  .toString(),
              elets.station!.nomStation,
              dif,
              product,
            ),
          );
        });
      }
    }
    setState(() {
      rapportDataSource = RapportMicMarketer(
        dataMarketrRapport: listRapportbls,
      );
    });
    setState(() {
      _animate = false;
    });
    return rapportDataSource;
  }

  @override
  void initState() {
    super.initState();
    rapportDataSource = RapportMicMarketer(dataMarketrRapport: listRapportbls);
    DateTime _now = DateTime.now();
    _dateStart =
        "${_filterDateDebut.month}-${_filterDateDebut.day}-${_filterDateDebut.year}";
    _dateFin =
        "${_filterDateFin.month}-${_filterDateFin.day}-${_filterDateFin.year}";
    _filterStartDebutDate = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.parse(DateTime(_now.year, _now.month, 1).toString()));
    _filterStartFinDate = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.parse(DateTime(_now.year, _now.month + 1, 0).toString()));
    getRapportPerMarketer();
  }

  @override
  void dispose() {
    super.dispose();
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
          'Péréquation',
          style: styleAppBar,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 1,
        ),
      ),
      // backgroundColor: gryClaie,
      body:
          _animate == true
              ? animationLoadingData()
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: logoDecoration(),
                    height:
                        _size.height < _size.width
                            ? _size.width / 12
                            : _size.height / 12,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF8F8FB),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: blue,
                                      style: BorderStyle.solid,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  _filterStartDebutDate,
                                  style: TextStyle(color: blue),
                                ),
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      // _filterDateDebut = pickedDate;
                                      _filterStartDebutDate = DateFormat(
                                        'dd MMM yyyy',
                                      ).format(
                                        DateTime.parse(
                                          DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                          ).toString(),
                                        ),
                                      );
                                      _dateStart =
                                          "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Text('à', textScaleFactor: 1),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF8F8FB),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: blue,
                                      style: BorderStyle.solid,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  _filterStartFinDate,
                                  style: TextStyle(color: blue),
                                ),
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _dateFin =
                                          "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
                                      _filterStartFinDate = DateFormat(
                                        'dd MMM yyyy',
                                      ).format(
                                        DateTime.parse(
                                          DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                          ).toString(),
                                        ),
                                      );
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: blue,
                              ),
                              width: double.infinity,
                              height:
                                  _size.height < _size.width
                                      ? _size.width / 18
                                      : _size.height / 20,
                              child: IconButton(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                color: Colors.white,
                                icon: Icon(
                                  Icons.autorenew_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (_filterDateDebut.compareTo(
                                        _filterDateFin,
                                      ) >
                                      0) {
                                    fToast.showToast(
                                      child: toastWidget(
                                        'Intervalle de date incorrect',
                                      ),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration: Duration(seconds: 5),
                                    );
                                  } else {
                                    setState(() {
                                      getRapportPerMarketer();
                                    });
                                    // getStatPer();
                                  }
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: blue,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: green,
                                      style: BorderStyle.solid,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: 10, right: 5, left: 5, bottom: 10),
                  //   child: Container(
                  //     height: _size.height > _size.width
                  //         ? _size.height / 10
                  //         : _size.height / 6,
                  //     width: _size.width / 2,
                  //     child: DropdownSearch<String>(
                  //       popupProps: PopupProps.menu(
                  // showSearchBox: true,),
                  //       items: listMicMarketer.isEmpty
                  //           ? []
                  //           : listMicMarketer.map((e) => e.nom).toList(),
                  //       validator: (value) =>
                  //           value == null ? 'Choisissez le marketer' : null,
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           int index = listMicMarketer.indexWhere(
                  //               (element) => element.nom == newValue.toString());

                  //           // dropdownValue = newValue!;
                  //           marketerIds.add(listMicMarketer[index].id.toString());
                  //         });
                  //         setState(() {
                  //           getRapportPerMarketer();
                  //         });
                  //       },
                  //       dropdownDecoratorProps: DropDownDecoratorProps(
                  //         dropdownSearchDecoration: InputDecoration(
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           label: Text(
                  //             "Marketers",
                  //             softWrap: true,
                  //             textScaleFactor: 1,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: styleG,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  if (listRapportbls.length < 0)
                    Expanded(child: EmptyMessage()),
                  if (listRapportbls.length > 0)
                    // rapportPerMarketer.length < 0
                    // ? EmptyMessage()
                    Expanded(
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                          headerColor: blue,
                          frozenPaneElevation: 5,
                          frozenPaneLineColor: red,
                        ),
                        child: SfDataGrid(
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.horizontal,
                          footerHeight: 150,
                          footer: Container(
                            // height: 500,
                            // decoration: BoxDecoration(color: gryfoncee),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Text(
                                              'Provision de frais de transport',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Flexible(
                                            child: Text(
                                              _prevision_frais,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Text(
                                              'Caisse de pérequation',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Flexible(
                                            child: Text(
                                              _caisse_perequation,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Text(
                                              'Différentiel',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Flexible(
                                            child: Text(
                                              _differentiel,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Text(
                                              'Bilan',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Flexible(
                                            flex: 3,
                                            child: Text(
                                              _bilan,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          key: _key,
                          // showCheckboxColumn: true,
                          // selectionMode: SelectionMode.multiple,
                          source: rapportDataSource,
                          columns: <GridColumn>[
                            if (rapportDataSource.rows.isNotEmpty) ...[
                              GridColumn(
                                columnName: 'bl',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'BL',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // GridColumn(
                              //   columnName: 'marketer',
                              //   label: Container(
                              //     // padding: EdgeInsets.symmetric(horizontal: 16.0),
                              //     alignment: Alignment.center,
                              //     child: Text(
                              //       'Marketer',
                              //       // overflow: TextOverflow.ellipsis,
                              //     ),
                              //   ),
                              // ),
                              GridColumn(
                                columnName: 'station',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Station',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ville',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ville',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'dateBL',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Date du BL',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // GridColumn(
                              //   columnName: 'produit',
                              //   label: Container(
                              //     // padding: EdgeInsets.symmetric(horizontal: 16.0),
                              //     alignment: Alignment.center,
                              //     child: Text(
                              //       'Produits',
                              //       // overflow: TextOverflow.ellipsis,
                              //     ),
                              //   ),
                              // ),
                              GridColumn(
                                columnName: 'DateC',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Date chargement',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'DateR',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Date de réception',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ftbl',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Prévision de frais de transport',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'cbl_tp',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'collecte de fond',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'dif',
                                label: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Différentiel',
                                    style: TextStyle(color: white),
                                    overflow: TextOverflow.ellipsis,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}

class RapportMicMarketer extends DataGridSource {
  RapportMicMarketer({required List<ModelTableauRapport> dataMarketrRapport}) {
    dataGridRows =
        dataMarketrRapport
            .map<DataGridRow>(
              (dataGridRow) => DataGridRow(
                cells: [
                  DataGridCell<String>(
                    columnName: 'bl',
                    value: dataGridRow.numBl,
                  ),
                  // DataGridCell<String>(
                  //     columnName: 'marketer', value: dataGridRow.marketer),
                  DataGridCell<String>(
                    columnName: 'station',
                    value: dataGridRow.station,
                  ),
                  DataGridCell<String>(
                    columnName: 'ville',
                    value: dataGridRow.ville,
                  ),
                  DataGridCell<String>(
                    columnName: 'dateBL',
                    value: dataGridRow.date,
                  ),
                  // DataGridCell<List<SartProduit>>(
                  //     columnName: 'produit', value: dataGridRow.produit),
                  DataGridCell<String>(
                    columnName: 'DateC',
                    value: dataGridRow.date_chargement,
                  ),
                  DataGridCell<String>(
                    columnName: 'DateR',
                    value: dataGridRow.date_dechargement,
                  ),
                  DataGridCell<int>(
                    columnName: 'ftbl',
                    value: dataGridRow.ftbl,
                  ),
                  DataGridCell<int>(
                    columnName: 'cbl_tp',
                    value: dataGridRow.cbl_tp,
                  ),
                  DataGridCell<int>(columnName: 'dif', value: dataGridRow.dif),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((dataGridCell) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child:
                  // dataGridCell.columnName == 'produit'
                  //     ? IconButton(
                  //         onPressed: () {
                  //           // actionOnTheMoreProduct(dataGridCell.value);
                  //         },
                  //         icon: Icon(Icons.info))
                  //     :
                  dataGridCell.columnName == 'dateBL' ||
                          dataGridCell.columnName == 'DateC' ||
                          dataGridCell.columnName == 'DateR'
                      ? dataGridCell.value.toString() != ''
                          ? Text(
                            DateFormat('dd MMM yyyy').format(
                              DateTime.parse(dataGridCell.value.toString()),
                            ),
                            textScaleFactor: 0.9,
                          )
                          : null
                      : Text(
                        dataGridCell.value.toString(),
                        textScaleFactor: 0.9,
                        style:
                            dataGridCell.columnName == 'dif'
                                ? TextStyle(
                                  color: dataGridCell.value < 0 ? red : green,
                                )
                                : null,
                      ),
            );
          }).toList(),
    );
  }
}
