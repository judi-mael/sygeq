// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sygeq/Models/TauxForfait.dart';
import 'package:sygeq/Models/Tauxtks.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Statistiques/StatistiqueMarketer.dart';
import 'package:sygeq/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Dispatcheur/HomeMarketer.dart';

class DashBordMarketer extends StatefulWidget {
  const DashBordMarketer({super.key});

  @override
  State<DashBordMarketer> createState() => _DashBordMarketerState();
}

class _DashBordMarketerState extends State<DashBordMarketer> {
  List<Tauxtks> ttkActive = [];
  List<TauxForfait> tfsActive = [];
  List<int> listDate = [];
  int lastDate = 2100;
  String ttk = '0';
  String tfs = '0';
  int _year = DateTime.now().year;
  List<StatistiqueMarketer> liststatMark = [];
  getListDate() async {
    for (int i = 2023; lastDate > i; i++) {
      setState(() {
        listDate.add(i);
      });
    }
  }

  getMicStat() async {
    var data = await MarketerRemoteService.statistiqueMarketer(_year);
    // if (!mounted) return null;
    setState(() {
      liststatMark = data;
    });
    setState(() {});
    return liststatMark;
  }

  getTtkActive() async {
    var data = await RemoteServices.getTtkActive();
    setState(() {
      ttkActive = data;
    });
    if (ttkActive.length > 0) {
      setState(() {
        ttk = ttkActive[0].valeurtk;
      });
    }
    return data;
  }

