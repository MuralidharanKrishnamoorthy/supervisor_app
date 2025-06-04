import 'package:flutter/material.dart';
import 'package:supervisor_app/core/model/addworker.dart';

class ServiceOrderProvider with ChangeNotifier {
  final List<ServiceOrderModel> _allOrders = [
    ServiceOrderModel(
      svoNumber: "716465",
      priority: "High",
      startDate: DateTime(2024, 4, 3),
      endDate: DateTime(2024, 4, 3),
      customerName: "dharanee",
      phone: "1234569876",
      address: "CapitaGreen, Singapore 048947",
    ),
    ServiceOrderModel(
      svoNumber: "7670756",
      priority: "Normal",
      startDate: DateTime(2024, 4, 3),
      endDate: DateTime(2024, 4, 3),
      customerName: "Ah tan",
      phone: "56354635435",
      address: "138 Market Street, Singapore 048947",
    ),
  ];

  List<ServiceOrderModel> _filteredOrders = [];

  ServiceOrderProvider() {
    _filteredOrders = _allOrders;
  }

  List<ServiceOrderModel> get orders => _filteredOrders;

  void searchOrders(String query) {
    if (query.isEmpty) {
      _filteredOrders = _allOrders;
    } else {
      _filteredOrders =
          _allOrders.where((order) {
            return order.address.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }
    notifyListeners();
  }
}
