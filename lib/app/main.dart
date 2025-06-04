import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:supervisor_app/core/provider/ContractProvider.dart';
import 'package:supervisor_app/core/provider/addworkerprovider.dart';
import 'package:supervisor_app/core/provider/authprovider.dart';
import 'package:supervisor_app/core/provider/newproject.dart';
import 'package:supervisor_app/core/provider/ongoingwork.dart';
import 'package:supervisor_app/feature/AddWorker/screens/addworker.dart';
import 'package:supervisor_app/splashscreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open necessary Hive boxes
  await Hive.openBox('authBox');
  await Hive.openBox('userBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => ContractProvider()),
        ChangeNotifierProvider(create: (_) => ServiceOrderProvider()),
        ChangeNotifierProvider(create: (_) => OngoingItemProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Supervisor App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
        routes: {'/addworker': (context) => const Addworker()},
      ),
    );
  }
}
