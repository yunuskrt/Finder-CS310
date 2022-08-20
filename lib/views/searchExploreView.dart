import 'package:flutter/material.dart';
import 'package:project/util/analytics.dart';
import 'package:project/util/colors.dart';
import 'package:project/classes/navigationBar.dart';
import 'package:project/views/searchPostsView.dart';
import 'package:project/views/searchUsernamesView.dart';

class SearchExploreView extends StatefulWidget {
  const SearchExploreView({Key? key}) : super(key: key);
  @override
  State<SearchExploreView> createState() => _SearchExploreViewState();
}

class _SearchExploreViewState extends State<SearchExploreView> {
  final _searchController = TextEditingController();
  final _searchPostController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setExploreScreen();
    super.initState();
  }

  void setExploreScreen() async {
    await AnalyticsService.setScreenName('Explore Screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text("Search & Explore"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Row(children: [
          const NavBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(flex: 1),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.textFieldFillColor,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                          hintText: "Search Username (Exact Matching)",
                          hintStyle: TextStyle(fontSize: 15),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            color: AppColors.primary,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchUsernames(username: _searchController.text)));
                            },
                          )
                      ),
                    ),
                  ),
                ),
                Spacer(flex:1),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.textFieldFillColor,
                    ),
                    child: TextField(
                      controller: _searchPostController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          hintText: "Search Post Content (Exact Matching)",
                          hintStyle: TextStyle(fontSize: 15),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            color: AppColors.primary,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPosts(postContent: _searchPostController.text)));
                            },
                          )
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 10)
              ],
            ),
          ),
        ]),
      ),
    );
  }
}