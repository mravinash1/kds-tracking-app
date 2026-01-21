import 'package:billhosts/constants/endpoint.dart';
import 'package:billhosts/constants/internet_controller.dart';
import 'package:billhosts/models/stock_item_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemController extends GetxController {
  final int shopId;

  ItemController(this.shopId);
  final InternetController internetController = Get.find<InternetController>();

  var items = <ItemModel>[].obs;
  var filteredItems = <ItemModel>[].obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;
  var errorMessage = RxnString();

  @override
  void onInit() {
    fetchItems();
    ever(searchQuery, (_) => applySearch());
    ever(internetController.isConnected, (connected) {
      if (connected == true) {
        fetchItems();
      }
    });

    super.onInit();
  }

  void fetchItems() async {
    if (!internetController.isConnected.value) {
      errorMessage.value = "No Internet Connection";
      isLoading(false);
      return;
    }
    try {
      isLoading(true);
      final url = '${AppConstants.baseUrl}$shopId/item';

      // final response = await http.get(
      //   Uri.parse('https://hotelserver.billhost.co.in/$shopId/item'),
      // );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(url);
        final List<dynamic> itemList = json.decode(response.body);
        items.value = itemList.map((json) => ItemModel.fromJson(json)).toList();
        filteredItems.assignAll(items);
      } else {
        //  Get.snackbar("Error", "Failed to fetch items");
        print('Failed to fetch items');
      }
    } catch (e) {
      // Get.snackbar("Error", "Something went wrong: $e");
      print('Failed to fetch items');
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleKitchenStatus(int index) async {
    final item = items[index];
    int newStatus = item.kitchenstatus == 0 ? 1 : 0;

    // final url = 'https://hotelserver.billhost.co.in/updatekitchenitem/$shopId/${item.id}/$newStatus';
    final url =
        '${AppConstants.baseUrl}updatekitchenitem/$shopId/${item.id}/$newStatus';

    print("Calling: $url");

    try {
      final response = await http.post(Uri.parse(url));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        item.kitchenstatus = newStatus;
        items[index] = item;
        items.refresh();

        applySearch();
      } else {
        Get.snackbar("Error", "Failed to update status: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    }
  }

  void applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredItems.assignAll(items);
    } else {
      filteredItems.assignAll(
        items.where((item) => item.itname
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase())),
      );
    }
  }
}
