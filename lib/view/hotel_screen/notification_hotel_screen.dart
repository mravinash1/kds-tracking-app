import 'package:billhosts/controller/hotel_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

  class NotificationHotelScreen extends StatefulWidget {
  const NotificationHotelScreen({super.key});

  @override
  State<NotificationHotelScreen> createState() => _NotificationHotelScreenState();
}


  class _NotificationHotelScreenState extends State<NotificationHotelScreen> {
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
      appBar: AppBar(
        title: Text('Room Services',style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,
      backgroundColor: Colors.green,

        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
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
                  padding: const EdgeInsets.only(bottom: 45,left: 5,right: 5),
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
                                      'Room No : ${data.roomnoview}',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
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
                                                    'X: ${orderData.kot.qty?.toStringAsFixed(0)} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
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
                                  )
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