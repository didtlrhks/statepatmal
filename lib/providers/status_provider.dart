import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/status_model.dart';

class StatusProvider with ChangeNotifier {
  StatusModel? _myTodayStatus;
  StatusModel? _partnerTodayStatus;
  
  final String _myUserId = 'user1'; // 임시 사용자 ID
  final String _partnerUserId = 'user2'; // 임시 파트너 ID

  StatusModel? get myTodayStatus => _myTodayStatus;
  StatusModel? get partnerTodayStatus => _partnerTodayStatus;

  bool get hasMyStatusToday => _myTodayStatus != null && _myTodayStatus!.isToday;
  bool get hasPartnerStatusToday => _partnerTodayStatus != null && _partnerTodayStatus!.isToday;

  StatusProvider() {
    _loadStatuses();
  }

  // 상태 저장
  Future<void> saveMyStatus(String emoji, String message) async {
    final now = DateTime.now();
    final status = StatusModel(
      id: '${_myUserId}_${now.millisecondsSinceEpoch}',
      userId: _myUserId,
      emoji: emoji,
      message: message,
      createdAt: now,
    );

    _myTodayStatus = status;
    await _saveStatuses();
    notifyListeners();
  }

  // 파트너 상태 저장 (임시 - 나중에 서버 연동)
  Future<void> savePartnerStatus(String emoji, String message) async {
    final now = DateTime.now();
    final status = StatusModel(
      id: '${_partnerUserId}_${now.millisecondsSinceEpoch}',
      userId: _partnerUserId,
      emoji: emoji,
      message: message,
      createdAt: now,
    );

    _partnerTodayStatus = status;
    await _saveStatuses();
    notifyListeners();
  }

  // 로컬 저장소에서 불러오기
  Future<void> _loadStatuses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final myStatusJson = prefs.getString('my_status');
      final partnerStatusJson = prefs.getString('partner_status');

      if (myStatusJson != null) {
        final status = StatusModel.fromJson(json.decode(myStatusJson));
        if (status.isToday) {
          _myTodayStatus = status;
        }
      }

      if (partnerStatusJson != null) {
        final status = StatusModel.fromJson(json.decode(partnerStatusJson));
        if (status.isToday) {
          _partnerTodayStatus = status;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading statuses: $e');
    }
  }

  // 로컬 저장소에 저장
  Future<void> _saveStatuses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_myTodayStatus != null) {
        await prefs.setString('my_status', json.encode(_myTodayStatus!.toJson()));
      }
      
      if (_partnerTodayStatus != null) {
        await prefs.setString('partner_status', json.encode(_partnerTodayStatus!.toJson()));
      }
    } catch (e) {
      debugPrint('Error saving statuses: $e');
    }
  }
}

