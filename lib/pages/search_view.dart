import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_360/pages/article_view.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, String>> articles = [];
  List<Map<String, String>> filteredArticles = [];
  TextEditingController _searchController = TextEditingController();

  final String apiUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=26452a3aaeb14cbfbcfa950bf679f9ba";

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          articles = (data['articles'] as List)
              .map((article) => {
            'title': article['title'] as String,
            'url': article['url'] as String,
          })
              .toList();
          filteredArticles = List.from(articles);
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print('Error fetching news: $error');
    }
  }

  void _filterArticles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredArticles = List.from(articles);
      } else {
        filteredArticles = articles
            .where((article) => article['title']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("News"),
            SizedBox(width: 5),
            Text(
              "360",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for news...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterArticles,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.red, width: 2),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      title: Text(
                        filteredArticles[index]['title']!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.red),
                      onTap: () {
                        // Navigate to the article view page when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleView(
                              blogUrl: filteredArticles[index]['url']!, // Pass the URL
                            ),
                          ),
                        );
                      },
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
