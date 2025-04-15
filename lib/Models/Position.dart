// To parse this JSON data, do
//
//     final position = positionFromJson(jsonString);

import 'dart:convert';

Positions positionsFromJson(String str) => Positions.fromJson(json.decode(str));

String positionsToJson(Positions data) => json.encode(data.toJson());

class Positions {
    Positions({
        required this.latitude,
        required this.longitude,
    });

    double latitude;
    double longitude;

    factory Positions.fromJson(Map<String, dynamic> json) => Positions(
        latitude: json["latitude"]??0.0,
        longitude: json["longitude"]??0.0,
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}
