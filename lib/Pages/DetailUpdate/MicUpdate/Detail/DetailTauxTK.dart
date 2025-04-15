// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/UpdateTauxTK.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailTauxtK extends StatefulWidget {
  var data;
  DetailTauxtK({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailTauxtK> createState() => _DetailTauxtKState();
}

class _DetailTauxtKState extends State<DetailTauxtK> {
  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'ttks');
    return data;
  }

  actionOnTheEditTauxTk(var data) {
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
              child: UpdateTauxTK(data: data),
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
        padding: EdgeInsets.only(
          top: 10,
          // right: 20,
          // left: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    widget.data['ref'],
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
                      actionOnTheEditTauxTk(widget.data);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => UpdateTauxTK(
                      //       data: widget.data,
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      "Valeur du taux TK  : ",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.data['valeurTK'] + " %",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      "Référence  : ",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.data['ref'],
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      "Mise en application le",
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
          ],
        ),
      ),
    );
  }
}
