import 'package:flutter/material.dart';

AppBar getAppBar() {
  return AppBar(
    backgroundColor: Colors.green,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Image.asset(
              "assets/Images/logo_gov.png",
              // width: MediaQuery.of(context).size.width / 5,
            ),
          ),
          Container(
            child: Text(
              "Ministère \n de l'Industrie \n et du Commerce",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blueAccent,
            ),
            // child: IconButton(
            //     onPressed: (() {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: ((context) => ScannerQR())));
            //     }),
            //     icon: Icon(
            //       Icons.add,
            //       color: Colors.white,
            //     )),
          )
        ],
      ),
    ),
  );
}
