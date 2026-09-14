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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111827), brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF111827), width: 1.5)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0)),
        
        // ignore: deprecated_member_use
        backgroundColor: const Color.fromARGB(255, 10, 1, 1),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF111827),
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
  final TextEditingController _bodyEditingController = TextEditingController();
  // ignore: unused_field
  String _result = '';
  // ignore: unused_field
  String _resultsvm = '';
  // ignore: unused_field
  String _resultknn = '';
  // ignore: unused_field
  String _resultgbc = '';
  // ignore: unused_field
  String _news = '';
  String _result_tblstm = '';
  String _result_tbsvm = '';
  String _result_tbknn = '';
  String _result_tbgbc = '';
   
  

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
//////////////////////////////////////////////////////////////////////////
   
   Future<void> _predict_tb_lstm(String text,String body) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/predict_tb_lstm?text=$text&body=$body'));
    if (response.statusCode == 200) {
      setState(() {
        _result_tblstm = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _predict_tb_svm(String text,String body) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/predict_tb_svm?text=$text&body=$body'));
    if (response.statusCode == 200) {
      setState(() {
        _result_tbsvm = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _predict_tb_knn(String text,String body) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/predict_tb_knn?text=$text&body=$body'));
    if (response.statusCode == 200) {
      setState(() {
        _result_tbknn = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _predict_tb_gbc(String text,String body) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/predict_tb_gbc?text=$text&body=$body'));
    if (response.statusCode == 200) {
      setState(() {
        _result_tbgbc = utf8.decode(jsonDecode(response.body)['sentiment'].runes.toList());
      });
    } else {
      throw Exception('Failed to load data');
    }
  }







/////////////////////////////////////////////////////////////////////////////



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fake News Detector',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF111827),
      ),
      backgroundColor: const Color(0xFFF5F5F7),
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
                  hintText: 'Enter news title...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _bodyEditingController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Enter news body...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _predict_tb_lstm(_textEditingController.text,_bodyEditingController.text);
                _predict_tb_svm(_textEditingController.text,_bodyEditingController.text);
                _predict_tb_knn(_textEditingController.text,_bodyEditingController.text);
                _predict_tb_gbc(_textEditingController.text,_bodyEditingController.text);
              },
              child:  Text(
                'Predict',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                backgroundColor: Color.fromARGB(222, 222, 0, 0)
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(height: 20),
            Text(
              'LSTM: $_result_tblstm SVM: $_result_tbsvm KNN: $_result_tbknn GBC: $_result_tbgbc',
              
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
                backgroundColor: Color.fromARGB(222, 222, 0, 0)
              ),
            ),

            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
