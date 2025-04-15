// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_local_variable

import 'package:flutter/material.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Statistiques/StatistiqueMarketer.dart';
import 'package:sygeq/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBordDispatcheur extends StatefulWidget {
  const DashBordDispatcheur({super.key});

  @override
  State<DashBordDispatcheur> createState() => _DashBordDispatcheurState();
}

class _DashBordDispatcheurState extends State<DashBordDispatcheur> {
  List<StatistiqueMarketer> liststatMark = [];
  getMicStat() async {
    var data = await MarketerRemoteService.statistiqueMarketer(2022);
    if (!mounted) return null;
    setState(() {
      liststatMark = data;
    });
    return liststatMark;
  }

  // getserie(){
  //   return
  // }
  serie(List<StatistiqueMarketer> listMarkStat) {
    List<SplineSeries<StatistiqueMarketer, String>> tab = [];
    String test = '';
    for (int y = 0; listMarkStat.length > y; y++) {
      for (int h = 0; listMarkStat[y].state.length > h; h++) {
        tab.add(
          SplineSeries<StatistiqueMarketer, String>(
            name: "moi",
            markerSettings: const MarkerSettings(isVisible: true),
            dataSource: listMarkStat,
            xValueMapper:
                (StatistiqueMarketer data, _) => listMarkStat[y].month,
            yValueMapper:
                (StatistiqueMarketer data, _) => listMarkStat[y].state[h].total,
          ),
        );
      }
    }

    return tab;
  }

  @override
  void initState() {
    super.initState();
    getMicStat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        title: Text(
          'Tableau de bord',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
      ),
      backgroundColor: gryClaie,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, right: 10, left: 10),
              child: Text("Choix de l'année"),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Card(
                  elevation: 5,
                  child: SfCartesianChart(
                    title: ChartTitle(text: "Quantité par produit"),
                    legend: Legend(isVisible: true),
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelPlacement: LabelPlacement.onTicks,
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}',
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      majorGridLines: const MajorGridLines(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      minimum: 0,
                      maximum: 100000,
                      interval: 100000 / 5,
                    ),
                    series: serie(liststatMark),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
