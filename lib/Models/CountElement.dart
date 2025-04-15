// To parse this JSON data, do
//
//     final countElement = countElementFromJson(jsonString);


import 'dart:convert';

CountElement countElementFromJson(String str) => CountElement.fromJson(json.decode(str));

String countElementToJson(CountElement data) => json.encode(data.toJson());

class CountElement {
    int marketer;
    int station;
    int transporteur;
    int depot;
    int b2b;
    int camion;

    CountElement({
        required this.marketer,
        required this.station,
        required this.transporteur,
        required this.depot,
        required this.b2b,
        required this.camion,
    });

    factory CountElement.fromJson(Map<String, dynamic> json) => CountElement(
        marketer: json["marketer"]??0,
        station: json["station"]??0,
        transporteur: json["transporteur"]??0,
        depot: json["depot"]??0,
        b2b: json["b2b"]??0,
        camion: json["camion"]??0,
    );

    Map<String, dynamic> toJson() => {
        "marketer": marketer,
        "station": station,
        "transporteur": transporteur,
        "depot": depot,
        "b2b": b2b,
        "camion": camion,
    };
}
