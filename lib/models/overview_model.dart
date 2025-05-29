import 'package:project_medi/page/app/utils/html_cleaner.dart';

class OverviewModel {
  final String itemName;
  final String entpName;
  final String etcOtcName;
  final String eeDocData;
  final String udDocData;
  final String nbDocData;

  OverviewModel({
    required this.itemName,
    required this.entpName,
    required this.etcOtcName,
    required this.eeDocData,
    required this.udDocData,
    required this.nbDocData,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      itemName: json['ITEM_NAME'] ?? '',
      entpName: json['ENTP_NAME'] ?? '',
      etcOtcName: json['ETC_OTC_NAME'] ?? '',
      eeDocData: parseEEDoc(json['EE_DOC_DATA'] ?? ''),
      udDocData: parseEEDoc(json['UD_DOC_DATA'] ?? ''),
      nbDocData: parseEEDoc(json['NB_DOC_DATA'] ?? ''),
    );
  }
}
