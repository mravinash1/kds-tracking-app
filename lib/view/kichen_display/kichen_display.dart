import 'package:billhosts/constants/internet_controller.dart';
import 'package:billhosts/utils/no_internet.dart';
import 'package:billhosts/utils/printer_selection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/kds_display_controller.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late KDSDisplayController controller;
  InternetController internetController = Get.put(InternetController());

  @override
  void initState() {
    controller = Get.put(KDSDisplayController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Obx(() {
      if (!internetController.isConnected.value) {
        return const NoInternetWidget();
      }

      return Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[100]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: GetBuilder<KDSDisplayController>(
            init: controller,
            builder: (context) {
              if (controller.isLoading) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filterKDS.isEmpty) {
                Text('No service Available');
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 45, left: 1, right: 1),
                itemCount: controller.shopNoList.length,
                itemBuilder: (context, index) {
                  var data = controller.filterKDS[index];

                  if (data.orders.isNotEmpty) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(color: Colors.green.shade800, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // KOT Number

                            //  Center(
                            //  child: Text(
                            //     'KOT No: ${data.orders.first.kot.shopvno}',
                            //     style: TextStyle(
                            //       fontSize: textScale * 18,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.green.shade800,
                            //     ),
                            //   ),
                            // ),
                            Center(
                              child: Text(
                                // Show dailykotno if dayCloseType is 1, otherwise show shopvno
                                controller.dayCloseType == 1
                                    ? 'KOT No: ${data.orders.first.kot.dailykotno ?? data.orders.first.kot.shopvno}'
                                    : 'KOT No: ${data.orders.first.kot.shopvno}',
                                style: TextStyle(
                                  fontSize: textScale * 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                            const Divider(),

                            //  if(data.orders.first.kot.status ==2)
                            // Center(child: Text('Order Cancelled  ',style: TextStyle(color: Colors.red,
                            // fontWeight: FontWeight.bold,fontSize: 17),)),

                            if (data.orders.first.kot.status == 2)
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Order Cancelled',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 6,
                            ),

                            // Date & Time Row

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date: ${_formatDate(data.orders.first.kot.kotdate.toString())}',
                                  style: TextStyle(
                                      fontSize: textScale * 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Time: ${data.orders.first.kot.kottime}',
                                  style: TextStyle(
                                      fontSize: textScale * 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),

                            // Type, Table, Waiter
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data.orders.first.kottypeName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Icon(
                                          Icons.table_bar,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data.orders.first.kot.tablename
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                  Text(
                                      'Waiter : ${data.orders.first.kot.wname.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                            ),

                            const Divider(),

                            // Items List Header
                            Center(
                              child: Text(
                                'Order Items',
                                style: TextStyle(
                                  fontSize: textScale * 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.orders.length,
                              itemBuilder: (context, index1) {
                                var orderData = data.orders[index1];

                                // Determine item status
                                bool isItemReady = orderData.kot.isItemReady ||
                                    (orderData.kot.kdsstatus
                                            ?.toString()
                                            .toLowerCase()
                                            .contains('ready') ??
                                        false);

                                bool isCancelled = orderData.kot.qty == 0 ||
                                    (orderData.kot.kdsstatus
                                            ?.toString()
                                            .toLowerCase()
                                            .contains('cancel') ??
                                        false);

                                bool isOrderReadyPhase =
                                    (data.orders.first.kot.kdsstatus == 2) ||
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
                                      // Left: Item name + comment + pack info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              orderData.kot.itname ??
                                                  "Unknown Item",
                                              style: TextStyle(
                                                fontSize: textScale * 16,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    isItemReady || isCancelled
                                                        ? Colors.grey.shade700
                                                        : Colors.black87,
                                                decoration:
                                                    isItemReady || isCancelled
                                                        ? TextDecoration.none
                                                        : null,
                                                decorationColor: Colors.red,
                                                decorationThickness: 2,
                                              ),
                                            ),
                                            if (orderData.kot.itcomment
                                                    ?.isNotEmpty ??
                                                false)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  orderData.kot.itcomment!,
                                                  style: TextStyle(
                                                    color: Colors.red.shade700,
                                                    fontSize: textScale * 13.5,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            if (orderData.kot.havetopack == 1)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  "Have to Pack",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.orange.shade800,
                                                    fontSize: textScale * 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Right side: Status / Button / Qty / Unit
                                      if (isItemReady)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 12),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 28,
                                          ),
                                        )
                                      else if (isCancelled)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: Text(
                                            "Cancelled",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: textScale * 14,
                                            ),
                                          ),
                                        )
                                      else if (isOrderReadyPhase)
                                        // Only show READY button when order is in ready phase
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              controller.markSingleItemAsReady(
                                                shopNumber: data.shopvno!,
                                                rawcode: orderData.kot.rawcode
                                                        ?.toString() ??
                                                    '',
                                                groupIndex: index,
                                                itemIndex: index1,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green.shade700,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 0),
                                              minimumSize: const Size(80, 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              "Ready",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        // In accept/pending phase → show status text instead of button
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                              color: Colors.orange.shade800,
                                              fontWeight: FontWeight.w600,
                                              fontSize: textScale * 14,
                                            ),
                                          ),
                                        ),

                                      // Quantity (only show if not ready/cancelled)
                                      if (!isItemReady && !isCancelled)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            '× ${orderData.kot.qty?.toStringAsFixed(0) ?? "?"}',
                                            style: TextStyle(
                                              fontSize: textScale * 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),

                                      // Unit
                                      Text(
                                        orderData.UnitName ?? '',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: textScale * 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            //const SizedBox(height: 10),

                            // Accept / Ready Button

                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (data.orders.first.kot.status == 2) {
                                    Get.snackbar(
                                      'Cancel',
                                      'Order cancelled ',
                                      backgroundColor: Colors.red,
                                    );
                                  } else if (data.orders.first.kot.kdsstatus ==
                                      1) {
                                    controller.updateOrderStatus(
                                      shopNumber:
                                          data.orders.first.kot.shopvno!,
                                      status: 2,
                                      orderIndex: index,
                                    );
                                  } else {
                                    controller.updateOrderStatus(
                                      shopNumber:
                                          data.orders.first.kot.shopvno!,
                                      status: 0,
                                      orderIndex: index,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      data.orders.first.kot.kdsstatus == 2
                                          ? Colors.yellow[400]
                                          : Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
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
                                            color: Colors.black, fontSize: 16),
                                      ),
                              ),
                            ),

                            SizedBox(
                              height: 4,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Printer selection button
                                IconButton(
                                  icon: const Icon(
                                    Icons.bluetooth_searching,
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          PrinterSelectionDialog(
                                        printerManager:
                                            controller.printerManager,
                                      ),
                                    ).then((_) {
                                      controller.printerManager.scanDevices();
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
                                        borderRadius: BorderRadius.circular(8),
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
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          ),
        ),
      );
    }));
  }
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
