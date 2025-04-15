import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sygeq/main.dart';

Center animationLoadingData() {
  return Center(
    child: LoadingAnimationWidget.flickr(
      leftDotColor: yello,
      rightDotColor: red,
      size: 50,
    ),
  );
}

animateScannageQrcode() {
  return LoadingAnimationWidget.hexagonDots(color: blue, size: 50);
}

animateLoadinPage() {
  return LoadingAnimationWidget.hexagonDots(color: green, size: 70);
}

veuillezPatienter(String text) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: blue),
        ),
        SizedBox(width: 15),
        Flexible(
          flex: 4,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
            textScaleFactor: 1.2,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              color: blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

deconnexionEncours() {
  return Scaffold(
    body: Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: blue),
            ),
            SizedBox(width: 15),
            Flexible(
              flex: 4,
              child: Text(
                "Déconnexion en cours",
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                textScaleFactor: 1.2,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: red,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
