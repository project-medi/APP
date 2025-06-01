import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_medi/page/app/detail_page.dart';
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

  List<OverviewModel> results = [];

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

    final fetchedResults = await apiService.getMedicineOverview(input);

    setState(() {
      results = fetchedResults;
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
                cursorColor: Colors.black,
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
                  future: apiService.getMedicineOverview(query),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('에러 발생: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildNotFound();
                    }

                    final items = snapshot.data!;
                    return ListView(
                      children:
                          items.map((e) {
                            return ListTile(
                              title: Text.rich(
                                highlightText(e.itemName, query),
                              ),
                              onTap: () {
                                _controller.text = e.itemName;
                                onSearchSubmitted(e.itemName);
                              },
                            );
                          }).toList(),
                    );
                  },
                ),
              ),
            if (isSubmitted)
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, index) {
                    final e = results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xffEAEAEA)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.itemName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff222222),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                e.eeDocData,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff707070),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailPage(model: e),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: const [
                                          Text(
                                            '자세히 보기',
                                            style: TextStyle(
                                              color: Color(0xff707070),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          SizedBox(
                                            width: 72,
                                            child: Divider(
                                              color: Color(0xff707070),
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xff707070),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildNotFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            'assets/images/Notfound.svg',
            height: 150,
            color: const Color(0xffC5C5C5),
          ),
        ),
        const SizedBox(height: 13),
        const Center(
          child: Text(
            '검색어와 일치하는 약이 없습니다',
            style: TextStyle(color: Color(0xffC5C5C5)),
          ),
        ),
        const SizedBox(height: 2),
        const Center(
          child: Text(
            '검색어를 다시 확인해주세요',
            style: TextStyle(color: Color(0xffC5C5C5)),
          ),
        ),
      ],
    );
  }
}
