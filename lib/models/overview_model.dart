class OverviewModel {
  final String itemName,
      entpName,
      itemSeq,
      efcyQesitm,
      useMethodQesitm,
      atpnWarnQesitm,
      atpnQesitm,
      intrcQesitm,
      seQesitm,
      depositMethodQesitm;

  OverviewModel.fromJson(Map<String, dynamic> json)
    : itemName = json['itemName'],
      entpName = json['entpName'],
      itemSeq = json['itemSeq'],
      efcyQesitm = json['efcyQesitm'],
      useMethodQesitm = json['useMethodQesitm'],
      atpnWarnQesitm = json['atpnWarnQesitm'],
      atpnQesitm = json['atpnQesitm'],
      intrcQesitm = json['intrcQesitm'],
      seQesitm = json['seQesitm'],
      depositMethodQesitm = json['depositMethodQesitm'];
}
