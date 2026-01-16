import 'package:billhosts/controller/hotel_screen_controller.dart';
import 'package:billhosts/utils/printer_selection_hotel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<HotelScreen> {
  late HotelDisplayController controller;

  @override
  void initState() {
    controller = Get.put(HotelDisplayController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[100]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: GetBuilder<HotelDisplayController>(
            init: controller,
            builder: (context) {
              // Show "No service available" when there's no data
              if (controller.filterKDS.isEmpty) {
                return const Center(
                  child: Text(
                    'No service available',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 46, left: 5, right: 5),
                itemCount: controller.filterKDS.length,
                itemBuilder: (context, index) {
                  var data = controller.filterKDS[index];
                  return data.orders.isNotEmpty
                      ? Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side:
                                const BorderSide(color: Colors.green, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Room No :${data.roomnoview}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Date: ${_formatDate(data.orders.first.kot.orddate.toString())}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Time : ${data.orders.first.kot.ordtime} ',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Center(
                                    child: Text(
                                  'Item Name',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                                const SizedBox(height: 5),

                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   physics: const NeverScrollableScrollPhysics(),
                                //   itemCount: data.orders.length,
                                //   itemBuilder: (context, itemIndex) {
                                //     var orderData = data.orders[itemIndex];
                                //     return Container(
                                //       padding: const EdgeInsets.symmetric(
                                //         vertical: 4,
                                //         horizontal: 10,
                                //       ),
                                //       child: Column(
                                //         children: [
                                //           Row(
                                //             children: [
                                //               Expanded(
                                //                 child: Text(
                                //                   ' ${orderData.kot.rawname} ',
                                //                   style: const TextStyle(
                                //                       fontSize: 14,
                                //                       fontWeight:
                                //                           FontWeight.bold),
                                //                 ),
                                //               ),
                                //               const SizedBox(height: 5),
                                //               Padding(
                                //                 padding:
                                //                     const EdgeInsets.all(4.0),
                                //                 child: Text(
                                //                   'X ${orderData.kot.qty?.toStringAsFixed(0)} ',
                                //                   style: const TextStyle(
                                //                       fontSize: 15,
                                //                       fontWeight:
                                //                           FontWeight.bold),
                                //                 ),
                                //               ),
                                //               Text(orderData.UnitName ?? '',
                                //                   style: TextStyle(
                                //                       color: Colors.red))
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 orderData.kot.serviceremarks
                                //                     .toString(),
                                //                 style: const TextStyle(
                                //                     color: Colors.red,
                                //                     fontWeight:
                                //                         FontWeight.bold),
                                //                 textAlign: TextAlign.right,
                                //               ),
                                //             ],
                                //           )
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.orders.length,
                                  itemBuilder: (context, itemIndex) {
                                    var orderData = data.orders[itemIndex];

                                    // Item ready ya cancelled check
                                    bool isItemReady =
                                        orderData.kot.isItemReady ||
                                            (orderData.kot.kdsstatus
                                                    ?.toString()
                                                    .toLowerCase()
                                                    .contains('ready') ??
                                                false);

                                    bool isCancelled =
                                        (orderData.kot.qty ?? 0) == 0 ||
                                            (orderData.kot.kdsstatus
                                                    ?.toString()
                                                    .toLowerCase()
                                                    .contains('cancel') ??
                                                false);

                                    // Order ready phase check (button sirf tab dikhe jab order ready ho)
                                    bool isOrderReadyPhase =
                                        (data.orders.first.kot.kdsstatus ==
                                                2) ||
                                            (data.orders.first.kot.kdsstatus
                                                    ?.toString()
                                                    .toLowerCase()
                                                    .contains('ready') ??
                                                false);

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: isItemReady
                                            ? Colors.green.shade50
                                            : null,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Item name + remarks
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  orderData.kot.rawname ??
                                                      "Unknown Item",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: isItemReady ||
                                                            isCancelled
                                                        ? Colors.grey.shade700
                                                        : Colors.black87,
                                                    decoration: isItemReady ||
                                                            isCancelled
                                                        ? TextDecoration.none
                                                        : null,
                                                  ),
                                                ),
                                                if (orderData.kot.serviceremarks
                                                        ?.isNotEmpty ??
                                                    false)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2),
                                                    child: Text(
                                                      orderData
                                                          .kot.serviceremarks
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:
                                                            Colors.red.shade700,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),

                                          // Right side: Status / Button / Qty / Unit
                                          if (isItemReady)
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12),
                                              child: Icon(Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 26),
                                            )
                                          else if (isCancelled)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Text(
                                                "Cancelled",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            )
                                          else if (isOrderReadyPhase)
                                            // READY button sirf ready phase mein
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  controller
                                                      .markSingleHotelItemAsReady(
                                                    shopNumber: data.orders
                                                        .first.kot.shopvno!
                                                        .toInt(),
                                                    rawcode: orderData
                                                            .kot.rawcode
                                                            ?.toString() ??
                                                        '',
                                                    groupIndex: index,
                                                    itemIndex: itemIndex,
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green.shade700,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 1,
                                                      vertical: 0),
                                                  minimumSize:
                                                      const Size(80, 30),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                                child: const Text(
                                                  "Ready",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          else
                                            // Accept phase mein button nahi dikhega
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                    color:
                                                        Colors.orange.shade800,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              ),
                                            ),

                                          // Qty (sirf pending items pe)
                                          if (!isItemReady && !isCancelled)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Text(
                                                '× ${(orderData.kot.qty ?? 0).toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),

                                          // Unit
                                          Text(
                                            orderData.UnitName ?? '',
                                            style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (data.orders.first.kot.kdsstatus ==
                                          1) {
                                        controller.updateOrderStatus(
                                            shopNumber: data
                                                .orders.first.kot.shopvno!
                                                .toInt(),
                                            status: 2,
                                            orderIndex: index);
                                      } else {
                                        controller.updateOrderStatus(
                                            shopNumber: data
                                                .orders.first.kot.shopvno!
                                                .toInt(),
                                            status: 0,
                                            orderIndex: index);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          data.orders.first.kot.kdsstatus == 2
                                              ? Colors.yellow
                                              : Colors.green,
                                    ),
                                    child: data.orders.first.kot.isLoading
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.black))
                                        : Text(
                                            data.orders.first.kot.kdsstatus == 2
                                                ? "Mark as Ready"
                                                : "Mark as Accept",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Printer selection button
                                    IconButton(
                                      icon:
                                          const Icon(Icons.bluetooth_searching),
                                      color: Colors.green,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              PrinterSelectionHotelDialog(
                                            printerManager:
                                                controller.printerManager,
                                          ),
                                        ).then((_) {
                                          controller.printerManager
                                              .scanDevices();
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    // Print order button
                                    Obx(() {
                                      final isPrinting = controller
                                          .printerManager.isPrinting.value;
                                      return ElevatedButton(
                                        onPressed: isPrinting
                                            ? null
                                            : () => controller.printOrder(data),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                        ),
                                        child: isPrinting
                                            ? const CircularProgressIndicator()
                                            : const Text(
                                                "Print Order",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Function to format date
  String _formatDate(String rawDate) {
    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }
}
