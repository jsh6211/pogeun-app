import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const PogeunApp());
}

class PogeunApp extends StatelessWidget {
  const PogeunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '포근',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFEFF4FA),
        fontFamily: 'Pretendard',
      ),
      home: const SplashScreen(),
    );
  }
}

// 1. 스플래시 / 로그인 화면
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // 로고 아이콘
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF2B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 16),
              const Text(
                '포근',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2B82F6)),
              ),
              const SizedBox(height: 8),
              const Text(
                '요양보호사님의 어르신 케어를 지원합니다',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const Spacer(),
              // 사용자 입력 / 로그인 버튼
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('최귀순 요양보호사님', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  child: const Text('시작하기 →', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. 메인 화면 (탭 구분)
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final FlutterTts flutterTts = FlutterTts();

  // 돌봄 기록 데이터
  List<Map<String, String>> careLogs = [
    {'time': '01:24', 'type': '체위 변경', 'target': '305호 · 박정자님 · 최귀순 요양보호사'},
    {'time': '01:24', 'type': '투약 (혈압약)', 'target': '302호 · 김말순님 · 최귀순 요양보호사'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    // 화면 진입 후 알림 팝업 및 음성 재생
    Future.delayed(const Duration(seconds: 1), () {
      _showNotificationDialog();
    });
  }

  void _initTts() async {
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.5);
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _showNotificationDialog() {
    _speak("302호 김말순 어르신, 혈압약 복용 시간입니다.");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('302호 · 김말순어르신', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('01:23', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('혈압약 복용 시간입니다.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 16),
              const Text('당장 조치가 필요없거나 건너뛸 경우 선택해주세요', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('30분 후')),
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('1시간 후')),
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('건너뛰기')),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B82F6)),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      careLogs.insert(0, {
                        'time': '방금 전',
                        'type': '투약 완료 (혈압약)',
                        'target': '302호 · 김말순님 · 최귀순 요양보호사'
                      });
                      _selectedIndex = 2; // 기록 탭으로 이동
                    });
                    _speak("혈압약 복용 완료 처리되었습니다.");
                  },
                  child: const Text('조치 완료', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildPatientList(),
      const Center(child: Text('돌봄 알림 목록')),
      _buildRecordList(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('최귀순님, 안녕하세요', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.blue),
            onPressed: () => _speak("302호 김말순 어르신, 혈압약 복용 시간입니다."),
          )
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '어르신'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '돌봄알림'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '돌봄기록'),
        ],
      ),
    );
  }

  // 어르신 목록
  Widget _buildPatientList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('오늘 돌봄 어르신은 3명입니다', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        _buildPatientCard('김말순', '82세', '302호 · 01:23', ['육창 주의', '연하곤란'], Colors.green.shade100),
        _buildPatientCard('박정자', '79세', '305호 · 01:23', ['체위변경 필요'], Colors.orange.shade100),
        _buildPatientCard('이복동', '88세', '301호 · 01:23', ['치매 초기', '투약 다수'], Colors.grey.shade200),
      ],
    );
  }

  Widget _buildPatientCard(String name, String age, String info, List<String> tags, Color bgColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundColor: bgColor, child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name · $age', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(info, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: tags.map((tag) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                    child: Text(tag, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                  )).toList(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // 돌봄 기록 목록
  Widget _buildRecordList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: careLogs.length,
              itemBuilder: (context, index) {
                final log = careLogs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(log['time']!, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    title: Text(log['type']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(log['target']!),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B82F6)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('보호자 및 기관에 돌봄 기록 제출 완료!')),
                );
              },
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text('보호자·기관에 제출하기', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
