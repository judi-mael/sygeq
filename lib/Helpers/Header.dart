// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HeaderMic extends StatelessWidget {
  const HeaderMic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Padding(
      // padding: EdgeInsets.only(
      //   top: 15,
      // ),
      padding: EdgeInsets.only(),

      // child: Container(
      //   child: Column(
      //     children: [
      //       Row(
      //         textDirection: TextDirection.ltr,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Expanded(
      //             child: Text(
      //               "Ministère de l'Industrie et du Commerce",
      //               style: TextStyle(fontSize: 20),
      //               softWrap: true,
      //               overflow: TextOverflow.ellipsis,
      //               textAlign: TextAlign.center,
      //               maxLines: 3,
      //             ),
      //           ),
      //         ],
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(top: 5),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Flexible(
      //               flex: 2,
      //               child: Container(
      //                 height: _size.height < _size.width
      //                     ? MediaQuery.of(context).size.width / 150
      //                     : MediaQuery.of(context).size.height / 150,
      //                 width: _size.height < _size.width
      //                     ? MediaQuery.of(context).size.width / 5
      //                     : MediaQuery.of(context).size.height / 10,
      //                 // height: 5,
      //                 // width: 40,
      //                 color: green,
      //               ),
      //             ),
      //             Flexible(
      //               flex: 2,
      //               child: Container(
      //                 height: _size.height < _size.width
      //                     ? MediaQuery.of(context).size.width / 150
      //                     : MediaQuery.of(context).size.height / 150,
      //                 width: _size.height < _size.width
      //                     ? MediaQuery.of(context).size.width / 5
      //                     : MediaQuery.of(context).size.height / 10,
      //                 color: yello,
      //               ),
      //             ),
      //             Flexible(
      //               flex: 2,
      //               child: Container(
      //                 height: _size.height < _size.width
      //                     ? MediaQuery.of(context).size.width / 150
      //                     : MediaQuery.of(context).size.height / 150,
      //                 width: _size.height < _size.width
      //                     ? MediaQuery.of(context).size.width / 5
      //                     : MediaQuery.of(context).size.height / 10,
      //                 color: red,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
