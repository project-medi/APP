import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project_medi/models/overview_model.dart';
import '../models/image_model.dart';

class ApiService {
  final String baseUrl = "http://apis.data.go.kr/1471000";
  final String? serviceKey = dotenv.env["serviceKey"];
  final String type = "type=json";

  // 개요 검색 by 이름
  Future<List<OverviewModel>> getMedicineOverviewByName(String keyword) async {
    List<OverviewModel> overviewInstances = [];
    final encodedName = Uri.encodeQueryComponent(keyword);

    final url = Uri.parse(
      "$baseUrl/DrbEasyDrugInfoService/getDrbEasyDrugList"
      "?ServiceKey=$serviceKey"
      "&$type"
      "&itemName=$encodedName",
    );

    try {
      final response = await http.get(url);
      print("🔍 개요 요청 URL: $url");
      print("📡 응답 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final items = jsonData["body"]?["items"];

        if (items != null) {
          for (var item in items) {
            overviewInstances.add(OverviewModel.fromJson(item));
          }
        } else {
          print("❗ 'items' 항목이 응답에 없습니다.");
          print("응답 본문: ${response.body}");
        }
      } else {
        print("❗ 서버 오류: ${response.statusCode}");
        print("응답 본문: ${response.body}");
      }
    } catch (e) {
      print("❗ 예외 발생: $e");
    }

    return overviewInstances;
  }

  // 이미지 검색 (선택적으로 사용 가능)
  Future<List<ImageModel>> getMedicineImage(String keyword) async {
    List<ImageModel> imageInstances = [];
    final encodedName = Uri.encodeQueryComponent(keyword);

    final url = Uri.parse(
      "$baseUrl/MdcinGrnIdntfcInfoService01/getMdcinGrnIdntfcInfoList01"
      "?serviceKey=$serviceKey"
      "&$type"
      "&item_name=$encodedName",
    );

    try {
      final response = await http.get(url);
      print("🔍 이미지 요청 URL: $url");
      print("📡 응답 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final items = jsonData["body"]?["items"];

        if (items != null) {
          for (var item in items) {
            imageInstances.add(ImageModel.fromjson(item));
          }
        } else {
          print("❗ 'items' 항목이 응답에 없습니다.");
        }
      } else {
        print("❗ 서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❗ 예외 발생: $e");
    }

    return imageInstances;
  }
}
