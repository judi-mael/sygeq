// ignore_for_file: unused_element, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, unused_field, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Pages/Depot/HomeDepot.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Pages/Station/HomeStation.dart';
import 'package:sygeq/Services/DeviceInfo.dart';
import 'package:sygeq/Services/Id_info.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/ui/LoadingPage.dart';
import 'package:sygeq/ui/Version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

// PackageInfo packageInfo = PackageInfo(
//   appName: 'Unknown',
//   packageName: 'Unknown',
//   version: 'Unknown',
//   buildNumber: 'Unknown',
//   buildSignature: 'Unknown',
//   installerStore: 'Unknown',
// );
final navigatorKey = GlobalKey<NavigatorState>();
clearAllList() async {
  listMarkStation.clear();
  listMarkTransporteur.clear();
  listMarkTransporteurC.clear();
  listMarkTransporteurNC.clear();
  
  listMicDepot.clear();
  listMicMarketer.clear();
  listMicTransporteur.clear();
  listMicVehicul.clear();
  listMicVille.clear();
  listOneStation.clear();
  listSsatStation.clear();
  listStation.clear();
}

Uri versionUrl = Uri.parse('https://mic.bourjon.com/apk/SyGeQ.apk');
String autorisation = "";
bool deconnexionState = false;
Color green = Color(0xFF008850);
Color white = Colors.white;
Color yello = Color(0xFFFCD20F);
Color blue = Color(0xFF0A3764);
Color red = Color(0xFFE90929);
Color tbordColor = Colors.white;
Color defautlCardColors = Color(0xFFE5F3ED);
Color gryfoncee = Color(0xFFe5e5e5);
Color cardColorred = Color.fromARGB(255, 235, 97, 117);
TextStyle styleG = GoogleFonts.montserrat(
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
TextStyle btnTxtCOlor = GoogleFonts.montserrat(
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
TextStyle styleAppBar = GoogleFonts.montserrat(
  fontWeight: FontWeight.bold,
  color: blue,
);
// TextStyle styleG = GoogleFonts.got;
TextStyle styleH = GoogleFonts.montserrat(color: Colors.black);
TextStyle stylecolorText = GoogleFonts.montserrat(color: Colors.white);
TextStyle styleDrawer = GoogleFonts.montserrat(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
List<Driver> listMicTransporteur = [];
Color gryClaie = Color(0xFF9FADA4);
Color gry = Color(0xFF555555);
double? positionLat;
double? positionLog;
bool? firstLaunch;
Map _source = {ConnectivityResult.none: false};
List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
final Connectivity _connectivity = Connectivity();
late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
bool hasInternet = true;
late FToast fToast;

showToast(String message) {
  Widget toast = Container(
    constraints: BoxConstraints(maxHeight: 150, maxWidth: double.infinity),
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: green,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check,color: white,),
        SizedBox(width: 12.0),
        Flexible(
          flex: 7,
          child: Text(
            message,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: GoogleFonts.montserrat(color: white),
          ),
        ),
      ],
    ),
  );
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 4),
  );
}
showToastError(String message) {
  Widget toast = Container(
    constraints: BoxConstraints(maxHeight: 150, maxWidth: double.infinity),
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: red,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error,color: white,),
        SizedBox(width: 12.0),
        Flexible(
          flex: 7,
          child: Text(
            message,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: GoogleFonts.montserrat(color: white),
          ),
        ),
      ],
    ),
  );
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 4),
  );
}

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Map<String, dynamic> prefUserInfo = {};
var uRl = "https://micapi.labourd.tech/";
// var uRl = "https://api.bourjon.com/";
void main() async {

  HttpOverrides.global = MyHttpoverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

String localisation = "";
// String mlat = "";
// String mlong = "";
String phones = "";
String ip = "";
Future<void> getPrefUserInfo() async {
  SharedPreferences prefsFirstLaunch = await SharedPreferences.getInstance();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefUserInfo = {
    'idUser': prefs.getInt('idUser') ?? 0,
    'transporteurId': prefs.getInt('transporteurId') ?? 0,
    'stationId': prefs.getInt('stationId') ?? 0,
    'b2bId': prefs.getInt('b2bId') ?? 0,
    'marketerId': prefs.getInt('marketerId') ?? 0,
    'depotId': prefs.getInt('depotId') ?? 0,
    'userName': prefs.getString('username') ?? "",
    'userImage': prefs.getString('userImage') ?? "",
    'name': prefs.getString('name') ?? "",
    'email': prefs.getString('email') ?? "",
    'type': prefs.getString('type') ?? "",
    'role': prefs.getString('role') ?? "",
    'password': prefs.getString('password') ?? "",
    'passChanged': prefs.getInt('passChanged') ?? "",
    'token': prefs.getString('token') ?? "",
  };
}

Future<void> GetAddressFromLatLong(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];

    localisation =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}, ${place.subThoroughfare}, ${position.latitude.toString()};${position.longitude.toString()}";
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gestion péréquation",
      theme: ThemeData(primaryColor: blue, primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String string = '';
  void _getCurrentPosition() async {
    //Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (!mounted) return null;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position currentPosotion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        GetAddressFromLatLong(currentPosotion);
        localisation = "$currentPosotion";
        positionLat = currentPosotion.latitude;
        positionLog = currentPosotion.longitude;
      });
    }
  }

  
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }
  String _version = '4';
  String newVersion = '';
  Future init() async {
    final ipAddress = await IpInfo.getIpAddress();
    final phone = await DeviceInfo.getPhoneInfo();

    if (!mounted) return;
    setState(() {
      ip = ipAddress!;
      phones = phone;
    });
  }

  bool _loading = true;
  getversion() async {
    var data = await RemoteServices.newVersion();
    setState(() {
      newVersion = data;
    });
    Future.delayed(Duration(seconds: 5));
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getversion();
    fToast = FToast();
    fToast.init(context);
    init();
    _getCurrentPosition();
    getPrefUserInfo();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  _navigate() async {
    SharedPreferences prefsFirstLaunch = await SharedPreferences.getInstance();
    bool? firstLaunch = prefsFirstLaunch.getBool('firstLaunch');
    if (firstLaunch != true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      if (prefUserInfo['type'] == "MIC") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: ((context) => HomeMic())),
        );
      } else if (prefUserInfo['type'] == "Marketer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: ((context) => HomeMarketer())),
        );
      } else if (prefUserInfo['type'] == "Station") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: ((context) => HomeStation())),
        );
      } else if (prefUserInfo['type'] == "Depot") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: ((context) => HomeDepot())),
        );
      } else if (prefUserInfo['type'] == "DPB") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: ((context) => HomeMarketer())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading == true
        ? LoadingPage()
        : newVersion == _version
        ? Login(getposition: _getCurrentPosition)
        : VersionApp();
  }
}
