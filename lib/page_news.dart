import 'dart:convert';
import 'package:myapp/methods/launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsWidget extends StatelessWidget {
  final String text;

  const NewsWidget({Key? key, required this.text}) : super(key: key);

  Future<List<dynamic>> fetchNews(String text) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/search_news?text=$text'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> news = json.decode(data['news']);
      return news;
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      
      future: fetchNews(text),
      
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> news = snapshot.data!;
          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final newsItem = news[index];
              
              if (newsItem['หัวข้อข่าว'] != null && newsItem['ลิงค์ข่าว'] != null) {

                return Container(
                  
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // กำหนดสีพื้นหลังเป็นสีเทาอ่อน
                    borderRadius: BorderRadius.circular(15), // กำหนดรูปร่างของ Container
  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 25),
                      Text(
                        newsItem['หัวข้อข่าว']!, 
                        style: const TextStyle(
                          
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      SizedBox(height: 12),

                      GestureDetector(
                        onTap: () {
                          launchInBrowser(Uri.parse(newsItem['ลิงค์ข่าว']!)); 
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFF3A44),
                                Color(0xFFFF8086),
                              ],
                            ),
                          ),
                          child: const Text(
                            "อ่านเพิ่มเติม",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                
                return Container(
                  child: const Text(
                            "Null",
                            
                          ),
                );
              }
            },

          );
        }
      },
      
    );
  }
}


