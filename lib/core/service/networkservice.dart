// lib/core/services/network_services.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supervisor_app/core/model/approve.dart';
import 'package:supervisor_app/core/model/ongoingworkdetail.dart';

import 'package:supervisor_app/core/model/selectteam.dart';

class NetworkService {
  final Dio dio = Dio();

  final String clientId = dotenv.env['CLIENT_ID']!;
  final String clientSecret = dotenv.env['CLIENT_SECRET']!;
  final String tenantId = dotenv.env['TENANT_ID']!;
  final String scope = dotenv.env['SCOPE']!;
  String get tokenUrl =>
      'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token';
  // ! get accesstoken from API

  Future<String?> getAccessToken() async {
    try {
      final response = await dio.post(
        tokenUrl,
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
          'scope': scope,
        },
      );

      if (response.statusCode == 200) {
        print(" Access Token: ${response.data['access_token']}");
        return response.data['access_token'];
      } else {
        print(
          " Failed to fetch token: ${response.statusCode} ${response.data}",
        );
        return null;
      }
    } catch (e) {
      print("Dio exception: $e");
      return null;
    }
  }

  // ! loginserviceman
  Future<Response?> loginServiceman({
    required String username,
    required String password,
    required String servicemanType,
  }) async {
    print(" Attempting login...");
    print(" Username: $username");
    print(" Password: $password");
    print(" Service Type: $servicemanType");

    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print(" Cannot proceed without token");
      return null;
    }

    final String loginUrl =
        'https://api.businesscentral.dynamics.com/v2.0/3c6a50d8-d57d-4dc3-91cc-47759a72545e/SandboxDev/ODataV4/ServiceApp_ServiceAuth?company=SEMBAS';

    final nestedJson = jsonEncode({
      "servicelogin": {
        "username": username,
        "password": password,
        "serviceman_type": servicemanType,
      },
    });

    final requestBody = {"servicelogin": nestedJson};

    try {
      final response = await dio.post(
        loginUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode(requestBody),
      );

      print(" Login API Response (${response.statusCode}):");
      print(response.data);

      // !After successful login, store the access token
      if (response.statusCode == 200) {
        final authBox = Hive.box('authBox');
        await authBox.put('authToken', accessToken);
      }

      return response;
    } catch (e) {
      print(" Dio exception during login request: $e");
      return null;
    }
  }

  // !getprojectbylogin Open, Processing , Approve , Reject , Assigned  status will be passed
  Future<Response?> getProjectsByLogin({
    required String loginCode,
    required String projectStatus,
  }) async {
    print(
      "🔍 Fetching projects for Login Code: $loginCode, Status: $projectStatus",
    );
    final Box authBox = Hive.box('authBox');

    final String? accessTokens = authBox.get('authToken');
    if (accessTokens == null) {
      print(" Cannot proceed without token");
      return null;
    }
    final accessToken = accessTokens;

    print("Access Token For the Project Login : $accessToken");
    final String projectUrl =
        'https://api.businesscentral.dynamics.com/v2.0/3c6a50d8-d57d-4dc3-91cc-47759a72545e/Sandboxdev/ODataV4/ServiceApp_GetProjectsByLogin?company=SEMBAS';

    // !Constructing the request body as required
    final nestedJson = jsonEncode({
      "request_body": {
        "login_code": loginCode,
        "project_status": projectStatus,
      },
    });
    final requestBody = {"par_RequestBody": nestedJson};

    try {
      final response = await Dio().post(
        projectUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode(requestBody),
      );

      print(" Project API Response (${response.statusCode}):");
      print(response.data);

      if (response.statusCode == 200) {
        print(" Projects fetched successfully!");
        return response;
      } else {
        print(
          " Failed to fetch projects: ${response.statusCode} - ${response.data}",
        );
        return null;
      }
    } catch (e) {
      print(" Dio exception during project fetch: $e");
      return null;
    }
  }

  //! getuserId
  Future<Response?> getUserById(String userId) async {
    final Box authBox = Hive.box('authBox');
    final String? accessToken = authBox.get('authToken');
    if (accessToken == null) {
      print(" Cannot proceed without token");
      return null;
    }

    final String userUrl =
        'https://api.businesscentral.dynamics.com/v2.0/3c6a50d8-d57d-4dc3-91cc-47759a72545e/Sandboxdev/ODataV4/ServiceApp_GetUserById?company=SEMBAS';

    final requestBody = {
      "par_RequestBody": jsonEncode({
        "request_body": {"user_id": userId},
      }),
    };

    try {
      final response = await dio.post(
        userUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode(requestBody),
      );

      print("📦 User API Response (${response.statusCode}):");
      print(response.data);

      if (response.statusCode == 200) {
        print(" User fetched successfully!");
        return response;
      } else {
        print(
          " Failed to fetch user: ${response.statusCode} - ${response.data}",
        );
        return null;
      }
    } catch (e) {
      print(" Dio exception during user fetch: $e");
      return null;
    }
  }
  //! getsupteamlist

  Future<List<TeamMember>> fetchSupervisorTeamList(String supervisorId) async {
    final Box authBox = Hive.box('authBox');
    final String? accessToken = authBox.get('authToken');
    if (accessToken == null) {
      print(" Cannot proceed without token");
      return [];
    }

    final String url =
        'https://api.businesscentral.dynamics.com/v2.0/3c6a50d8-d57d-4dc3-91cc-47759a72545e/Sandboxdev/ODataV4/ServiceApp_GetSupTeamList?company=Global%20Setup';

    final requestBody = {
      "par_RequestBody": jsonEncode({
        "request_body": {"driver_code": supervisorId},
      }),
    };

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('[DEBUG] Raw API response: ${response.data}');
        final rawValue = response.data['value'];
        print('[DEBUG] rawValue: $rawValue');
        final decoded = jsonDecode(rawValue);
        print('[DEBUG] decoded: $decoded');
        final List<dynamic> results = decoded['results'];
        print('[DEBUG] results: $results');
        if (results.isNotEmpty) {
          print('[DEBUG] First result: ${results[0]}');
        }
        return results.map((item) => TeamMember.fromJson(item)).toList();
      } else {
        print(" Failed to fetch team list: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print(" Exception during team fetch: $e");
      return [];
    }
  }

  Future<bool> assignWorkToBC({
    required String docNo,
    required String teamLeadNo,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Box authBox = Hive.box('authBox');
    final String? accessToken = authBox.get('authToken');
    if (accessToken == null) {
      print(" Cannot proceed without token");
      return false;
    }

    final url =
        'https://api.businesscentral.dynamics.com/v2.0/3c6a50d8-d57d-4dc3-91cc-47759a72545e/Sandboxdev/ODataV4/ServiceApp_SubmitTeamAssignment?company=SEMBAS';
    final body = {
      "par_RequestBody": jsonEncode({
        "request_body": {
          "doc_no": docNo,
          "team_lead_no": teamLeadNo,
          "project_start_date": startDate.toIso8601String().substring(0, 10),
          "project_end_date": endDate.toIso8601String().substring(0, 10),
        },
      }),
    };

    try {
      final response = await dio.post(
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
      print('[DEBUG] Assign work response: ${response.data}');
      print(
        'Assigning work: docNo=$docNo, teamLeadNo=$teamLeadNo, startDate=$startDate, endDate=$endDate, token=$accessToken',
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Exception during assign work: $e");
      return false;
    }
  }

  Future<void> fetchOngoingProjects() async {
    final Box authBox = Hive.box('authBox');
    final String? loginCode = authBox.get('loginCode');
    final response = await getProjectsByLogin(
      loginCode: loginCode ?? '',
      projectStatus: 'Ongoing',
    );
  }

  //! fetchprojectbySO
  // ! data will shown based on usage date ..
  Future<ProjectDetails?> fetchProjectDetailsBySO({
    required String docNo,
    required String stallNo,
    required String usageDate,
  }) async {
    final Box authBox = Hive.box('authBox');
    final String? accessToken = authBox.get('authToken');
    if (accessToken == null) {
      print(" Cannot proceed without token");
      return null;
    }

    final String url =
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
      print('[DEBUG] Sending request to $url');
      print('[DEBUG] Request body: $body');
      final response = await dio.post(
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

      print(" Project Details API Response (${response.statusCode}):");
      print(response.data);

      if (response.statusCode == 200) {
        final valueString = response.data['value'];
        print('[DEBUG] valueString: $valueString');
        final decodedValue = jsonDecode(valueString);
        print('[DEBUG] decodedValue: $decodedValue');
        final detailsJson = decodedValue['results']['result'];
        print('[DEBUG] detailsJson: $detailsJson');
        final details = ProjectDetails.fromJson(detailsJson);
        print('[DEBUG] Parsed ProjectDetails: $details');
        return details;
      } else {
        print(
          " Failed to fetch project details: ${response.statusCode} - ${response.data}",
        );
        return null;
      }
    } catch (e, stack) {
      print(" Dio exception during project details fetch: $e");
      print(stack);
      return null;
    }
  }
  //!fetchapprovalItem

  Future<List<ApprovalItem>> fetchApprovalItems({
    required String docNo,
    required String stallNo,
    required String usageDate,
  }) async {
    final Box authBox = Hive.box('authBox');
    final String? accessToken = authBox.get('authToken');
    if (accessToken == null) {
      throw Exception("No access token");
    }

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

    final response = await Dio().post(
      url,
      data: body,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == 200) {
      final valueString = response.data['value'];
      final decodedValue = jsonDecode(valueString);
      final result = decodedValue['results']['result'];

      final List<dynamic> itemsJson = result['service_items'] ?? [];
      return itemsJson.map((json) => ApprovalItem.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch approval items");
    }
  }
}
