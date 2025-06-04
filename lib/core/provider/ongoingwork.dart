import 'package:flutter/material.dart';

class WorkItem {
  final String itemCode;
  final String serialNum;
  final String status; // 'approved', 'resubmit', or 'pending'

  WorkItem({
    required this.itemCode,
    required this.serialNum,
    required this.status,
  });
}

class OngoingItemProvider extends ChangeNotifier {
  List<WorkItem> _allItems = [];

  List<WorkItem> get allItems => _allItems;
  List<WorkItem> get approvedItems =>
      _allItems.where((item) => item.status == 'approved').toList();
  List<WorkItem> get resubmitItems =>
      _allItems.where((item) => item.status == 'resubmit').toList();

  String selectedDate = '';

  void updateSelectedDate(DateTime date) {
    selectedDate = "${date.day}/${date.month}/${date.year}";
    notifyListeners();
  }

  Future<void> fetchItems(String orderId) async {
    // Dummy fetch data
    await Future.delayed(const Duration(seconds: 1));

    _allItems = [
      WorkItem(itemCode: 'ITEM001', serialNum: 'SN001', status: 'approved'),
      WorkItem(itemCode: 'ITEM002', serialNum: 'SN002', status: 'resubmit'),
      WorkItem(itemCode: 'ITEM003', serialNum: 'SN003', status: 'approved'),
      WorkItem(itemCode: 'ITEM004', serialNum: 'SN004', status: 'resubmit'),
      WorkItem(itemCode: 'ITEM005', serialNum: 'SN005', status: 'pending'),
    ];

    notifyListeners();
  }
}
