// To parse this JSON data, do
//
//     final stockage = stockageFromJson(jsonString);

import 'dart:convert';

Stockage stockageFromJson(String str) => Stockage.fromJson(json.decode(str));

String stockageToJson(Stockage data) => json.encode(data.toJson());

class Stockage {
    Stockage({
        required this.id,
        required this.numeroDouanier,
        required this.agrement,
        required this.dateVigueur,
        required this.dateExpiration,
        required this.adresse,
        required this.userId,
        required this.createdAt,
        required this.createdBy,
        required this.updatedAt,
        required this.updatedBy,
        required this.deletedAt,
    });

    int id;
    String numeroDouanier;
    String agrement;
    String dateVigueur;
    String dateExpiration;
    String adresse;
    int userId;
    String createdAt;
    int createdBy;
    String updatedAt;
    int updatedBy;
    String deletedAt;

    factory Stockage.fromJson(Map<String, dynamic> json) => Stockage(
        id: json["id"]??0,
        numeroDouanier: json["numeroDouanier"]??'',
        agrement: json["agrement"]??'',
        dateVigueur: json["dateVigueur"]??'',
        dateExpiration: json["dateExpiration"]??'',
        adresse: json["adresse"]??'',
        userId: json["user_id"]??0,
        createdAt: json["createdAt"]??'',
        createdBy: json["createdBy"]??0,
        updatedAt: json["updatedAt"]??'',
        updatedBy: json["updatedBy"]??0,
        deletedAt: json["deletedAt"]??'',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "numeroDouanier": numeroDouanier,
        "agrement": agrement,
        "dateVigueur": dateVigueur,
        "dateExpiration": dateExpiration,
        "adresse": adresse,
        "user_id": userId,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updatedAt": updatedAt,
        "updatedBy": updatedBy,
        "deletedAt": deletedAt,
    };
}
