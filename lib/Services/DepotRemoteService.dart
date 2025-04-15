// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/BonT.dart';
import 'package:sygeq/Models/DetailChargement.dart';
import 'package:sygeq/Models/TotalModel.dart';
import 'package:sygeq/Statistiques/MicStatProduit.dart';
import 'package:sygeq/main.dart';
import 'package:http/http.dart' as http;
import 'package:sygeq/ui/DefaultToas.dart';

class RemoteDepotService {
  static var client = http.Client();
  static String autorisation = "Bearer ${prefUserInfo['token']}";

  static Future allGetListeDepot_GplBouteille({
    int id = 0,
    String state = "",
  }) async {
    List<BonL> listBonLivraison = [];
    List list = [];
    var data = {'camion_id': id, 'statut': state};

    var response = await client.get(
      Uri.parse("${uRl}bls/depot_per_camion_bpl_bouteille/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBonLivraison = list.map((i) => BonL.fromJson(i)).toList();
      return listBonLivraison;
    } else  {
      var result = json.decode(response.body.toString());
      return toastError(result["message"]);
    }
  }

  static Future allGetListeDepot({int id = 0, String state = ""}) async {
    List<BonL> listBonLivraison = [];
    List list = [];
    var data = {'camion_id': id, 'statut': state};

    var response = await client.get(
      Uri.parse("${uRl}bls/depot_per_camion/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBonLivraison = list.map((i) => BonL.fromJson(i)).toList();
      return listBonLivraison;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future rejeterChagement(int id) async {
    try {
      var response = await client.get(
        Uri.parse("${uRl}bls/rejeter_chargement/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
      if (response.statusCode == 200) {
        return showToast(
          "Chargement BL annulé avec succès"
        );
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(
          result["message"],
        );
      }
    } catch (e) {
      showToastError("Une erreur s'est produite.\n Veuillez réessayer");
      // showToast("Une erreur s'est produite.\n Veuillez réessayer", Colors.red,
      //     Icon(Icons.error), Colors.white);
    }
  }

  static Future getDetailChargement(int id) async {
    List<DetailChargement> listDetailChargement = [];
    List list = [];
    try {
      var response = await client.get(
        Uri.parse("${uRl}bls/detail_chargement/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body.toString());
        list = result["data"] as List;
        listDetailChargement =
            list.map((i) => DetailChargement.fromJson(i)).toList();
        return listDetailChargement;
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(
          result["message"],
        );
      }
    } catch (e) {
      showToastError(
        "Une erreur s'est produite.\n Veuillez réessayer"
      );
    }
  }

  static Future<dynamic> modifierDetailChargement(
    String barrecode,
    String creu,
    int id,
  ) async {
    try {
      var response = await client.post(
        Uri.parse("${uRl}bls/modify_detail_chargement"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'detailUpdate': {
            'id': id,
            'creu': int.parse(creu),
            'barrecode': barrecode,
          },
        }),
        // encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        return showToast(
          "Informations modifié",
        );
        // return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(
            result["message"],
          );
        }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Une erreur s'est produite.\n Veuillez réessayer.");
    }
  }

  static Future<dynamic> chargerBlGplBouteille(List<int> id) async {
    try {
      var response = await client.post(
        Uri.parse("${uRl}bls/charger_gpl_bouteille"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'ids': id}),
        // encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        return showToast("BLs chargés avec succès");

        // return json.decode(response.body);
      } else {
        var result = json.decode(response.body);
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Une erreur s'est produite.\n Veuillez réessayer.");
    }
  }

  static Future updateBlDepot({
    int id = 0,
    String state = "",
    String commentaire = "",
  }) async {
    List<BonL> listBonLivraison = [];
    List list = [];

    var response = await client.patch(
      Uri.parse("${uRl}bls/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
      body: json.encode({"commentaire": "", "statut": state}),
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBonLivraison = list.map((i) => BonL.fromJson(i)).toList();
      return listBonLivraison;
    } else {
      var result = json.decode(response.body.toString());
      return showToastError(result['message']);
    }
  }

  static Future starDepotperProduct() async {
    List<StaProduit> listStart = [];
    List list = [];

    var response = await client.get(
      Uri.parse("${uRl}bilans/depot/quantities-per-products"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listStart = list.map((i) => StaProduit.fromJson(i)).toList();
      return listStart;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allOneDepot({required String depotId}) async {
    int id = int.parse(depotId);
    // try {
    var response = await client.get(
      Uri.parse("${uRl}depots/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());

      return result['data'];
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future<dynamic> depotCreatBC(List<TotalModel> list) async {
    try {
      var lidt = [];
      for (var element in list) {
        lidt.add({
          "dl_id": element.blId,
          "compartiment_id": element.compartimenId,
          "qty": element.qty,
          "barcode": element.barreCode,
          'creu_charger': element.creuxCharger,
        });
      }
      var response = await client.post(
        Uri.parse("${uRl}bls/finaliser/chargement"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'data': lidt}),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        var result = json.decode(response.body);
        return showToast('BL chargé avec succès');
        // return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result['message']);
      }
    } on SocketException {
      return toastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future depotGetListeBT() async {
    List<BonT> listBT = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse("${uRl}bts/btdepot"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBT = list.map((i) => BonT.fromJson(i)).toList();
      return listBT;
    }else{
      var result = json.decode(response.body.toString());
      return showToastError(result['message']);
    }
  }
}
