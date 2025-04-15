class ModelCreateMultiBL {
  ModelCreateMultiBL(
    this.stationId,
    this.depotId,
    this.camionId,
    this.detailBl,
  );
  final int stationId;
  final int depotId;
  final int camionId;
  final List<DetailBl> detailBl;
}

class DetailBl {
  DetailBl(
    this.produitId,
    this.qtte,
  );
  final int produitId;
  final int qtte;
}
