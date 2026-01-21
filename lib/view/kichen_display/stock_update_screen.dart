import 'package:billhosts/constants/internet_controller.dart';
import 'package:billhosts/controller/stock_item_controller.dart';
import 'package:billhosts/utils/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemListScreen extends StatelessWidget {
  final int shopId;

  ItemListScreen({required this.shopId});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.put(ItemController(shopId));
    final InternetController internetController =
        Get.find<InternetController>();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title:
              Text("Items Stock Update", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (!internetController.isConnected.value) {
            return const NoInternetWidget();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search Item",
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) =>
                      itemController.searchQuery.value = value,
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (itemController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: itemController.filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = itemController.filteredItems[index];
                      return Card(
                        color: Colors.black,
                        child: ListTile(
                          title: Text(item.itname,
                              style: TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Text(
                              //   item.kitchenstatus == 1 ? "Disabled" : "Active",
                              //   style: TextStyle(color: Colors.white),
                              // ),

                              // Switch(
                              //   value: item.kitchenstatus == 0,
                              //   onChanged: (_) {
                              //     itemController.toggleKitchenStatus(index);
                              //   },
                              //   activeColor: Colors.green,
                              //   inactiveThumbColor: Colors.red,
                              // ),

                              Text(
                                item.kitchenstatus == 1 ? "Disabled" : "Active",
                                style: TextStyle(color: Colors.white),
                              ),

                              Switch(
                                value: item.kitchenstatus == 0,
                                onChanged: (_) {
                                  // Search by ID in full list to get the correct index
                                  final originalIndex = itemController.items
                                      .indexWhere((e) => e.id == item.id);
                                  if (originalIndex != -1) {
                                    itemController
                                        .toggleKitchenStatus(originalIndex);
                                  }
                                },
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }));
  }
}
