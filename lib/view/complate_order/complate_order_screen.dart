import 'package:billhosts/constants/internet_controller.dart';
import 'package:billhosts/controller/complate_order_controller.dart';
import 'package:billhosts/utils/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedOrderScreen extends StatelessWidget {
  CompletedOrderScreen({super.key});

  final controller = Get.put(CompletedOrderController());
  final internetController = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Completed Orders")),
        body: Obx(() {
          if (!internetController.isConnected.value) {
            return const NoInternetWidget();
          }

          return Column(
            children: [
              /// DATE PICKERS
              Obx(() => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => controller.pickDate(context, true),
                            child: Text(
                              "From: ${controller.formatDate(controller.fromDate.value)}",
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                controller.pickDate(context, false),
                            child: Text(
                              "To: ${controller.formatDate(controller.toDate.value)}",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

              /// LIST
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.completedOrders.isEmpty) {
                    return const Center(child: Text("No Completed Orders"));
                  }

                  return ListView(
                    children: controller.completedOrders.entries.map((entry) {
                      final shopvno = entry.key;
                      final items = entry.value;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          title: Text(
                            "Order No: $shopvno | Items: ${items.length}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: items.map((item) {
                            return ListTile(
                              leading: const Icon(Icons.table_bar),
                              title: Text(item['itname']),
                              subtitle: Text("Table: ${item['tablename']}"),
                              trailing: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ],
          );
        }));
  }
}
