import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/ongoing.dart';
import '../service/networkservice.dart';

class OngoingProvider extends ChangeNotifier {
  final NetworkService _networkService = NetworkService();

  List<OngoingProject> _allProjects = [];
  List<OngoingProject> _filteredProjects = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OngoingProject> get projects => _filteredProjects;

  bool _disposed = false;

  OngoingProvider() {
    fetchOngoingProjects();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  Future<void> fetchOngoingProjects() async {
    _isLoading = true;
    safeNotifyListeners();

    final Box authBox = Hive.box('authBox');
    final String? loginCode = authBox.get('loginCode');
    if (loginCode == null) {
      print("[DEBUG] No loginCode found.");
      _isLoading = false;
      safeNotifyListeners();
      return;
    }

    final response = await _networkService.getProjectsByLogin(
      loginCode: loginCode,
      projectStatus: 'Processing',
    );
    print('[DEBUG] Ongoing API response: ${response?.data}');

    if (response != null && response.statusCode == 200) {
      try {
        final rawValue = response.data['value'];
        final decoded = jsonDecode(rawValue);
        final List<dynamic> serviceOrders =
            decoded['results']['result']['service_orders'];
        _allProjects =
            serviceOrders.map((json) => OngoingProject.fromJson(json)).toList();
        _filteredProjects = _allProjects;
      } catch (e) {
        print("[DEBUG] Ongoing Parsing error: $e");
        _allProjects = [];
        _filteredProjects = [];
      }
    } else {
      print("[DEBUG] Failed to fetch ongoing projects");
    }

    _isLoading = false;
    safeNotifyListeners();
  }

  void searchProject(String query) {
    if (query.isEmpty) {
      _filteredProjects = _allProjects;
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredProjects =
          _allProjects.where((project) {
            return project.address.toLowerCase().contains(lowerQuery) ||
                project.customerInfo.toLowerCase().contains(lowerQuery) ||
                project.id.toLowerCase().contains(lowerQuery) ||
                project.type.toLowerCase().contains(lowerQuery) ||
                project.priority.toLowerCase().contains(lowerQuery) ||
                project.customerNo.toLowerCase().contains(lowerQuery) ||
                project.stallNo.toLowerCase().contains(lowerQuery) ||
                project.status.toLowerCase().contains(lowerQuery) ||
                project.schStart.toLowerCase().contains(lowerQuery) ||
                project.schEnd.toLowerCase().contains(lowerQuery) ||
                project.supervisor.toLowerCase().contains(lowerQuery) ||
                project.team.toLowerCase().contains(lowerQuery);
          }).toList();
    }
    safeNotifyListeners();
  }

  void clearProjects() {
    _allProjects.clear();
    _filteredProjects.clear();
    safeNotifyListeners();
  }
}
