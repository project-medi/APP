import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project_medi/models/overview_model.dart';
import '../models/image_model.dart';

class ApiService {
  final String baseUrl = "http://apis.data.go.kr/1471000";
  final String? serviceKey = dotenv.env["serviceKey"];

  final String type = "type=json";
  final String medicineName = "타이레놀";

  // 의약품 개요 조회
  Future<List<OverviewModel>> getMedicineOverview() async {
    List<OverviewModel> overviewInstances = [];
    final encodedName = Uri.encodeQueryComponent(medicineName);

    final url = Uri.parse(
      "$baseUrl/DrbEasyDrugInfoService/getDrbEasyDrugList"
      "?ServiceKey=$serviceKey"
      "&itemName=$encodedName"
      "&$type",
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

  // 의약품 이미지 조회
  Future<List<ImageModel>> getMedicineImage() async {
    List<ImageModel> imageInstances = [];
    final encodedName = Uri.encodeQueryComponent(medicineName);

    final url = Uri.parse(
      "$baseUrl/MdcinGrnIdntfcInfoService01/getMdcinGrnIdntfcInfoList01"
      "?serviceKey=$serviceKey"
      "&item_name=$encodedName"
      "&$type",
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
          print("응답 본문: ${response.body}");
        }
      } else {
        print("❗ 서버 오류: ${response.statusCode}");
        print("응답 본문: ${response.body}");
      }
    } catch (e) {
      print("❗ 예외 발생: $e");
    }

    return imageInstances;
  }
}
