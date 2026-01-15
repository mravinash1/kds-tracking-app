import 'dart:async';
import 'dart:convert';
import 'package:billhosts/controller/login_controller.dart';
import 'package:billhosts/utils/bluetoothprinter_hotel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import '../constants/endpoint.dart';
import '../models/kds_hotel_model/filter_hotel_model.dart';
import '../models/kds_hotel_model/kds_hotel_model.dart';
import '../utils/api_service_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var shopId = 0;

  @override
  void onInit() {
    super.onInit();
    loadShopIdAndFetchData();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchData());
  }

  Future<void> loadShopIdAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    shopId = prefs.getInt('userId') ?? 0;

    if (shopId != 0) {
      fetchData(); // aapka existing method
    }
  }

  Future fetchData() async {
    isLoading = true;
    update();

    try {
      var data = await _apiService.get(
        "${AppConstants.kdshoteldisplay}${loginController.userId}/${loginController.userId}/0/1",
      );

      if (data != null) {
        kdslists = List<KdsHotelModel>.from(
            data.map((x) => KdsHotelModel.fromJson(x)));

        // Store current order count for sound comparison
        int oldOrderCount = filterKDS.length;

        // Group orders by shopvno (unique order ID)
        Map<String, FilterModelOfHotel> groupedOrders =
            {}; // Changed to String key

        for (var orderData in kdslists) {
          var kotData = orderData.kot!;

          // Handle double-to-int conversion for shopvno
          String orderId = (kotData.shopvno is double)
              ? kotData.shopvno.toInt().toString()
              : kotData.shopvno.toString();

          if (orderId.isEmpty || orderId == "null") {
            debugPrint('Invalid shopvno: ${kotData.shopvno}');
            orderId = "Unknown_${DateTime.now().millisecondsSinceEpoch}";
          }

          if (!groupedOrders.containsKey(orderId)) {
            groupedOrders[orderId] = FilterModelOfHotel(
              roomnoview: kotData.roomnoview?.toString() ?? "Unknown",
              orders: [],
            );
          }

          groupedOrders[orderId]!.orders.add(Orders(
                kot: KotDatas(
                  id: kotData.id!,
                  chid: kotData.chid!,
                  rcode: kotData.rcode,
                  roomnoview: kotData.roomnoview?.toString() ?? "Unknown",
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
                UnitName: orderData.UnitName,
              ));
        }

        filterKDS = groupedOrders.values.toList();

        // Play sound if new orders arrive
        if (filterKDS.length > oldOrderCount) {
          await _playSound();
        }

        notificationCount.value = filterKDS.length;
      }
    } catch (e) {
      debugPrint("Error during fetchData: $e");
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
        Future.delayed(const Duration(seconds: 1), () => fetchData());

        _playSound();
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

  final BluetoothPrinterHotel printerManager = BluetoothPrinterHotel();

  Future<void> printOrder(FilterModelOfHotel orderGroup) async {
    try {
      // Safely extract and convert values
      final roomNo = int.tryParse(orderGroup.roomnoview.toString()) ?? 0;
      final date = _formatDate(orderGroup.orders.first.kot.orddate.toString());
      final time = orderGroup.orders.first.kot.orddate.toString();

      final items = orderGroup.orders.map((order) {
        return {
          'name': order.kot.rawname.toString(),
          'qty': order.kot.qty is int
              ? order.kot.qty
              : int.tryParse(order.kot.qty.toString()) ?? 0,
        };
      }).toList();

      // Prepare print data
      final receiptBytes = await printerManager.generateReceipt(
        roomnoview: roomNo,
        date: date,
        time: time,
        items: items,
      );

      // Print
      await printerManager.printReceipt(receiptBytes);

      Get.snackbar("Success", "Order printed successfully");
    } catch (e) {
      Get.snackbar("Print Error", e.toString());
      print("Error: $e");
    }
  }

  String _formatDate(String rawDate) {
    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return rawDate;
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
