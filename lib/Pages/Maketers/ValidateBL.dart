// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/main.dart';

class MarketerValidateBL extends StatefulWidget {
  const MarketerValidateBL({Key? key}) : super(key: key);

  @override
  State<MarketerValidateBL> createState() => _MarketerValidateBLState();
}

class _MarketerValidateBLState extends State<MarketerValidateBL> {
  List<BonL> nbon = [];
  getbl() async {
    var data = await MarketerRemoteService.allGetListeBL();

    setState(() {
      nbon = data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getbl();
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getbl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        title: Text(
          "Approbation de BL",
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        key: refreshKey,
        child: SafeArea(
          child: Column(
            children: [
              HeaderMic(),
              Padding(
                padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                child: Flexible(
                  flex: 3,
                  child: Text(
                    "Liste des BL à relâché",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              if (nbon.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: ListView.builder(
                      itemCount: nbon.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: ((context, index) {
                        if (nbon[index].statut == "Ouverte")
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        nbon[index].numeroBl,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        nbon[index].numeroBl,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        return Container();
                      }),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
