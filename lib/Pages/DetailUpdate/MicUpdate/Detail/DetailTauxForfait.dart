// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/UpdateTauxForfait.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailTauxForfait extends StatefulWidget {
  var data;
  DetailTauxForfait({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailTauxForfait> createState() => _DetailTauxForfaitState();
}

class _DetailTauxForfaitState extends State<DetailTauxForfait> {
  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'tfs');
    return data;
  }

  actionOnTheEditTauxForfait(var data) {
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
              child: UpdateTauxForfait(tauxForfaitL: data),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    widget.data['distance'] + " Km",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: styleG,
                  ),
                ),
                Flexible(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      actionOnTheEditTauxForfait(widget.data);
                     
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Taux forfait : ",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${widget.data['tauxForfait']} %",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Application : ",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.data['dateStart']))} au ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.data['dateEnd']))}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
