import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class ArticleView extends StatefulWidget {
  final String blogUrl;
  ArticleView({required this.blogUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Additional setup for hybrid composition if required for Android
  }

  // Function to save the article URL to SharedPreferences
  Future<void> _saveArticle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedArticles = prefs.getStringList('savedArticles') ?? [];

    // Add the article URL if it's not already saved
    if (!savedArticles.contains(widget.blogUrl)) {
      savedArticles.add(widget.blogUrl);
      await prefs.setStringList('savedArticles', savedArticles);
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article saved for later reading!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This article is already saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("News"),
            Text(
              "360",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: _saveArticle, // Trigger the save function when clicked
          ),
        ],
      ),
      body: WebViewWidget(
        controller: _createWebViewController(widget.blogUrl),
      ),
    );
  }

  WebViewController _createWebViewController(String initialUrl) {
    _controller = WebViewController()
      ..loadRequest(Uri.parse(initialUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);
    return _controller;
  }
}
