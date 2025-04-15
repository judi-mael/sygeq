class TotalModel {
  String blId;
  String compartimenId;
  String qty;
  String barreCode;
  String? creuxCharger;
  TotalModel({
    required this.blId,
    required this.compartimenId,
    required this.qty,
    required this.barreCode,
    this.creuxCharger,
  });
}
