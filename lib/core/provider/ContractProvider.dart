import 'package:flutter/material.dart';
import 'package:supervisor_app/core/model/ContractAddressModel.dart';

class ContractProvider extends ChangeNotifier {
  final List<ContractAddress> _allContracts = [
    ContractAddress(
      contractNo: "WO-10001",
      address: "#05-02 Marina Bay Financial Centre, Singapore 018981",
    ),
    ContractAddress(
      contractNo: "WO-10002",
      address: "3 Temasek Avenue, #21-00 Centennial Tower, Singapore 039190",
    ),
    ContractAddress(
      contractNo: "WO-10003",
      address: "1 Raffles Place, #44-02 One Raffles Place Tower 1, Singapore 048616",
    ),
    ContractAddress(
      contractNo: "WO-10004",
      address: "138 Market Street, #32-01 CapitaGreen, Singapore 048946",
    ),
  ];

  List<ContractAddress> _filteredContracts = [];
  int? _selectedIndex;

  ContractProvider() {
    _filteredContracts = _allContracts;
  }

  List<ContractAddress> get contracts => _filteredContracts;
  int? get selectedIndex => _selectedIndex;

  void search(String query) {
    if (query.trim().isEmpty) {
      _filteredContracts = _allContracts;
    } else {
      _filteredContracts = _allContracts
          .where((contract) =>
              contract.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    _selectedIndex = null;
    notifyListeners();
  }

  void selectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  ContractAddress? get selectedContract =>
      _selectedIndex != null ? _filteredContracts[_selectedIndex!] : null;
}
