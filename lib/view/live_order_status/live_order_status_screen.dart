import 'package:billhosts/controller/kds_display_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LiveOrderStatusScreen extends StatefulWidget {
  const LiveOrderStatusScreen({super.key});

  @override
  State<LiveOrderStatusScreen> createState() => _LiveOrderStatusScreenState();
}

class _LiveOrderStatusScreenState extends State<LiveOrderStatusScreen> {
  late KDSDisplayController controller;

  @override
  void initState() {
    controller = Get.put(KDSDisplayController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Live Order Status',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GetBuilder<KDSDisplayController>(
          init: controller,
          builder: (_) {
            if (controller.filterKDS.isEmpty) {
              return const Center(
                child: Text(
                  'No service available',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: controller.filterKDS.length,
              itemBuilder: (context, index) {
                var data = controller.filterKDS[index];

                if (data.orders.isEmpty) return const SizedBox();

                final kot = data.orders.first.kot;

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: kot.kdsstatus == 1 ? Colors.green : Colors.orange,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ORDER NUMBER
                        Center(
                          child: Text(
                            'Order No: ${kot.shopvno}',
                            style: TextStyle(
                              fontSize: textScale * 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),

                        const Divider(),

                        /// CANCELLED STATUS
                        if (kot.status == 2)
                          const Center(
                            child: Text(
                              'Order Cancelled',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                        const SizedBox(height: 8),

                        /// ORDER TYPE TITLE
                        const Center(
                          child: Text(
                            'Order Type',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// TYPE / TABLE / WAITER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.orders.first.kottypeName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.table_bar),
                                const SizedBox(width: 4),
                                Text(
                                  kot.tablename.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              'Waiter: ${kot.wname}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// ACTION TITLE
                        const Center(
                          child: Text(
                            'Action',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// LIVE STATUS BADGE
                        Center(child: orderStatusBadge(kot.kdsstatus)),

                        const Divider(height: 30),

                        /// ITEMS HEADER
                        Center(
                          child: Text(
                            'Order Items',
                            style: TextStyle(
                                fontSize: textScale * 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// ITEMS LIST
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.orders.length,
                          itemBuilder: (context, i) {
                            var item = data.orders[i].kot;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.itname.toString(),
                                          style: TextStyle(
                                            fontSize: textScale * 15,
                                            fontWeight: FontWeight.bold,
                                            color: item.qty == 0
                                                ? Colors.red
                                                : Colors.black,
                                            decoration: item.qty == 0
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.qty == 0
                                            ? 'Cancel'
                                            : 'X ${item.qty?.toStringAsFixed(0)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: item.qty == 0
                                                ? Colors.red
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (item.itcomment != null &&
                                          item.itcomment!.isNotEmpty)
                                        Text(
                                          item.itcomment!,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      if (item.havetopack == 1)
                                        const Text(
                                          'Have to Pack',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// LIVE STATUS BADGE WIDGET
  Widget orderStatusBadge(int status) {
    final bool isPending = status == 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isPending
            ? Colors.green.withOpacity(0.15)
            : Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isPending ? Colors.green : Colors.orange,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPending ? Icons.access_time : Icons.local_fire_department,
            color: isPending ? Colors.green : Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            isPending ? 'Pending' : 'Processing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPending ? Colors.green : Colors.orange,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  /// DATE FORMAT
  String _formatDate(String rawDate) {
    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (_) {
      return rawDate;
    }
  }
}
