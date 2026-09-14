import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'page_news.dart';

void main() => runApp(const FakeNewsApp());

class FakeNewsApp extends StatelessWidget {
  const FakeNewsApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Verity',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF17181C),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        ),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _apiHost = '127.0.0.1:8000';
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final Map<String, String> _results = {};
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<String> _predict(String endpoint) async {
    final uri = Uri.http(_apiHost, endpoint, {
      'text': _titleController.text.trim(),
      'body': _bodyController.text.trim(),
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('ไม่สามารถเชื่อมต่อระบบวิเคราะห์ได้');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return data['sentiment']?.toString() ?? 'ไม่มีผลลัพธ์';
  }

  Future<void> _analyse() async {
    if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      setState(() => _error = 'กรุณากรอกทั้งหัวข้อและเนื้อหาข่าว');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
      _results.clear();
    });
    try {
      final values = await Future.wait([
        _predict('/predict_tb_lstm'),
        _predict('/predict_tb_svm'),
        _predict('/predict_tb_knn'),
        _predict('/predict_tb_gbc'),
      ]);
      if (!mounted) return;
      setState(() => _results.addAll({
            'LSTM': values[0],
            'SVM': values[1],
            'KNN': values[2],
            'GBC': values[3],
          }));
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'เชื่อมต่อ API ไม่สำเร็จ กรุณาตรวจว่า FastAPI ทำงานอยู่ที่พอร์ต 8000');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _searchNews() {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _error = 'กรุณากรอกหัวข้อข่าวก่อนค้นหา');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NewsWidget(text: _titleController.text.trim())),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
                children: [
                  const _BrandBar(),
                  const SizedBox(height: 30),
                  const Text('ตรวจสอบก่อนแชร์', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -1.4, color: Color(0xFF17181C))),
                  const SizedBox(height: 10),
                  const Text('ใช้ AI วิเคราะห์สัญญาณของข่าวปลอมจากหัวข้อและเนื้อหาข่าว', style: TextStyle(fontSize: 17, height: 1.45, color: Color(0xFF6E6E73))),
                  const SizedBox(height: 28),
                  _InputCard(titleController: _titleController, bodyController: _bodyController),
                  const SizedBox(height: 16),
                  if (_error != null) _Notice(message: _error!),
                  if (_error != null) const SizedBox(height: 16),
                  SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _analyse,
                      icon: _isLoading ? const SizedBox.square(dimension: 19, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.auto_awesome_rounded),
                      label: Text(_isLoading ? 'กำลังวิเคราะห์...' : 'วิเคราะห์ข่าว', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF17181C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(onPressed: _isLoading ? null : _searchNews, icon: const Icon(Icons.travel_explore_rounded), label: const Text('ค้นหาข่าวที่เกี่ยวข้อง')),
                  if (_results.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    const Text('ผลการวิเคราะห์', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF17181C))),
                    const SizedBox(height: 12),
                    ..._results.entries.map((entry) => _ResultCard(model: entry.key, result: entry.value)),
                  ],
                  const SizedBox(height: 28),
                  const _PrivacyNote(),
                ],
              ),
            ),
          ),
        ),
      );
}

class _BrandBar extends StatelessWidget {
  const _BrandBar();
  @override
  Widget build(BuildContext context) => const Row(children: [
        DecoratedBox(decoration: BoxDecoration(color: Color(0xFF17181C), borderRadius: BorderRadius.all(Radius.circular(12))), child: Padding(padding: EdgeInsets.all(9), child: Icon(Icons.verified_user_outlined, color: Colors.white, size: 22))),
        SizedBox(width: 10),
        Text('Verity', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: -0.5)),
        Spacer(),
        Text('AI fact check', style: TextStyle(color: Color(0xFF86868B), fontSize: 13, fontWeight: FontWeight.w600)),
      ]);
}

class _InputCard extends StatelessWidget {
  const _InputCard({required this.titleController, required this.bodyController});
  final TextEditingController titleController;
  final TextEditingController bodyController;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 28, offset: Offset(0, 10))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('รายละเอียดข่าว', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('ยิ่งให้บริบทมาก ผลวิเคราะห์ยิ่งแม่นยำ', style: TextStyle(color: Color(0xFF86868B))),
          const SizedBox(height: 20),
          TextField(controller: titleController, textInputAction: TextInputAction.next, decoration: _decoration('หัวข้อข่าว', 'เช่น พบหลักฐานใหม่เกี่ยวกับ...', Icons.title_rounded)),
          const SizedBox(height: 14),
          TextField(controller: bodyController, minLines: 5, maxLines: 8, decoration: _decoration('เนื้อหาข่าว', 'วางเนื้อหาข่าวที่ต้องการตรวจสอบ', Icons.article_outlined)),
        ]),
      );

  InputDecoration _decoration(String label, String hint, IconData icon) => InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
        prefixIcon: Padding(padding: const EdgeInsets.only(bottom: 62), child: Icon(icon)),
        filled: true,
        fillColor: const Color(0xFFF5F5F7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.model, required this.result});
  final String model;
  final String result;

  @override
  Widget build(BuildContext context) {
    final isSafe = result.toLowerCase().contains('real') || result.contains('จริง');
    final color = isSafe ? const Color(0xFF16803C) : const Color(0xFFCF3E32);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(12)), child: Icon(isSafe ? Icons.check_rounded : Icons.priority_high_rounded, color: color)),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(model, style: const TextStyle(fontWeight: FontWeight.w800)), Text(result, style: TextStyle(color: color, fontWeight: FontWeight.w600))])),
      ]),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFE9E7), borderRadius: BorderRadius.circular(16)), child: Row(children: [const Icon(Icons.info_outline, color: Color(0xFFB42318)), const SizedBox(width: 10), Expanded(child: Text(message, style: const TextStyle(color: Color(0xFF8C1D18)))]));
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();
  @override
  Widget build(BuildContext context) => const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.lock_outline, size: 17, color: Color(0xFF86868B)), SizedBox(width: 8), Expanded(child: Text('ผลลัพธ์เป็นข้อมูลช่วยประกอบการตัดสินใจ ควรตรวจสอบแหล่งข่าวต้นทางเพิ่มเติมเสมอ', style: TextStyle(color: Color(0xFF86868B), height: 1.45)))]);
}
