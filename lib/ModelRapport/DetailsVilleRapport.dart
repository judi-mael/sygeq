// To parse this JSON data, do
//
//     final detailsVilles = detailsVillesFromJson(jsonString);

import 'dart:convert';

DetailsVilles detailsVillesFromJson(String str) => DetailsVilles.fromJson(json.decode(str));

String detailsVillesToJson(DetailsVilles data) => json.encode(data.toJson());

class DetailsVilles {
    int id;
    int depotId;
    int villeId;
    int difficultee;
    int? distance;
    int prime;
    double tarifProduitsBlanc;
    double tarifGpl;
    int createdBy;
    int updatedBy;
    dynamic deletedBy;
    dynamic restoredBy;
    dynamic suspensionComment;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    DetailsVilles({
        required this.id,
        required this.depotId,
        required this.villeId,
        required this.difficultee,
        required this.distance,
        required this.prime,
        required this.tarifProduitsBlanc,
        required this.tarifGpl,
        required this.createdBy,
        required this.updatedBy,
        this.deletedBy,
        this.restoredBy,
        this.suspensionComment,
        required this.createdAt,
        required this.updatedAt,
        this.deletedAt,
    });

    factory DetailsVilles.fromJson(Map<String, dynamic> json) => DetailsVilles(
        id: json["id"]??0,
        depotId: json["depot_id"]??0,
        villeId: json["ville_id"]??0,
        difficultee: json["difficultee"]??0,
        distance: json["distance"],
        prime: json["prime"],
        tarifProduitsBlanc: json["tarif_produits_blanc"]?.toDouble(),
        tarifGpl: json["tarif_gpl"]?.toDouble(),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        deletedBy: json["deletedBy"],
        restoredBy: json["restoredBy"],
        suspensionComment: json["suspensionComment"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "depot_id": depotId,
        "ville_id": villeId,
        "difficultee": difficultee,
        "distance": distance,
        "prime": prime,
        "tarif_produits_blanc": tarifProduitsBlanc,
        "tarif_gpl": tarifGpl,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "deletedBy": deletedBy,
        "restoredBy": restoredBy,
        "suspensionComment": suspensionComment,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
    };
}
