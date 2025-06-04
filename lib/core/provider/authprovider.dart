import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:supervisor_app/core/service/networkservice.dart';
import 'package:supervisor_app/feature/homepage/screens/homepage.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Timer? _tokenRefreshTimer;

  bool get isAuthenticated => _isAuthenticated;

  final NetworkService _networkService = NetworkService();
  final Box authBox = Hive.box('authBox');

  Future<bool> login(
    String loginId,
    String password,
    BuildContext context,
  ) async {
    try {
      final Response? response = await _networkService.loginServiceman(
        username: loginId,
        password: password,
        servicemanType: "Supervisor",
      );

      if (response == null || response.statusCode != 200) {
        return false;
      }

      final String jsonString = response.data['value'];
      final Map<String, dynamic> parsedJson = jsonDecode(jsonString);
      final Map<String, dynamic>? serviceman =
          parsedJson['results']?['serviceman'];

      if (serviceman == null) {
        return false;
      }

      _isAuthenticated = true;

      // Save session to Hive
      authBox.put("isAuthenticated", _isAuthenticated);
      authBox.put("authToken", response.data['token'] ?? "");
      authBox.put("loginTimestamp", DateTime.now().millisecondsSinceEpoch);

      final servicemanName = serviceman['servicename_name'] ?? 'Unknown';
      final servicemanCode = serviceman['servicename_code'] ?? 'N/A';

      final userBox = Hive.box('userBox');
      userBox.put('servicemanName', servicemanName);
      userBox.put('servicemanCode', servicemanCode);

      notifyListeners();

      // Start token refresh
      _startTokenRefresh();

      // Navigate to HomePage
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _tokenRefreshTimer?.cancel();
    await authBox.clear();
    final userBox = Hive.box('userBox');
    await userBox.clear();
    notifyListeners();
  }

  void _startTokenRefresh() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer.periodic(Duration(minutes: 55), (timer) async {
      await _refreshToken();
    });
  }

  Future<void> _refreshToken() async {
    try {
      final String? currentToken = authBox.get("authToken");

      if (currentToken == null || !_isAuthenticated) return;

      final String? newToken = await _networkService.getAccessToken();

      if (newToken != null && newToken.isNotEmpty) {
        authBox.put("authToken", newToken);
        authBox.put("loginTimestamp", DateTime.now().millisecondsSinceEpoch);
        notifyListeners();
      }
    } catch (e) {
      print("❗ Token refresh failed: $e");
    }
  }

  loadUserSession() {}
}
