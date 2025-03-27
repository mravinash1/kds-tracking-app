import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login_screen.dart';

  void main() {
  runApp(const MyApp());
  }
  
  class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BillHost_KDS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen()
    );
   }
 }
