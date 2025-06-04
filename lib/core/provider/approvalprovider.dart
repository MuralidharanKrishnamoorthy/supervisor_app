import 'package:flutter/material.dart';
import 'package:supervisor_app/core/model/approve.dart';

import 'package:supervisor_app/core/service/networkservice.dart';

class ApprovalProvider extends ChangeNotifier {
  List<ApprovalItem> items = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchApprovalItems({
    required String docNo,
    required String stallNo,
    required String usageDate,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      items = await NetworkService().fetchApprovalItems(
        docNo: docNo,
        stallNo: stallNo,
        usageDate: usageDate,
      );
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
