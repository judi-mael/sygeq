// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/UpdateVille.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailVille extends StatefulWidget {
  var data;
  DetailVille({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailVille> createState() => _DetailVilleState();
}

class _DetailVilleState extends State<DetailVille> {
  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'villes');
    return data;
  }

  actionOnTheEditVille(var data) {
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
            child: Container(child: UpdateVille(data: data)),
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
        padding: EdgeInsets.only(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data['nom'],
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.edit, color: green),
                  //   onPressed: () {
                  //     actionOnTheEditVille(widget.data);
                      
                  //   },
                  // ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ville de  : ",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: styleG,
                  ),
                  Text(
                    widget.data['nom'],
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: styleG,
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 15,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Prime  : ",
            //         softWrap: true,
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //         style: styleG,
            //       ),
            //       Text(
            //         widget.data['prime'],
            //         softWrap: true,
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //         style: styleG,
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 15,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Département : ",
            //         softWrap: true,
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //         style: styleG,
            //       ),
            //       Text(
            //         widget.data['departement'],
            //         softWrap: true,
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //         style: styleG,
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 10,
            //   ),
            //   child: Card(
            //     child: Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Flexible(
            //             flex: 2,
            //             child: Text(
            //               "difficulté d'accèss : ",
            //               softWrap: true,
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //               style: styleG,
            //             ),
            //           ),
            //           Flexible(
            //             flex: 2,
            //             child: Text(
            //               "${widget.data['difficult']}",
            //               softWrap: true,
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //               style: styleG,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
