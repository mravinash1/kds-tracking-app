import 'package:billhosts/controller/item_complate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedItemsScreen extends StatelessWidget {
  const CompletedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompletedItemsController());


    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Completed Items",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: controller.fetchCompletedItems,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date selector
          Card(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
                      ),
                      Obx(() => Text(
                            controller.formattedDate,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2027),
                      );
                      controller.changeDate(picked);
                    },
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text("Change"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value!,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: controller.fetchCompletedItems,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Try Again"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.items.isEmpty) {
                return const Center(
                  child: Text(
                    "No completed items found for selected date",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: controller.items.length,
                itemBuilder: (context, i) {
                  final item = controller.items[i];
                  final qty =
                      (item['total_ready_qty'] as num?)?.toDouble() ?? 0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        radius: 24,
                        child: Text(
                          (i + 1).toString(),
                          style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        item['itname'] ?? '—',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${qty.toStringAsFixed(0)} pcs",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
