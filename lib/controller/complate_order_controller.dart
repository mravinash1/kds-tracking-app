import 'dart:convert';
import 'package:billhosts/constants/internet_controller.dart';
import 'package:billhosts/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompletedOrderController extends GetxController {
  var isLoading = false.obs;
  LoginController loginController = Get.put(LoginController());
  InternetController internetController = Get.put(InternetController());
  @override
  void onInit() {
    super.onInit();
    fetchCompletedOrders();
    ever(internetController.isConnected, (connected) {
      if (connected == true) {
        fetchCompletedOrders();
      }
    });
  }

  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var errorMessage = RxnString();

  var completedOrders = <int, List<Map<String, dynamic>>>{}.obs;

  final String apiUrl =
      "https://hotelserver.billhost.co.in/api/executeQuerycol";

  /// DATE PICKER
  Future<void> pickDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate.value : toDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      if (isFrom) {
        fromDate.value = picked;
      } else {
        toDate.value = picked;
      }
      fetchCompletedOrders(); // auto reload
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  /// API CALL
  Future<void> fetchCompletedOrders() async {
    if (!internetController.isConnected.value) {
      errorMessage.value = "No Internet Connection";
      return;
    }
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "sqlQuery":
              "select * from kotmas where shopid =${loginController.userId} and kotdate between '${formatDate(fromDate.value)}' and '${formatDate(toDate.value)}'"
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        processOrders(data);
      } else {
        Get.snackbar("API Error", "Status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void processOrders(List<dynamic> data) {
    completedOrders.clear();

    for (var item in data) {
      if (item['kdsstatus'] == 0) {
        int shopvno = item['shopvno'];

        completedOrders.putIfAbsent(shopvno, () => []);
        completedOrders[shopvno]!.add(
          Map<String, dynamic>.from(item),
        );
      }
    }
  }
}
