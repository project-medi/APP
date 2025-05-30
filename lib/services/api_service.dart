import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project_medi/models/overview_model.dart';

class ApiService {
  final String baseUrl = "https://apis.data.go.kr/1471000";
  final String? serviceKey = dotenv.env["serviceKey"];

  // 개요 검색 by 이름
  Future<List<OverviewModel>> getMedicineOverview(String keyword) async {
    List<OverviewModel> overviewInstances = [];
    final encodedName = Uri.encodeQueryComponent(keyword);

    final url = Uri.parse(
      "$baseUrl/DrugPrdtPrmsnInfoService06/getDrugPrdtPrmsnDtlInq05"
      "?ServiceKey=$serviceKey"
      "&type=json"
      "&item_name=$keyword",
    );

    try {
      final response = await http.get(url);
      print("🔍 검색 요청 URL: $url");
      print("📡 상태 코드: ${response.statusCode}");
      print("약이름: $encodedName");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final items = jsonData["body"]?["items"];

        if (items != null) {
          if (items is List) {
            for (var item in items) {
              overviewInstances.add(OverviewModel.fromJson(item));
            }
          } else if (items is Map) {
            overviewInstances.add(
              OverviewModel.fromJson(items.cast<String, dynamic>()),
            );
          }
        } else {
          print("❗ 'items'가 비어 있습니다.");
        }
      } else {
        print("❗ 서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❗ 예외 발생: $e");
    }

    return overviewInstances;
  }
}
