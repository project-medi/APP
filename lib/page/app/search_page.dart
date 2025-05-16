import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_medi/services/api_service.dart';
import 'package:project_medi/models/overview_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ApiService apiService = ApiService();

  String query = '';
  bool isSubmitted = false;

  List<Map<String, dynamic>> results = [];

  void onSearchChanged(String input) {
    setState(() {
      query = input;
      isSubmitted = false;
    });
  }

  void onSearchSubmitted(String input) async {
    setState(() {
      isSubmitted = true;
      query = input;
    });

    final fetchedResults = await apiService.getMedicineOverviewByName(input);

    setState(() {
      results =
          fetchedResults
              .map(
                (e) => {
                  'title': e.itemName ?? '',
                  'tags': (e.seQesitm ?? '').split(','),
                  'description': e.efcyQesitm ?? '',
                },
              )
              .toList();
    });
  }

  TextSpan highlightText(String? fullText, String query) {
    fullText ??= '';
    if (query.isEmpty ||
        !fullText.toLowerCase().contains(query.toLowerCase())) {
      return TextSpan(text: fullText);
    }

    final spans = <TextSpan>[];
    final lowerText = fullText.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int index;

    while ((index = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (index > start) {
        spans.add(TextSpan(text: fullText.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: fullText.substring(index, index + query.length),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = index + query.length;
    }

    if (start < fullText.length) {
      spans.add(TextSpan(text: fullText.substring(start)));
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
                decoration: InputDecoration(
                  hintText: '검색어를 입력해주세요',
                  suffixIcon:
                      query.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              onSearchChanged('');
                              setState(() => results.clear());
                            },
                          )
                          : const Icon(Icons.search),
                  border: const UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (query.isNotEmpty && !isSubmitted)
              Expanded(
                child: FutureBuilder<List<OverviewModel>>(
                  future: apiService.getMedicineOverviewByName(query),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('에러 발생: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/Notfound.svg',
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 13),
                          const Center(child: Text('검색어와 일치하는 약이 없습니다')),
                          const SizedBox(height: 2),
                          const Center(child: Text('검색어를 다시 확인해주세요')),
                        ],
                      );
                    }

                    final items = snapshot.data!;
                    return ListView(
                      children:
                          items
                              .map(
                                (e) => ListTile(
                                  title: Text.rich(
                                    highlightText(e.itemName ?? '', query),
                                  ),
                                  onTap: () {
                                    _controller.text = e.itemName ?? '';
                                    onSearchSubmitted(e.itemName ?? '');
                                  },
                                ),
                              )
                              .toList(),
                    );
                  },
                ),
              ),
            if (isSubmitted)
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, index) {
                    final item = results[index];
                    final tags = (item['tags'] as List).whereType<String>();
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children:
                                  tags
                                      .map(
                                        (tag) => Chip(
                                          label: Text(
                                            tag.trim(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            side: BorderSide(
                                              color: Colors.blue.shade300,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 4),
                            Text(item['description'] ?? ''),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // 상세 페이지 이동 등 기능 구현 예정
                                },
                                child: const Text('자세히 보기 >'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
