import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:news_360/pages/article_view.dart';

class SavedArticlesPage extends StatefulWidget {
  @override
  State<SavedArticlesPage> createState() => _SavedArticlesPageState();
}

class _SavedArticlesPageState extends State<SavedArticlesPage> {
  List<String> savedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  // Load saved articles from SharedPreferences
  Future<void> _loadSavedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> articles = prefs.getStringList('savedArticles') ?? [];
    setState(() {
      savedArticles = articles;
    });
  }

  // Function to delete an article
  Future<void> _deleteArticle(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> articles = prefs.getStringList('savedArticles') ?? [];
    articles.remove(url); // Remove the article from the list
    await prefs.setStringList('savedArticles', articles); // Save the updated list back to SharedPreferences

    setState(() {
      savedArticles = articles; // Update the state to reflect changes
    });

    // Show a snack bar to confirm deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Article removed from saved list!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Articles",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: savedArticles.isEmpty
          ? Center(
        child: Text(
          'No saved articles yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: savedArticles.length,
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
                'Article ${index + 1}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
              ),
              subtitle: Text(
                savedArticles[index],
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteArticle(savedArticles[index]); // Delete the article
                    },
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red,
                  ),
                ],
              ),
              onTap: () {
                // Navigate to the article view page when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleView(
                      blogUrl: savedArticles[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
