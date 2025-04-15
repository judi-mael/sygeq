// To parse this JSON data, do
//
//     final personalAccessTokens = personalAccessTokensFromJson(jsonString);

import 'dart:convert';

PersonalAccessTokens personalAccessTokensFromJson(String str) =>
    PersonalAccessTokens.fromJson(json.decode(str));

String personalAccessTokensToJson(PersonalAccessTokens data) =>
    json.encode(data.toJson());

class PersonalAccessTokens {
  PersonalAccessTokens({
    required this.id,
    required this.tokenableType,
    required this.tokenableId,
    required this.name,
    required this.token,
    required this.abilities,
    required this.lastUsedAt,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String tokenableType;
  int tokenableId;
  String name;
  String token;
  String abilities;
  String lastUsedAt;
  String createdAt;
  int createdBy;
  String updatedAt;
  int updatedBy;
  String deletedAt;

  factory PersonalAccessTokens.fromJson(Map<String, dynamic> json) =>
      PersonalAccessTokens(
        id: json["id"],
        tokenableType: json["tokenable_type"],
        tokenableId: json["tokenable_id"],
        name: json["name"],
        token: json["token"],
        abilities: json["abilities"],
        lastUsedAt: json["last_used_at"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        updatedAt: json["updatedAt"],
        updatedBy: json["updatedBy"],
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tokenable_type": tokenableType,
        "tokenable_id": tokenableId,
        "name": name,
        "token": token,
        "abilities": abilities,
        "last_used_at": lastUsedAt,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updatedAt": updatedAt,
        "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
