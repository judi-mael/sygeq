// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/MNotifications.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class MesNotifications extends StatefulWidget {
  const MesNotifications({super.key});

  @override
  State<MesNotifications> createState() => _MesNotificationsState();
}

class _MesNotificationsState extends State<MesNotifications> {
  List<MNotification>? listMesNotifications = [];
  getMesNotification() async {
    var data = await RemoteServices.allGetListeNotifications();
    if (!mounted) return null;

    setState(() {
      listMesNotifications = data;
    });
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getMesNotification);
  }

  @override
  void initState() {
    getMesNotification();
    super.initState();
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refresh,
      child: Column(
        children: [
          HeaderMic(),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Text(
              "Mes notifications",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: styleG,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listMesNotifications!.length,
                itemBuilder: (context, int index) {
                  return Dismissible(
                    // background: Container(
                    //   color: red,
                    //   child: Icon(
                    //     Icons.delete,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    key: ValueKey<int>(index),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        listMesNotifications!.removeAt(index);
                      });
                    },

                    child: Card(
                      color:
                          listMesNotifications![index].readState == 1
                              ? null
                              : tbordColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listMesNotifications![index].label,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              listMesNotifications![index].description,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: blue,
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy à h:mm').format(
                                DateTime.parse(
                                  listMesNotifications![index].createdAt,
                                ),
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: blue,
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ],
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
    );
  }
}
