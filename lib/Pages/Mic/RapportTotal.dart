// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member, unused_local_variable, prefer_const_literals_to_create_immutables, unused_field

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/ModelRapport/ModelTableau.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Statistiques/RapportPerMarketer.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RapportTotal extends StatefulWidget {
  const RapportTotal({super.key});
  @override
  State<RapportTotal> createState() => _RapportTotalState();
}

class _RapportTotalState extends State<RapportTotal> {
  // List<Employee> employees = <Employee>[];
  late RapportMicMarketer rapportDataSource;
  late bool isLandscapeInMobileView;
  late bool isWebOrDesktop;
  String _filterStartDebutDate = "";
  String _filterStartFinDate = "";
  List marketerIds = [];
  String _qty = "0";
  String _collet_fond = "0";
  String _prevision_frais = "0";
  String _differentiel = "0";
  String _caisse_perequation = "0";
  String _bilan = '';
  var rapportPerMarketer;
  bool _animate = true;
  List<RapportPerMarketer> rapportMarketer = [];
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

  getRapportPerMarketer({String? id}) async {
    var data = await RemoteServices.getRapportPerMarketer(
      _dateStart,
      _dateFin,
      marketerIds,
    );
    setState(() {
      _bilan = data['bilan'];
      _collet_fond = data['cbl_tp'].toString();
      _prevision_frais = data['ftbl'].toString();
      _differentiel = data['cbl_tdt'].toString();
      int totdifferenciel =
          int.parse(data['cbl_tp']) - int.parse(data['ftbl'].toString());
      // _caisse_perequation = data['cp'].toString();
      _caisse_perequation = totdifferenciel.toString();
      totalRapportMarketer = [];
      rapportPerMarketer = data;
    });
    var list = rapportPerMarketer['data'] as List;
    setState(() {
      rapportMarketer =
          list.map((e) => RapportPerMarketer.fromJson(e)).toList();
    });
    for (var element in rapportMarketer) {
      setState(() {
        totalRapportMarketer.add(
          TotalRapportMarketer(
            element.marketer!,
            element.qty!,
            element.ftbl!,
            element.cblTp!,
            element.cblTtid!,
            element.cblTdt!,
            element.caisse!,
            element.bilan!,
          ),
        );
      });
    }
    setState(() {
      rapportDataSource = RapportMicMarketer(
        dataMarketrRapport: totalRapportMarketer,
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
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
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
                                shape: BoxShape.circle,
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 5,
                      left: 5,
                      bottom: 10,
                    ),
                    child: Container(
                      height:
                          _size.height > _size.width
                              ? _size.height / 10
                              : _size.height / 6,
                      width: _size.width / 2,
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          fit: FlexFit.loose,
                          showSearchBox: true,
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
                            marketerIds = [];
                            // dropdownValue = newValue!;
                            marketerIds.add(
                              listMicMarketer[index].id.toString(),
                            );
                          });
                          setState(() {
                            getRapportPerMarketer();
                          });
                        },
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
                              style: styleG,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //     child: Text('Export To Pdf'),
                  //     onPressed: () async {
                  //       PdfDocument document =
                  //           _key.currentState!.exportToPdfDocument();
                  //       final List<int> bytes = document.saveSync();
                  //       await helper.FileSaveHelper.saveAndLaunchFile(
                  //           bytes, 'DataGrid.pdf');
                  //       // document.dispose();

                  //       // Directory appDocDirectory =
                  //       //     await getApplicationDocumentsDirectory();
                  //       // String directoty = appDocDirectory.path;
                  //       // PdfPage pdfPage = document.pages.add();
                  //       // PdfGrid pdfGrid = _key.currentState!.exportToPdfGrid();
                  //       // pdfGrid.draw(
                  //       //   page: pdfPage,
                  //       //   bounds: Rect.fromLTWH(0, 0, 0, 0),
                  //       // );
                  //       // final List<int> bytes = await document.saveSync();
                  //       // await File('DataGrid.pdf')
                  //       // .writeAsBytes(bytes);
                  //     }),
                  rapportPerMarketer.length > 0
                      ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: SfDataGridTheme(
                            data: SfDataGridThemeData(
                              // gridLineColor: white,
                              headerColor: blue,
                              frozenPaneElevation: 5,
                              frozenPaneLineColor: red,
                            ),
                            child: SfDataGrid(
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              gridLinesVisibility:
                                  GridLinesVisibility.horizontal,
                              footerHeight: 150,
                              footer: Container(
                                // height: 500,
                                // decoration: BoxDecoration(color: gryfoncee),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Flexible(
                                                child: Text(
                                                  _prevision_frais,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Flexible(
                                                child: Text(
                                                  _caisse_perequation,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Flexible(
                                                child: Text(
                                                  _differentiel,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Flexible(
                                                flex: 3,
                                                child: Text(
                                                  _bilan,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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

                              columnWidthMode: ColumnWidthMode.auto,
                              key: _key,

                              // showCheckboxColumn: true,
                              // selectionMode: SelectionMode.multiple,
                              source: rapportDataSource,
                              columns: <GridColumn>[
                                if (rapportDataSource.rows.isNotEmpty) ...[
                                  GridColumn(
                                    allowSorting: false,
                                    columnName: 'marketer',
                                    label: Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Marketer',
                                        maxLines: 3,
                                        style: TextStyle(color: white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'qte',
                                    label: Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Quantité total',
                                        maxLines: 3,
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
                                        maxLines: 3,
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
                                        maxLines: 3,
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
                                        maxLines: 3,
                                        style: TextStyle(color: white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'caisse',
                                    label: Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Caisse de pérequation',
                                        maxLines: 3,
                                        style: TextStyle(color: white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      )
                      : EmptyMessage(),
                ],
              ),
    );
  }
}

class RapportMicMarketer extends DataGridSource {
  RapportMicMarketer({required List<TotalRapportMarketer> dataMarketrRapport}) {
    dataGridRows =
        dataMarketrRapport
            .map<DataGridRow>(
              (dataGridRow) => DataGridRow(
                cells: [
                  DataGridCell<String>(
                    columnName: 'marketer',
                    value: dataGridRow.marketer,
                  ),
                  DataGridCell<String>(
                    columnName: 'qte',
                    value: dataGridRow.qty,
                  ),
                  DataGridCell<String>(
                    columnName: 'ftbl',
                    value: dataGridRow.ftbl,
                  ),
                  DataGridCell<String>(
                    columnName: 'cbl_tp',
                    value: dataGridRow.cbl_tp,
                  ),
                  DataGridCell<String>(
                    columnName: 'dif',
                    value: dataGridRow.cbl_tdt,
                  ),
                  DataGridCell<String>(
                    columnName: 'caisse',
                    value: dataGridRow.caisse,
                  ),
                  // DataGridCell<String>(
                  //     columnName: 'bilan', value: dataGridRow.bilan),
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
              Text(
                dataGridCell.value.toString(),
                textScaleFactor: 0.9,
                style:
                    dataGridCell.columnName == 'dif'
                        ? TextStyle(
                          color:
                              int.parse(dataGridCell.value) < 0 ? red : green,
                        )
                        : null,
              ),
            );
          }).toList(),
    );
  }
}
