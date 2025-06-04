import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:supervisor_app/core/model/ongoingworkdetail.dart';

class ProjectDetailsProvider extends ChangeNotifier {
  ProjectDetails? details;
  bool isLoading = false;
  String? error;

  Future<void> fetchProjectDetails({
    required String docNo,
    required String stallNo,
    required String usageDate,
    required String accessToken,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final url =
        'https://api.businesscentral.dynamics.com/v2.0/3c6a50d8-d57d-4dc3-91cc-47759a72545e/Sandboxdev/ODataV4/ServiceApp_GetProjectDetailsbySO?company=SEMBAS';

    final body = {
      "par_RequestBody": jsonEncode({
        "request_body": {
          "doc_no": docNo,
          "stall_no": stallNo,
          "usage_date": usageDate,
        },
      }),
    };

    try {
      final response = await Dio().post(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('[DEBUG] API response: ${response.data}');

      if (response.statusCode == 200) {
        final valueString = response.data['value'];
        final decodedValue = jsonDecode(valueString);
        final detailsJson = decodedValue['results']['result'];
        details = ProjectDetails.fromJson(detailsJson);
        print('[DEBUG] Parsed ProjectDetails: $details');
      } else {
        error = 'Failed: ${response.statusCode}';
        print(
          '[ERROR] Failed to fetch: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      error = e.toString();
      print('[ERROR] Exception: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
