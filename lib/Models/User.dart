// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.type,
    required this.etat,
    required this.marketerId,
    required this.depotId,
    required this.transporteurId,
    required this.stationId,
    required this.adresse,
    required this.image,
    // required this.remenberToken,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String name;
  String username;
  String email;
  String role;
  String type;
  int etat;
  int marketerId;
  int depotId;
  int transporteurId;
  int stationId;
  String adresse;
  String image;
  // String etat;
  // String remenberToken;
  // String createdAt;
  // String createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        role: json["role"] ?? "",
        type: json["type"] ?? "",
        etat: json["etat"] ?? 0,
        marketerId: json["marketer_id"] ?? 0,
        depotId: json["depot_id"] ?? 0,
        transporteurId: json["transporteur_id"] ?? 0,
        stationId: json["station_id"] ?? 0,
        adresse: json["adresse"] ?? "",
        image: json["image"] ?? "",
        // etat: json["etat"],
        // remenberToken: json["remenber_token"],
        // createdAt: json["createdAt"] ?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"] ?? "",
        // updatedBy: json["updated_by"] ,
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "role": role,
        "type": type,
        "marketer_id": marketerId,
        "depot_id": depotId,
        "transporteur_id": transporteurId,
        "station_id": stationId,
        "adresse": adresse,
        "image": image,
        "etat": etat,
        // "remenber_token": remenberToken,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
