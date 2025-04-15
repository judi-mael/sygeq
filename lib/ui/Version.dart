// import 'package:apk_installer/apk_installer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionApp extends StatefulWidget {
  const VersionApp({super.key});

  @override
  State<VersionApp> createState() => _VersionAppState();
}

class _VersionAppState extends State<VersionApp> {
  downloadAndInstallApk(String apkUrl) async {
    try {
      final dio = Dio();
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/new_version.apk';
      await dio.download(apkUrl, filePath);
      // await ApkInstaller.installApk(filePath: filePath);
    } catch (e) {
      showToast(
        "Une erreur s'est produite:  $e",
        
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // heightFactor: 3,
        // widthFactor: 0.8,
        child: Container(
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          color: blue,
          child: TextButton.icon(
            onPressed: () async {
              // await downloadAndInstallApk(
              // 'https://mic.bourjon.com/apk/SyGeQ.apk');
              launchUrl(versionUrl);
            },
            label: Text(
              "Mettre à jour",
              style: GoogleFonts.montserrat(
                color: white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            icon: Icon(Icons.upgrade_outlined, color: white, size: 35),
          ),
        ),
      ),
    );
  }
}
