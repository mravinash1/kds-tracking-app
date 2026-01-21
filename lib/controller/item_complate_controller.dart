import 'package:billhosts/constants/internet_controller.dart';
import 'package:billhosts/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CompletedItemsController extends GetxController {
//  var selectedDate = DateTime(2026, 1, 16).obs;
  var selectedDate = DateTime.now().obs;

  var items = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();

  LoginController loginController = Get.put(LoginController());
  final InternetController internetController = Get.find<InternetController>();

  @override
  void onInit() {
    super.onInit();
    ever(internetController.isConnected, (connected) {
      if (connected == true) {
        fetchCompletedItems();
      }
    });

    fetchCompletedItems();
  }

  Future<void> changeDate(DateTime? newDate) async {
    if (newDate != null) {
      selectedDate.value = newDate;
      await fetchCompletedItems();
    }
  }

  Future<void> fetchCompletedItems() async {
    if (!internetController.isConnected.value) {
      errorMessage.value = "No Internet Connection";
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    items.clear();

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await http.post(
        Uri.parse('https://hotelserver.billhost.co.in/api/executeQuerycol'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "sqlQuery": """
          SELECT itemmas.itname, SUM(qty) AS total_ready_qty 
          FROM kotmas, itemmas 
          WHERE itemmas.id = kotmas.rawcode 
          AND kotmas.shopid = ${loginController.userId}
          AND kotmas.kotdate = '$formattedDate' 
          AND kotmas.kdsstatus = 0 
          GROUP BY itemmas.itname
        """
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          items.assignAll(data.cast<Map<String, dynamic>>());
        } else {
          errorMessage.value = 'Invalid response format';
        }
      } else {
        errorMessage.value = 'Server Error ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Network Error';
    } finally {
      isLoading.value = false;
    }
  }

  String get formattedDate =>
      DateFormat('dd MMMM yyyy').format(selectedDate.value);
}