  getTfsActive() async {
    var data = await RemoteServices.getTfsActive();
    setState(() {
      tfsActive = data;
    });
    if (tfsActive.length > 0) {
      setState(() {
        tfs = tfsActive[0].tauxforfait;
      });
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    getTtkActive();
    getTfsActive();
    getListDate();
    getMicStat();
  }

  @override
  void dispose() {
    liststatMark.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        centerTitle: true,
        title: Text(
          'Tableau de bord',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
      ),
      // backgroundColor: gryClaie,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: Container(
                height:
                    _size.height < _size.width
                        ? _size.width / 7
                        : _size.height / 8,
                child: Wrap(
                  // shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  // dragStartBehavior: DragStartBehavior.start,
                  children: [
                    Card(
                      color: defautlCardColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            width:
                                _size.height < _size.width
                                    ? _size.width / 2.5
                                    : _size.height / 4,
                            child: Column(
                              // direction: Axis.vertical,
                              children: [
                                Text(
                                  "Ttk encours",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textScaleFactor: 1,
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.swap_vert, color: blue),
                                  label: Text(
                                    ttk,
                                    textScaleFactor: 1.2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: defautlCardColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // color: blue,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            width:
                                _size.height < _size.width
                                    ? _size.width / 2.5
                                    : _size.height / 4,
                            child: Column(
                              children: [
                                Text(
                                  "Tf encours",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textScaleFactor: 1,
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.swap_horiz, color: blue),
                                  label: Text(
                                    "$tfs f/L",
                                    textScaleFactor: 1.2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: defautlCardColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // color: blue,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            width:
                                _size.height < _size.width
                                    ? _size.width / 2.5
                                    : _size.height / 4,
                            child: Column(
                              children: [
                                Text(
                                  "Stations",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textScaleFactor: 1,
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.route, color: blue),
                                  label: Text(
                                    "${listMarkStation.length}",
                                    textScaleFactor: 1.2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
              padding: EdgeInsets.all(8),
              child: Container(
                // width: _size.width > _size.height
                //     ? _size.width / 3
                //     : _size.height / 3,
                decoration: BoxDecoration(
                  color: Color.fromARGB(31, 168, 191, 224),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Taux TK encours",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textScaleFactor: 1,
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.swap_vert, color: blue),
                                  label: Text(
                                    ttk,
                                    textScaleFactor: 1.2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Taux forfait encours",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textScaleFactor: 1,
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.swap_vert, color: blue),
                                  label: Text(
                                    tfs,
                                    textScaleFactor: 1.2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Container(
                // width: _size.height < _size.width ? _size.width : _size.height / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(249, 213, 229, 241),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                      child: Container(
                        width:
                            _size.height > _size.width
                                ? _size.width / 3
                                : _size.width / 5,
                        child: DropdownSearch<int>(
                          selectedItem: _year,
                          // showSelectedItems: true,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              label: Text(
                                "Année",
                                softWrap: true,
                                textScaleFactor: 1,
                                overflow: TextOverflow.ellipsis,
                                style: styleG,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          popupProps: PopupProps.menu(),
                          items:
                              listDate.isEmpty
                                  ? []
                                  : listDate.map((e) => e).toList(),
                          onChanged: (value) {
                            setState(() {
                              _year = value!;
                              getMicStat();
                            });
                          },
                          // validator: (value) =>
                          //     value == null ? 'Choisissez le marketer' : null,
                          // onChanged: (String newValue) {
                          //   setState(() {

                          //   });
                          // },
                        ),
                      ),
                    ),
                    SfCartesianChart(
                      onMarkerRender: (MarkerRenderArgs markerargs) {},
                      plotAreaBorderWidth: 0,
                      legend: Legend(
                        title: LegendTitle(
                          alignment: ChartAlignment.near,
                          text: 'Statistique par produit',
                          textStyle: TextStyle(backgroundColor: Colors.white),
                        ),
                        alignment: ChartAlignment.center,
                        textStyle: TextStyle(color: blue),
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                      palette: [
                        Color.fromRGBO(75, 135, 185, 1),
                        Color.fromRGBO(192, 108, 132, 1),
                        Color.fromRGBO(246, 114, 128, 1),
                        Color.fromRGBO(248, 177, 149, 1),
                        Color.fromRGBO(116, 180, 155, 1),
                        Color.fromRGBO(0, 168, 181, 1),
                        Color.fromRGBO(73, 76, 162, 1),
                        Color.fromRGBO(255, 205, 96, 1),
                        Color.fromRGBO(255, 240, 219, 1),
                        Color.fromRGBO(238, 238, 238, 1),
                      ],
                      primaryXAxis: CategoryAxis(),
                      series: [
                        if (liststatMark.length > 0) ...[
                          for (
                            int g = 0;
                            g < liststatMark[0].state.length;
                            g++
                          ) ...[
                            // for (var ele in liststatMark[i].state) ...[
                            StackedLineSeries<StatistiqueMarketer, String>(
                              groupName: liststatMark[0].state[g].produit,
                              isVisibleInLegend: true,
                              dataSource: liststatMark,
                              xValueMapper:
                                  (StatistiqueMarketer sm, _) => sm.month,
                              yValueMapper:
                                  (StatistiqueMarketer sm, _) =>
                                      sm.state[g].total,
                              name: liststatMark[0].state[g].produit,
                            ),
                          ],
                        ],
                      ],
                      // series: <ChartSeries>[
                      //   if (liststatMark.length > 0) ...[
                      //     // for (int i = 0; i < liststatMark.length; i++) ...[
                      //     for (
                      //       int g = 0;
                      //       g < liststatMark[0].state.length;
                      //       g++
                      //     ) ...[
                      //       // for (var ele in liststatMark[i].state) ...[
                      //       StackedLineSeries<StatistiqueMarketer, String>(
                      //         groupName: liststatMark[0].state[g].produit,
                      //         isVisibleInLegend: true,
                      //         dataSource: liststatMark,
                      //         xValueMapper:
                      //             (StatistiqueMarketer sm, _) => sm.month,
                      //         yValueMapper:
                      //             (StatistiqueMarketer sm, _) =>
                      //                 sm.state[g].total,
                      //         name: liststatMark[0].state[g].produit,
                      //       ),
                      //     ],
                      //     // ]
                      //     // ]
                      //   ],
                      // ],
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
