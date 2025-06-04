import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor_app/core/provider/authprovider.dart';
import 'package:supervisor_app/feature/homepage/screens/homepage.dart';
import 'package:supervisor_app/feature/Auth/Screens/loginPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Make sure .env is loaded before checking its contents
    _loadEnvAndNavigate();
  }

  Future<void> _loadEnvAndNavigate() async {
    try {
      // Load the .env file
      await dotenv.load();

      // Show toast based on .env load status
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (dotenv.env.isNotEmpty) {
          FlutterToastr.show(
            ".env loaded successfully 🎉",
            context,
            duration: FlutterToastr.lengthShort,
            position: FlutterToastr.bottom,
            backgroundColor: Colors.green,
          );
        } else {
          FlutterToastr.show(
            "⚠️ .env failed to load",
            context,
            duration: FlutterToastr.lengthLong,
            position: FlutterToastr.bottom,
            backgroundColor: Colors.red,
          );
        }
      });

      // Navigate to the next screen after a short delay
      Timer(const Duration(seconds: 2), _navigateToNextScreen);
    } catch (e) {
      debugPrint("Error loading .env: $e");
      FlutterToastr.show(
        "⚠️ .env failed to load: $e",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _navigateToNextScreen() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadUserSession();

    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset('lib/images/logo.png', width: 150, height: 150),
      ),
    );
  }
}
