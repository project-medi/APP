import 'package:flutter/material.dart';
import 'package:project_medi/models/overview_model.dart';

class DetailPage extends StatelessWidget {
  final OverviewModel model;

  const DetailPage({super.key, required this.model});

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            content.isNotEmpty ? content : '정보 없음',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(model.itemName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('효능', model.eeDocData),
            _buildSection('용법 용량', model.udDocData),
            _buildSection('보관방법', model.nbDocDataStorage),
            _buildSection('복용 금기자', model.nbDocDataContra),
            _buildSection('의사 상담 기준', model.nbDocDataConsult),
            _buildSection('복용 중단 기준', model.nbDocDataStop),
            _buildSection('사용상의 주의사항', model.nbDocDataWarning),
          ],
        ),
      ),
    );
  }
}
