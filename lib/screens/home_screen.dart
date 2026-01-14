import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/status_provider.dart';
import '../widgets/status_card.dart';
import '../theme/app_theme.dart';
import 'status_input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statepatmal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // 설정 화면으로 이동 (나중에 구현)
            },
          ),
        ],
      ),
      body: Consumer<StatusProvider>(
        builder: (context, statusProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // 내 상태 카드
                StatusCard(
                  status: statusProvider.myTodayStatus,
                  title: '내 상태',
                  isMine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatusInputScreen(),
                      ),
                    );
                  },
                ),
                // 상대방 상태 카드
                StatusCard(
                  status: statusProvider.partnerTodayStatus,
                  title: '상대방 상태',
                  isMine: false,
                ),
                const SizedBox(height: 40),
                // 감정 그래프 미리보기 (임시)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '이번 주 감정 트렌드',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppTheme.accentPurple,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                '곧 추가될 기능입니다',
                                style: TextStyle(
                                  color: AppTheme.primaryPurple,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StatusInputScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryPurple,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('상태 입력하기'),
      ),
    );
  }
}

