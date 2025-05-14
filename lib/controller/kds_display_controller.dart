import 'dart:async';
import 'dart:convert';
import 'package:billhosts/controller/login_controller.dart';
import 'package:billhosts/models/filter_model_of_kds.dart';
import 'package:billhosts/models/kds_display_models.dart';
import 'package:billhosts/utils/notification_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';  
import '../constants/endpoint.dart'; 
import '../utils/api_service_class.dart';

  class KDSDisplayController extends GetxController {
  final HttpService _apiService = HttpService(); 
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<KdsDisplayModel> kdslists = []; 
  List<FilterModelOfKds> filterKDS = [];
  List<KdsDisplayModel> previousKdsList = [];

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
  bool _isFirstFetch = true; 


  
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

  


Future fetchData() async {
  isLoading = true;
  update();

  try {
    var data = await _apiService.get("${AppConstants.kdsdisplay}${loginController.userId}/${loginController.userId}/0/1");

    if (data != null) {
      List<KdsDisplayModel> newKdsList = List<KdsDisplayModel>.from(data.map((x) => KdsDisplayModel.fromJson(x)));

      int newOrders = filterKDS.length;

      bool shouldPlaySound = false;

      // Compare new and previous data to detect any important changes
      for (var newItem in newKdsList) {
        var prevItem = previousKdsList.firstWhere(
          (element) => element.kot?.id == newItem.kot?.id,
          orElse: () => KdsDisplayModel(kot: null),
        );

        // If it's a new order
        if (prevItem.kot == null) {
          shouldPlaySound = true;
         //await NotificationService.showNotification('New Order', '${newItem.kot?.shopvno} Kot No');

          break;
        }

      //  If order/item was cancelled

        if (newItem.kot?.status == 2 && prevItem.kot?.status != 2) {
          shouldPlaySound = true;
          break;
        }

        // If item name or table name was updated
        if (newItem.kot?.qty != prevItem.kot?.qty ||
            newItem.kot?.tablename != prevItem.kot?.tablename

            ) {
          shouldPlaySound = true;
          break;
        }
      }

      if (!_isFirstFetch && shouldPlaySound) {
        await _playSound();
      }

      previousKdsList = newKdsList; // Update the snapshot

      kdslists = newKdsList;
      notificationCount.value = newOrders;
      previousOrderCount = newOrders;
      _isFirstFetch = false;

      // Process shop list
      shopNoList.clear();
      for (var item in kdslists) {
        if (!shopNoList.contains(item.kot?.shopvno)) {
          shopNoList.add(item.kot!.shopvno!);
        }
      }

      // Organize orders
      filterKDS.clear();
      for (var shopNo in shopNoList) {
        filterKDS.add(FilterModelOfKds(shopvno: shopNo, orders: []));
      }

      for (var filter in filterKDS) {
        for (var item in kdslists) {
          if (item.kot != null && item.kot!.shopvno == filter.shopvno) {
            var kotData = KotData(
              havetopack: item.kot!.havetopack,
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
              kot: kotData,
              statusName: item.statusName.toString(),
              kottypeName: item.kottypeName.toString(),
              kitchenName: item.kitchenName.toString(),
              UnitName: item.UnitName.toString(),
            ));
          }
        }
      }

      isLoading = false;
      update();
    }
  } catch (e) {
    isLoading = false;
    update();
   // debugPrint("Error: $e");
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

      
      //  _playSound();
      
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



}
