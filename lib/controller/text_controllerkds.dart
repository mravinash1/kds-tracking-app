import 'dart:async';
import 'dart:convert';
import 'package:billhosts/controller/login_controller.dart';
import 'package:billhosts/models/filter_model_of_kds.dart';
import 'package:billhosts/models/kds_display_models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import '../constants/endpoint.dart';
import '../utils/api_service_class.dart';

  class KDSDisplayController extends GetxController {
  final HttpService _apiService = HttpService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<KdsDisplayModel> kdslists = []; 
  List<FilterModelOfKds> filterKDS = [];
  TextEditingController user1Controller = TextEditingController();
  TextEditingController user2Controller = TextEditingController();

  LoginController loginController=Get.put(LoginController());
  List<int> shopNoList=[];
  List<Order> order = []; 
  bool isLoading = false;  
  var isAccepted = false.obs;
  bool isLoadingUpdateStatus = false;
  var notificationCount = 0.obs;
  Timer? _timer;
  int previousOrderCount = 0; 
  bool _isFirstFetch = true; // ✅ Ignore first fetch after login
  List<int> _previousQtyList = []; // 🔁 Store previous qty list
   List<String> _previousTableNames = [];
  
  




  
  @override
  void onInit() {
    super.onInit();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchData());
  }



  @override
  void onClose() {
    if(_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.onClose();
  }  

  

  Future<void> fetchData() async {
  isLoading = true;
  update();

  try {
    var data = await _apiService.get(
        "${AppConstants.kdsdisplay}${loginController.userId}/${loginController.userId}/0/1");

    if (data != null) {
      kdslists = List<KdsDisplayModel>.from(
          data.map((x) => KdsDisplayModel.fromJson(x)));

      // Extract current data
      List<int> currentQtyList =
          kdslists.map((e) => (e.kot?.qty ?? 0).toInt()).toList();
      List<String> currentTableNames =
          kdslists.map((e) => (e.kot?.tablename ?? "")).toList();

     // int currentOrderCount = kdslists.length;
     int currentOrderCount = kdslists.map((e) => e.kot?.shopvno).toSet().length;


      bool shouldPlaySound = false;

      if (!_isFirstFetch) {
        // Check for any changes
        bool qtyChanged = false;
        bool tableChanged = false;

        for (int i = 0; i < currentQtyList.length; i++) {
          if (i < _previousQtyList.length &&
              currentQtyList[i] != _previousQtyList[i]) {
            qtyChanged = true;
            break;
          }
        }

        for (int i = 0; i < currentTableNames.length; i++) {
          if (i < _previousTableNames.length &&
              currentTableNames[i] != _previousTableNames[i]) {
            tableChanged = true;
            break;
          }
        }

        if (currentOrderCount > previousOrderCount ||
            qtyChanged ||
            tableChanged) {
          shouldPlaySound = true;
        }
      }

      // Save new data for next comparison
      _previousQtyList = currentQtyList;
      _previousTableNames = currentTableNames;
      previousOrderCount = currentOrderCount;

      // Build filtered KDS
      shopNoList.clear();
      for (var item in kdslists) {
        if (!shopNoList.contains(item.kot?.shopvno)) {
          shopNoList.add(item.kot!.shopvno!);
        }
      }

      filterKDS.clear();
      for (var shopNo in shopNoList) {
        filterKDS.add(FilterModelOfKds(shopvno: shopNo, orders: []));
      }


  for (var filter in filterKDS) {
  for (var item in kdslists) {
    if (item.kot != null && item.kot!.shopvno == filter.shopvno) {
      var kotData = KotData(
        havetopack:item.kot!.havetopack,
        id: item.kot!.id!,
        shopid: item.kot!.shopid!,
        itemremarks: item.kot!.itemremarks,
        shopvno: item.kot!.shopvno!,
        kotdate: item.kot!.kotdate!,
        kottime: item.kot!.kottime!,
        timeotp: item.kot!.timeotp!,
        kottype: item.kot!.kottype!,
        rawcode: item.kot!.rawcode!,
        qty: item.kot!.qty,
        status: item.kot!.status!,
        blno: item.kot!.blno,
        tablecode: item.kot!.tablecode,
        tablename: item.kot!.tablename,
        itname: item.kot!.itname,
        barcode: item.kot!.barcode,
        itemview: item.kot!.itemview,
        discperc: item.kot!.discperc,
        rate: item.kot!.rate,
        vat: item.kot!.vat,
        vatamt: item.kot!.vatamt,
        gst: item.kot!.gst,
        gstamt: item.kot!.gstamt,
        ittotal: item.kot!.ittotal,
        discamt: item.kot!.discamt,
        totqty: item.kot!.totqty,
        totgst: item.kot!.totgst,
        totdiscamt: item.kot!.totdiscamt,
        roundoff: item.kot!.roundoff,
        totordamt: item.kot!.totordamt,
        cess: item.kot!.cess,
        cessamt: item.kot!.cessamt,
        kitchenmessage: item.kot!.kitchenmessage,
        isdiscountable: item.kot!.isdiscountable,
        servicechperc: item.kot!.servicechperc,
        servicechamt: item.kot!.servicechamt,
        totalservicechamt: item.kot!.totalservicechamt,
        taxableamt: item.kot!.taxableamt,
        totaltaxableamt: item.kot!.totaltaxableamt,
        wcode: item.kot!.wcode,
        wname: item.kot!.wname,
        nop: item.kot!.nop,
        bldiscperc: item.kot!.bldiscperc,
        bldiscamt: item.kot!.bldiscamt,
        itcomment: item.kot!.itcomment,
        cancelreason: item.kot!.cancelreason,
        bldlvchperc: item.kot!.bldlvchperc,
        bldlvchamt: item.kot!.bldlvchamt,
        bldlvchamount: item.kot!.bldlvchamount,
        flatdiscount: item.kot!.flatdiscount,
        kdsstatus: item.kot!.kdsstatus,
      );

      filter.orders.add(Order(
        kot: kotData,  // ✅ Now passing the correct type
        statusName: item.statusName.toString(),
        kottypeName: item.kottypeName.toString(),
        kitchenName: item.kitchenName.toString(),
        UnitName:item.UnitName.toString()
      ));
    }
  }
}

      notificationCount.value = currentOrderCount;

      // Only play once per change
      if (shouldPlaySound) {
        await _playSound();
      }

      _isFirstFetch = false;
    }

    isLoading = false;
    update();
  } catch (e) {
    isLoading = false;
    update();
    debugPrint("Error fetching KDS data: $e");
  }
}



Future<void> updateOrderStatus({required int shopNumber, required int status, required int orderIndex}) async {
  final url = "https://hotelserver.billhost.co.in/KDSDisplayUpdateStatus/${loginController.userId}/$shopNumber/$status";

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
    } else {
      Get.snackbar("Error", "Failed to update order status");
    }
  } catch (e) {
    Get.snackbar("Error", "Something went wrong");
  } finally {
    isLoadingUpdateStatus = false;
    update();
  }
}



  
    // Function to play sound

  Future<void> _playSound() async {
    await _audioPlayer.setAsset('assets/readytone.mp3');
    _audioPlayer.play();
  }


// Function to format date
String _formatDate(String rawDate) {
  try {
    DateTime parsedDate = DateTime.parse(rawDate);
    return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate); // Format: YYYY-MM-DD HH:MM
  } catch (e) {
    return rawDate; // Return original if there's an error
  }
}



}
