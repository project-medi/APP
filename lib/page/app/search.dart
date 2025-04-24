import 'package:flutter/material.dart';
import 'package:project_medi/models/image_model.dart';
import 'package:project_medi/models/overview_model.dart';
import 'package:project_medi/services/api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<OverviewModel>> overviews = ApiService().getMedicineOverview();

  Future<List<ImageModel>> images = ApiService().getMedicineImage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(future: images, builder: (context, snapshot){
          if(snapshot.hasData){
            return const Text("good!!!");
          }
          return const Text("Loading...");
        })
      ),
    );
  }
}
