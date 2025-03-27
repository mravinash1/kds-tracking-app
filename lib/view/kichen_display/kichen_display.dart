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

  @override
    void initState() {
    controller = Get.put(KDSDisplayController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // ignore: deprecated_member_use
    double textScale = MediaQuery.of(context).textScaleFactor;

     return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade100, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: GetBuilder<KDSDisplayController>(
            init: controller,
            builder: (context) {
              return ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: controller.shopNoList.length,
                itemBuilder: (context, index) {
                  var data = controller.filterKDS[index];

                  if (data.orders.isNotEmpty) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.green.shade800, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // KOT Number

                             Center(
                             child: Text(
                                'KOT No: ${data.orders.first.kot.shopvno}',
                                style: TextStyle(
                                  fontSize: textScale * 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                            const Divider(),

                            // Date & Time Row

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date: ${_formatDate(data.orders.first.kot.kotdate.toString())}',
                                  style: TextStyle(fontSize: textScale * 15, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Time: ${data.orders.first.kot.kottime}',
                                  style: TextStyle(fontSize: textScale * 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 6,),

                            // Type, Table, Waiter
                              Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                               Text(data.orders.first.kottypeName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                              
                              
                              
                                Row(
                                children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: Icon(Icons.table_bar,color: Colors.black,),
                                ),
                                SizedBox(width: 5,),
                                Text(data.orders.first.kot.tablename.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                                 ],
                                 ),
                              
                                Text('Waiter : ${data.orders.first.kot.wname.toString()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              
                                ],
                              ),
                            ),

                            const Divider(),

                            // Items List Header
                            Center(
                              child: Text(
                                'Order Items',
                                style: TextStyle(fontSize: textScale * 17, fontWeight: FontWeight.bold),
                              ),
                            ),



                            // Items List
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.orders.length,
                              itemBuilder: (context, index1) {
                                var orderData = data.orders[index1];

                                return Container(
                                   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10,),

                                  // decoration: BoxDecoration(
                                  //   border: Border(
                                  //     bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                                  //   ),
                                  // ),
                                     
                                   child: Column(
                                    
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Expanded(child: Text(' ${orderData.kot.itname}',style: TextStyle(fontWeight: FontWeight.bold),)),

                                        Text(
                                           'X ${orderData.kot.qty?.toStringAsFixed(0)}',
                                              style: TextStyle(fontSize: textScale * 15, color: Colors.black),
                                              ),
                                              SizedBox(width: 5,),


                                        Text(data.orders.first.UnitName.toString(),style: TextStyle(color: Colors.red),),
                                              
                                        
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                           Padding(
                                             padding: const EdgeInsets.only(left: 5),
                                             child: Text(
                                              orderData.kot.itcomment.toString(),
                                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                              ),
                                           ),
                                           if (orderData.kot.havetopack == 1)
                                         Row(
                                          children: [
                                             Text(
                                              "Have to Pack",
                                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                            ),
                                        
                                         //  const Icon(Icons.redeem_outlined, color: Colors.redAccent, size: 18),
                                        
                                          ],
                                        ),


                                        ],
                                      )
                                      
                                  
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
                                  if (data.orders.first.kot.kdsstatus == 1) {
                                    controller.updateOrderStatus(
                                      shopNumber: data.orders.first.kot.shopvno!,
                                      status: 2,
                                      orderIndex: index,
                                    );
                                  } else {
                                    controller.updateOrderStatus(
                                      shopNumber: data.orders.first.kot.shopvno!,
                                      status: 0,
                                      orderIndex: index,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: data.orders.first.kot.kdsstatus == 2 ? Colors.yellow[400] : Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                child: data.orders.first.kot.isLoading
                                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
                                    : Text(
                                        data.orders.first.kot.kdsstatus == 2 ? "Mark as Ready" : "Mark as Accept",
                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                              ),
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
      ),
    );
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



