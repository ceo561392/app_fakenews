import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'page_news.dart';

//import 'News.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake News Detector',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 250, 30, 30),
        
        // ignore: deprecated_member_use
        backgroundColor: const Color.fromARGB(255, 10, 1, 1),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Color.fromARGB(255, 129, 255, 150),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String _result = '';
  String _resultsvm = '';
  String _resultknn = '';
  String _resultgbc = '';
  // ignore: unused_field
  String _news = '';
  
   
  

  Future<void> _predictFakeNews(String text) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/predict?text=$text'));
    if (response.statusCode == 200) {
      setState(() {
        _result = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<void> _predictSVM(String text) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/predictsvm?text=$text'));
  if (response.statusCode == 200) {
    setState(() {
      _resultsvm = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
    });
  } else {
    throw Exception('Failed to load data');
  }
}
  Future<void> _predictKNN(String text) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/predictknn?text=$text'));
  if (response.statusCode == 200) {
    setState(() {
      _resultknn = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
    });
  } else {
    throw Exception('Failed to load data');
  }
}
  Future<void> _predictGBC(String text) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/predictgbc?text=$text'));
  if (response.statusCode == 200) {
    setState(() {
      _resultgbc = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
    });
  } else {
    throw Exception('Failed to load data');
  }
}
  Future<void> _searchNews(String text) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/search_news?text=$text'));
  if (response.statusCode == 200) {
    
    setState(() {
      _news = utf8.decode(jsonDecode(response.body)['news'].runes.toList());
    });
  } else {
    throw Exception('Failed to load data');
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fake News Detector',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Color.fromARGB(255, 247, 54, 54),
      ),
      backgroundColor: Color.fromARGB(255, 188, 255, 233),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            const Text(
              'เช็คข่าว', 
              style:TextStyle(
              fontSize: 50,
              color:Color.fromARGB(255, 0, 0, 0)
              )),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _textEditingController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Enter news text...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _predictFakeNews(_textEditingController.text);
                _predictSVM(_textEditingController.text);
                _predictKNN(_textEditingController.text);
                _predictGBC(_textEditingController.text);
              },
              child:  Text(
                'Predict',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                primary: Theme.of(context).primaryColor,
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(height: 20),
            Text(
              'LSTM: $_result SVM: $_resultsvm KNN: $_resultknn GBC: $_resultgbc',
              
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20), 

            ElevatedButton(
              onPressed: () {
                _searchNews(_textEditingController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsWidget(text: _textEditingController.text,)),
    );
              },
              child:  Text(
                'Search News',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                primary: Theme.of(context).primaryColor,
              ),
            ),

            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
