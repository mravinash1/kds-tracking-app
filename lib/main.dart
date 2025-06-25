import 'package:billhosts/controller/kds_display_controller.dart';
import 'package:billhosts/firebase_options.dart';
import 'package:billhosts/utils/bluetooth_printer_helper.dart';
import 'package:billhosts/utils/notification_services.dart';
import 'package:billhosts/view/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


    void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService.init(); // Initialize notifications
    await requestNotificationPermission();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
    BindingsBuilder(() {
      Get.put(KDSDisplayController());
      Get.put(BluetoothPrinterManager());
    });
    
     SharedPreferences prefs = await SharedPreferences.getInstance();
     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
  }
  
  class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BillHost_KDS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? MainScreen() : LoginScreen(),
    );
   }
 }

