import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media App',
      home: const MyHomePage(title: 'Social Media App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    show();
    super.initState();
  }

  var nameController = TextEditingController();
  var contentController = TextEditingController();

  var posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  add();
                },
                child: Text("Post")),
          ),
          for (var i = 0; i < posts.length; i++)
            Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      posts[i]['name'],
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      posts[i]['content'],
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(posts[i]['date'])
                          .toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  void add() async {
    var name = nameController.text;
    var content = contentController.text;

    if (name.trim() == "" || content.trim() == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please enter name and content')),
      );
      return;
    }

    var request = http.Client();
    var response = await request.post(Uri.parse("http://10.0.2.2:8080/article"),
        headers: {'content-type': 'application/json'},
        body: json.encode({
          "name": name,
          "content": content,
        }));

    nameController.text = "";
    contentController.text = "";

    show();
  }

  void show() async {
    var request = http.Client();
    var response = await request.get(Uri.parse("http://10.0.2.2:8080/article"));
    var body = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      posts = body.reversed.toList();
    });
  }
}
