// To parse this JSON data, do
//
//     final center = centerFromJson(jsonString);

import 'dart:convert';

Center centerFromJson(String str) => Center.fromJson(json.decode(str));

String centerToJson(Center data) => json.encode(data.toJson());

class Center {
  Center({
    required this.longitude,
    required this.latitude,
  });

  double longitude;
  double latitude;

  factory Center.fromJson(Map<String, dynamic> json) => Center(
        longitude: json["longitude"] ?? 0.0,
        latitude: json["latitude"] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}
