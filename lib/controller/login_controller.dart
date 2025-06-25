import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/login_screen.dart';
import '../view/main_screen.dart';

 class LoginController extends GetxController {
  int userId = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginData() async {
    isLoading = true;
    update();

    try {
      final fcmtoken = await getFcmToken();

      var url = Uri.parse("https://hotelserver.billhost.co.in/login");

      var body = jsonEncode({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "fcmtoken": fcmtoken ?? "",
      });

      var headers = {'Content-Type': 'application/json'};

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["id"] != null) {
          userId = data["id"];
          String cname = data["cname"] ?? "";
          String? token = data["fcmtoken"];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setInt('userId', userId);
          await prefs.setString('cname', cname);
          await prefs.setString('fcmtoken', token ?? '');

          Get.to(() =>  MainScreen());

          Get.snackbar(
            'Success',
            'Login successful',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar(
            'Login Failed',
            'Invalid username or password',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Server error: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Exception',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<String?> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (Platform.isIOS || Platform.isAndroid || Platform.isWindows ) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('❌ Notification permission denied');
        return null;
      }
    }

    String? token = await messaging.getToken();
    print("✅ FCM Token: $token");
    return token;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => const LoginScreen());
  }
}
