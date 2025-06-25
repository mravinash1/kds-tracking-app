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
    return 
    Scaffold(
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
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 46,left: 5,right: 5),

                  itemCount: controller.filterKDS.length,
                 //  itemCount: controller.roomNoList.length,
                  itemBuilder: (context, index) {
                    var data = controller.filterKDS[index];
                    return data.orders.isNotEmpty
                        ? Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Room No :${data.roomnoview}',
                                      style:  TextStyle(
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Center(
                                      child: Text(
                                    'Item Name',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  const SizedBox(height: 5),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data.orders.length,
                                    itemBuilder: (context, itemIndex) {
                                      var orderData = data.orders[itemIndex];
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          //   mainAxisSize: MainAxisSize.min,
                                          //    mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    ' ${orderData.kot.rawname} ',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    'X ${orderData.kot.qty?.toStringAsFixed(0)} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(orderData.UnitName.toString(),style: TextStyle(color: Colors.red),)
                                              ],
                                            )

                                            // SizedBox(width: 5,),
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
                                              data.orders.first.kot.kdsstatus ==
                                                      2
                                                  ? "Mark as Ready"
                                                  : "Mark as Accept",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                    ),
                                    
                                  ),

 
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
   // Printer selection button
    IconButton(
      icon: const Icon(Icons.bluetooth_searching),
      color: Colors.green,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => PrinterSelectionHotelDialog(
            printerManager: controller.printerManager,
          ),
        ).then((_) {
          controller.printerManager.scanDevices();
        });
      },
    ),
    const SizedBox(width: 10),
    // Print order button
    Obx(() {
      final isPrinting = controller.printerManager.isPrinting.value;
      return ElevatedButton(
        onPressed: isPrinting ? null : () => controller.printOrder(data),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: isPrinting
            ? const CircularProgressIndicator()
            : const Text(
                "Print Order",
                style: TextStyle(color: Colors.black, fontSize: 16),
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
              }),
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
