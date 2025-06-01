import 'package:project_medi/page/app/utils/html_cleaner.dart';

class OverviewModel {
  final String itemName;
  final String entpName;
  final String etcOtcName;
  final String eeDocData;
  final String udDocData;
  final String nbDocDataStorage;
  final String nbDocDataContra;
  final String nbDocDataConsult;
  final String nbDocDataStop;
  final String nbDocDataWarning;

  OverviewModel({
    required this.itemName,
    required this.entpName,
    required this.etcOtcName,
    required this.eeDocData,
    required this.udDocData,
    required this.nbDocDataStorage,
    required this.nbDocDataContra,
    required this.nbDocDataConsult,
    required this.nbDocDataStop,
    required this.nbDocDataWarning,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      itemName: json['ITEM_NAME'] ?? '',
      entpName: json['ENTP_NAME'] ?? '',
      etcOtcName: json['ETC_OTC_NAME'] ?? '',
      eeDocData: parseEEDoc(json['EE_DOC_DATA'] ?? ''),
      udDocData: parseEEDoc(json['UD_DOC_DATA'] ?? ''),
      nbDocDataStorage: parseEEDoc(json['NB_DOC_DATA_STORAGE'] ?? ''),
      nbDocDataContra: parseEEDoc(json['NB_DOC_DATA_CONTRA'] ?? ''),
      nbDocDataConsult: parseEEDoc(json['NB_DOC_DATA_CONSULT'] ?? ''),
      nbDocDataStop: parseEEDoc(json['NB_DOC_DATA_STOP'] ?? ''),
      nbDocDataWarning: parseEEDoc(json['NB_DOC_DATA_WARNING'] ?? ''),
    );
  }
}
