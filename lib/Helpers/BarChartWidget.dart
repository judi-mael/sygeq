// // ignore_for_file: prefer_const_constructors

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:sygeq/Helpers/Bar_Data.dart';
// import 'package:sygeq/main.dart';

// class BarChartWidget extends StatelessWidget {
//   const BarChartWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => BarChart(
//         BarChartData(
//           backgroundColor: Color.fromARGB(170, 3, 2, 43),
//           alignment: BarChartAlignment.center,
//           maxY: 50,
//           // minY: 0,
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//                 // sideTitles: SideTitles(
//                 //   showTitles: true,
//                 //   getTitlesWidget: ((value, meta) =>return ;),
//                 // ),
//                 ),
//             leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           ),
//           groupsSpace: 12,
//           barTouchData: BarTouchData(enabled: true),
//           gridData: FlGridData(show: false),
//           barGroups: BarData.barData
//               .map((data) => BarChartGroupData(x: data.id, barRods: [
//                     BarChartRodData(
//                         toY: data.y,
//                         color: data.color,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(6),
//                             topRight: Radius.circular(6)))
//                   ]))
//               .toList(),
//         ),
//       );
// }
