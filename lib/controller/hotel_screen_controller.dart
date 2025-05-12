import 'dart:async';
import 'dart:convert';
import 'package:billhosts/controller/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../constants/endpoint.dart';
import '../models/kds_hotel_model/filter_hotel_model.dart';
import '../models/kds_hotel_model/kds_hotel_model.dart'; 
import '../utils/api_service_class.dart';

  class HotelDisplayController extends GetxController {
  final HttpService _apiService = HttpService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<KdsHotelModel> kdslists = [];
  List<FilterModelOfHotel> filterKDS = [];
  TextEditingController user1Controller = TextEditingController();
  TextEditingController user2Controller = TextEditingController();

  LoginController loginController = Get.put(LoginController());
  List<String> roomNoList = [];
  List<Orders> order = [];

  bool isLoading = false;
  var isAccepted = false.obs;
  bool isLoadingUpdateStatus = false;
  int _shopNumberCount = 0;
  var notificationCount = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchData());
  }

  Future fetchData() async {
    isLoading = true;
    update();

    try {
      var data = await _apiService.get(
        "${AppConstants.kdshoteldisplay}${loginController.userId}/${loginController.userId}/0/1",
      );

      if (data != null) {
        kdslists = List<KdsHotelModel>.from(data.map((x) => KdsHotelModel.fromJson(x)));

        int newOrders = filterKDS.length;
        if (newOrders > notificationCount.value) {
          await _playSound();
        }
        notificationCount.value = newOrders;

        // Grouping orders by room number as a String
        Map<String, FilterModelOfHotel> groupedOrders = {};

        for (var orderData in kdslists) {
          var kotData = orderData.kot!;
          String roomNo = kotData.roomnoview?.toString() ?? "Unknown";

          if (roomNo.isEmpty) {
            debugPrint('Invalid room number: ${kotData.roomnoview}');
            roomNo = "Unknown";
          }

          if (!groupedOrders.containsKey(roomNo)) {
            groupedOrders[roomNo] = FilterModelOfHotel(roomnoview: roomNo, orders: []);
          }

          groupedOrders[roomNo]!.orders.add(Orders(
            kot: KotDatas(
              id: kotData.id!,
              chid: kotData.chid!,
              rcode: kotData.rcode,
              roomnoview: roomNo,
              orddate: kotData.orddate!,
              ordtime: kotData.ordtime!,
              deptcode: kotData.deptcode!,
              rawcode: kotData.rawcode!,
              rawname: kotData.rawname!,
              serviceremarks: kotData.serviceremarks,
              barcode: kotData.barcode!,
              qty: kotData.qty,
              rate: kotData.rate,
              gst: kotData.gst,
              billno: kotData.billno,
              gstamt: kotData.gstamt,
              discperc: kotData.discperc,
              discamt: kotData.discamt,
              roundoff: kotData.roundoff,
              totdiscamt: kotData.totdiscamt,
              ittotal: kotData.ittotal,
              totqty: kotData.totqty,
              totgst: kotData.totgst,
              totordamt: kotData.totordamt,
              shopvno: kotData.shopvno,
              guestname: kotData.guestname,
              guestmob: kotData.guestmob,
              guestadd: kotData.guestadd,
              itemview: kotData.itemview,
              shopid: kotData.shopid,
              kdsstatus: kotData.kdsstatus,
            ),
            kitchenName: orderData.kitchenName.toString(),
            UnitName:orderData.UnitName
          

          ));
        }

        filterKDS = groupedOrders.values.toList();

     //   print('Grouped KDS Hotel Data: ${jsonEncode(filterKDS)}');
        if (_shopNumberCount != roomNoList.length) {
          _shopNumberCount = roomNoList.length;
          await _playSound();
        }

        isLoading = false;
        update();
      }
    } catch (e) {
      isLoading = false;
      update();
     // debugPrint("Error during fetchData: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateOrderStatus({
    required int shopNumber,
    required int status,
    required int orderIndex,
  }) async {
    final url =
        "https://hotelserver.billhost.co.in/KDSDisplayUpdateStatusHotel/${loginController.userId}/${shopNumber.toInt()}/$status";

    isLoadingUpdateStatus = true;
    filterKDS[orderIndex].orders.first.kot.isLoading = true;
    update();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": "Ready"}),
      );

      if (response.statusCode == 200) {

      } else {
        Get.snackbar("Error", "Failed to update order status");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      debugPrint("Update order status error: $e");
    } finally {
      isLoadingUpdateStatus = false;
      update();
    }
  }

  // Function to play sound
  
  Future<void> _playSound() async {
    try {
      await _audioPlayer.setAsset('assets/readytone.mp3');
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.onClose();
  }
}
