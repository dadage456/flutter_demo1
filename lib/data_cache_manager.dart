import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheManager {
  static const String _pendingSubmissionsKey = 'pending_submissions';
  static const String _localDataKey = 'local_data';
  static const String _lastSyncTimeKey = 'last_sync_time';

  static Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  static Future<void> cachePendingSubmission(Map<String, dynamic> data) async {
    final prefs = await _prefs;
    final pendingList = prefs.getStringList(_pendingSubmissionsKey) ?? [];
    pendingList.add(jsonEncode(data));
    await prefs.setStringList(_pendingSubmissionsKey, pendingList);
  }

  static Future<List<Map<String, dynamic>>> getPendingSubmissions() async {
    final prefs = await _prefs;
    final pendingList = prefs.getStringList(_pendingSubmissionsKey) ?? [];
    return pendingList.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  static Future<void> removePendingSubmission(int index) async {
    final prefs = await _prefs;
    final pendingList = prefs.getStringList(_pendingSubmissionsKey) ?? [];
    if (index >= 0 && index < pendingList.length) {
      pendingList.removeAt(index);
      await prefs.setStringList(_pendingSubmissionsKey, pendingList);
    }
  }

  static Future<void> clearAllPendingSubmissions() async {
    final prefs = await _prefs;
    await prefs.remove(_pendingSubmissionsKey);
  }

  static Future<void> cacheLocalData(String key, Map<String, dynamic> data) async {
    final prefs = await _prefs;
    final localData = prefs.getString(_localDataKey);
    Map<String, dynamic> dataMap = localData != null ? jsonDecode(localData) as Map<String, dynamic> : {};
    dataMap[key] = data;
    await prefs.setString(_localDataKey, jsonEncode(dataMap));
  }

  static Future<Map<String, dynamic>?> getLocalData(String key) async {
    final prefs = await _prefs;
    final localData = prefs.getString(_localDataKey);
    if (localData != null) {
      final dataMap = jsonDecode(localData) as Map<String, dynamic>;
      return dataMap[key] as Map<String, dynamic>?;
    }
    return null;
  }

  static Future<void> updateLastSyncTime() async {
    final prefs = await _prefs;
    await prefs.setString(_lastSyncTimeKey, DateTime.now().toIso8601String());
  }

  static Future<String?> getLastSyncTime() async {
    final prefs = await _prefs;
    return prefs.getString(_lastSyncTimeKey);
  }

  static Future<int> getPendingCount() async {
    final prefs = await _prefs;
    final pendingList = prefs.getStringList(_pendingSubmissionsKey) ?? [];
    return pendingList.length;
  }
}

class CollectionData {
  final String id;
  final String locationCode;
  final String materialCode;
  final int quantity;
  final String batch;
  final DateTime createdAt;
  final bool synced;

  CollectionData({
    required this.id,
    required this.locationCode,
    required this.materialCode,
    required this.quantity,
    required this.batch,
    required this.createdAt,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'locationCode': locationCode,
        'materialCode': materialCode,
        'quantity': quantity,
        'batch': batch,
        'createdAt': createdAt.toIso8601String(),
        'synced': synced,
      };

  factory CollectionData.fromJson(Map<String, dynamic> json) => CollectionData(
        id: json['id'] as String,
        locationCode: json['locationCode'] as String,
        materialCode: json['materialCode'] as String,
        quantity: json['quantity'] as int,
        batch: json['batch'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        synced: json['synced'] as bool,
      );
}
