import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/newproject.dart';
import '../service/networkservice.dart';

class ProjectProvider with ChangeNotifier {
  final NetworkService _networkService = NetworkService();

  List<Project> _allProjects = [];
  List<Project> _filteredProjects = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Project> get projects => _filteredProjects;

  ProjectProvider() {
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    _isLoading = true;
    notifyListeners();

    final Box authBox = Hive.box('authBox');
    final String? loginCode = authBox.get('loginCode');

    if (loginCode == null) {
      print("⚠️ No loginCode found.");
      _isLoading = false;
      return;
    }

    final response = await _networkService.getProjectsByLogin(
      loginCode: loginCode,
      projectStatus: 'Open',
    );

    if (response != null && response.statusCode == 200) {
      try {
        final rawValue = response.data['value'];
        final decoded = jsonDecode(rawValue);
        final List<dynamic> serviceOrders =
            decoded['results']['result']['service_orders'];

        _allProjects =
            serviceOrders.map((json) => Project.fromJson(json)).toList();
        _filteredProjects = _allProjects;
      } catch (e) {
        print("❌ Parsing error: $e");
        _allProjects = [];
        _filteredProjects = [];
      }
    } else {
      print("❌ Failed to fetch projects");
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchProjects(String query) {
    if (query.isEmpty) {
      _filteredProjects = _allProjects;
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredProjects =
          _allProjects.where((project) {
            return project.customerName.toLowerCase().contains(lowerQuery) ||
                project.address.toLowerCase().contains(lowerQuery) ||
                project.id.toLowerCase().contains(lowerQuery);
          }).toList();
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchUserById(String userId) async {
    final response = await _networkService.getUserById(userId);
    if (response != null && response.statusCode == 200) {
      try {
        final rawValue = response.data['value']; // JSON string
        final decoded = jsonDecode(rawValue); // Now a Map

        final user = decoded['results']['result']['user'];
        return user;
      } catch (e) {
        print("❌ User parsing error: $e");
        return null;
      }
    } else {
      print("❌ Failed to fetch user");
      return null;
    }
  }
}
