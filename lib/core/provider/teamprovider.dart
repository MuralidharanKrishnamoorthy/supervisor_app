// teamprovider.dart
import 'package:flutter/material.dart';
import '../model/selectteam.dart';
import '../service/networkservice.dart';

class TeamProvider extends ChangeNotifier {
  final NetworkService _networkService = NetworkService();

  List<TeamMember> _team = [];
  bool _isLoading = false;
  bool _disposed = false; // Add this

  List<TeamMember> get team => _team;
  bool get isLoading => _isLoading;

  TeamProvider(String supervisorId) {
    fetchTeam(supervisorId);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> fetchTeam(String supervisorId) async {
    print('[DEBUG] fetchTeam called with supervisorId: $supervisorId');
    _isLoading = true;
    if (!_disposed) notifyListeners();
    _team = await _networkService.fetchSupervisorTeamList(supervisorId);
    print('[DEBUG] Team fetched: ${_team.length} members');
    if (_team.isNotEmpty) {
      print('[DEBUG] First team member: ${_team[0].driverName}');
    }
    _isLoading = false;
    if (!_disposed) notifyListeners();
  }

  void toggleSelection(int index) {
    _team[index].isSelected = !_team[index].isSelected;
    if (!_disposed) notifyListeners();
  }
}
