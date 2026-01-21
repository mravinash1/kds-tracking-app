import 'package:billhosts/constants/internet_controller.dart';
import 'package:billhosts/utils/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/kds_display_controller.dart';

class ClubItemScreen extends StatefulWidget {
  const ClubItemScreen({super.key});

  @override
  State<ClubItemScreen> createState() => _ClubItemScreenState();
}

class _ClubItemScreenState extends State<ClubItemScreen> {
  late KDSDisplayController controller;
  final InternetController internetController = Get.find<InternetController>();

  @override
  void initState() {
    controller = Get.find<KDSDisplayController>();
    super.initState();
  }

  String _formatDate(String rawDate) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Obx(() {
        //  NO INTERNET
        if (!internetController.isConnected.value) {
          return const NoInternetWidget();
        }

        return GetBuilder<KDSDisplayController>(
          builder: (ctrl) {
            //  LOADING
            if (ctrl.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ⚪ EMPTY DATA
            if (ctrl.filterKDS.isEmpty ||
                ctrl.filterKDS.every((g) => g.orders.isEmpty)) {
              return const Center(
                child: Text(
                  'No Bulk Items Available',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              );
            }

            // ─────────────────────────────────────────────
            // TOTAL CLUB ITEMS CALCULATION
            // ─────────────────────────────────────────────
            final Map<String, Map<String, dynamic>> totalClubItems = {};

            for (var group in ctrl.filterKDS) {
              for (var order in group.orders) {
                final name = (order.kot.itname ?? "Unknown Item").trim();
                final comment = (order.kot.itcomment ?? "").trim();
                final key = comment.isEmpty ? name : "$name ($comment)";

                final qty = (order.kot.qty ?? 0).toInt();
                final unit = order.UnitName ?? "";
                final isCancelled = qty <= 0;

                if (totalClubItems.containsKey(key)) {
                  totalClubItems[key]!['qty'] += qty;
                  totalClubItems[key]!['cancelledCount'] +=
                      isCancelled ? qty.abs() : 0;
                } else {
                  totalClubItems[key] = {
                    'name': name,
                    'comment': comment,
                    'qty': qty,
                    'unit': unit,
                    'cancelledCount': isCancelled ? qty.abs() : 0,
                  };
                }
              }
            }

            // SORT BY QTY
            final sortedItems = totalClubItems.values.toList()
              ..sort((a, b) => (b['qty'] as int).compareTo(a['qty'] as int));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Card(
                    color: Colors.green[50],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Bulk Items - Total Summary',
                              style: TextStyle(
                                fontSize: textScale * 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'All club orders combined (${_formatDate(DateTime.now().toString())})',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: textScale * 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ITEMS LIST
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: sortedItems.map((item) {
                          final name = item['name'] as String;
                          final qty = item['qty'] as int;
                          final unit = item['unit'] as String;
                          final cancelled = item['cancelledCount'] as int;
                          final netQty = qty - cancelled;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: textScale * 16.5,
                                          fontWeight: FontWeight.w600,
                                          color: netQty > 0
                                              ? Colors.black87
                                              : Colors.grey[700],
                                        ),
                                      ),
                                      if (item['comment'].toString().isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            item['comment'].toString(),
                                            style: TextStyle(
                                              color: Colors.red[700],
                                              fontSize: textScale * 14,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '× $qty',
                                      style: TextStyle(
                                        fontSize: textScale * 17,
                                        fontWeight: FontWeight.bold,
                                        color: netQty > 0
                                            ? Colors.black
                                            : Colors.red[800],
                                      ),
                                    ),
                                    if (cancelled > 0)
                                      Text(
                                        '($cancelled Cancelled)',
                                        style: TextStyle(
                                          fontSize: textScale * 13,
                                          color: Colors.red[800],
                                        ),
                                      ),
                                    Text(
                                      unit,
                                      style: TextStyle(
                                        fontSize: textScale * 14,
                                        color: Colors.red[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
