class OverviewModel {
  final String? itemName,
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
    : itemName = json['itemName'] as String?,
      entpName = json['entpName'] as String?,
      itemSeq = json['itemSeq'] as String?,
      efcyQesitm = json['efcyQesitm'] as String?,
      useMethodQesitm = json['useMethodQesitm'] as String?,
      atpnWarnQesitm = json['atpnWarnQesitm'] as String?,
      atpnQesitm = json['atpnQesitm'] as String?,
      intrcQesitm = json['intrcQesitm'] as String?,
      seQesitm = json['seQesitm'] as String?,
      depositMethodQesitm = json['depositMethodQesitm'] as String?;
}
