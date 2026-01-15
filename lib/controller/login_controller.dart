import 'dart:convert';
import 'package:billhosts/constants/endpoint.dart';
import 'package:billhosts/view/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:billhosts/view/main_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  int userId = 0;
  int dayCloseType = 0;

  String loginRole = 'Admin';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void setLoginRole(String value) {
    loginRole = value;
    update();
  }

  Future<void> loginData() async {
    isLoading = true;
    update();

    try {
      final fcmtoken = await getFcmToken();

      Uri url;
      Map<String, dynamic> body;

      if (loginRole == 'Admin') {
        // url = Uri.parse("https://hotelserver.billhost.co.in/login");

        url = Uri.parse("${AppConstants.baseUrl}login");
        body = {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "fcmtoken": fcmtoken ?? "",
        };
      } else {
        // url = Uri.parse("https://hotelserver.billhost.co.in/UserLogin");
        url = Uri.parse('${AppConstants}UserLogin');

        body = {
          "narration": emailController.text.trim(), // narration as email
          "password": passwordController.text.trim(),
          "fcmtoken": fcmtoken ?? "",
        };
      }

      var headers = {'Content-Type': 'application/json'};
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["id"] != null) {
          userId = data["id"];
          String cname = data["cname"] ?? data["username"] ?? "";
          String? token = data["fcmtoken"];
          dayCloseType = data["dayclosetype"] ?? 0; // Store dayclosetype

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setInt('userId', userId);
          await prefs.setString('cname', cname);
          await prefs.setString('fcmtoken', token ?? '');
          await prefs.setString('loginRole', loginRole);
          await prefs.setInt(
              'dayCloseType', dayCloseType); // Save to shared preferences

          Get.to(() => MainScreen());

          Get.snackbar('Success', 'Login successful',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        } else {
          Get.snackbar('Login Failed', 'Invalid credentials',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Exception', 'Something went wrong: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<String?> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print(' Notification permission denied');
      return null;
    }

    String? token = await messaging.getToken();
    print(" FCM Token: $token");
    return token;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => const LoginScreen());
  }

// Add method to get dayCloseType

  Future<int> getDayCloseType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('dayCloseType') ?? 0;
  }
}
