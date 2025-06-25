// bluetooth_printer_manager.dart
import 'dart:async';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
 class BluetoothPrinterHotel extends GetxController {
  static const String _kSelectedPrinterKey = 'selected_printer_id';
  
  final FlutterBluePlus _flutterBlue = FlutterBluePlus();
  final RxList<BluetoothDevice> availableDevices = <BluetoothDevice>[].obs;
  final Rxn<BluetoothDevice> selectedPrinter = Rxn<BluetoothDevice>();
  final RxBool isScanning = false.obs;
  final RxBool isConnecting = false.obs;
  final RxBool isPrinting = false.obs;
  BluetoothCharacteristic? _txCharacteristic;

  @override
  void onInit() {
    super.onInit();
    _loadSavedPrinter();
  }

  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_kSelectedPrinterKey);
    
    if (savedId != null) {
      final devices = await FlutterBluePlus.connectedDevices;
      for (var device in devices) {
        if (device.remoteId.toString() == savedId) {
          selectedPrinter.value = device;
          break;
        }
      }
    }
  }

  Future<void> _savePrinter(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedPrinterKey, device.remoteId.toString());
  }



Future<void> scanDevices() async {
  isScanning.value = true;
  availableDevices.clear();
  
  // Use a Set to track unique devices
  final uniqueDevices = <String, BluetoothDevice>{};

  StreamSubscription<List<ScanResult>>? scanSubscription;
  scanSubscription = FlutterBluePlus.scanResults.listen((results) {
    for (ScanResult result in results) {
      final deviceId = result.device.remoteId.toString();
      if (!uniqueDevices.containsKey(deviceId) && 
          result.device.name.isNotEmpty) {
        uniqueDevices[deviceId] = result.device;
        availableDevices.add(result.device);
      }
    }
  }, onError: (e) => debugPrint("Scan error: $e"));

  await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  await Future.delayed(const Duration(seconds: 10));
  await FlutterBluePlus.stopScan();
  scanSubscription.cancel();
  isScanning.value = false;
}



  Future<void> selectPrinter(BluetoothDevice device) async {
    selectedPrinter.value = device;
    await _savePrinter(device);
  }




Future<void> connect() async {
  if (selectedPrinter.value == null) return;
  
  isConnecting.value = true;
  try {
    await selectedPrinter.value!.connect();
    await selectedPrinter.value!.requestMtu(512); 

    
    // Discover services
    List<BluetoothService> services = 
        await selectedPrinter.value!.discoverServices();
    
    // Debug print all services/characteristics
    debugPrint("Discovered ${services.length} services:");
    for (BluetoothService service in services) {
      debugPrint("Service: ${service.uuid}");
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        debugPrint("  Characteristic: ${characteristic.uuid} - Properties: ${characteristic.properties}");
      }
    }
    
    // Find the print characteristic (more flexible approach)
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          _txCharacteristic = characteristic;
          debugPrint("Using write characteristic: ${characteristic.uuid}");
          break;
        }
      }
      if (_txCharacteristic != null) break;
    }
    
    if (_txCharacteristic == null) {
      throw Exception("No writable characteristic found");
    }
  } catch (e) {
    debugPrint("Connection error: $e");
    rethrow;
  } finally {
    isConnecting.value = false;
  }
}



Future<void> printReceipt(List<int> bytes) async {
  if (selectedPrinter.value == null) {
    throw Exception("No printer selected");
  }
  
  if (_txCharacteristic == null) {
    await connect();
  }
  
  isPrinting.value = true;
  try {
    // Determine MTU size dynamically
    final mtu = await selectedPrinter.value!.mtu.first;
    final chunkSize = mtu - 3; // Allow 3 bytes for ATT overhead
    
    for (int i = 0; i < bytes.length; i += chunkSize) {
      int end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      List<int> chunk = bytes.sublist(i, end);
      await _txCharacteristic!.write(chunk);
      await Future.delayed(const Duration(milliseconds: 20)); // Add delay
    }
  } catch (e) {
    debugPrint("Print error: $e");
    rethrow;
  } finally {
    isPrinting.value = false;
  }
}

  Future<List<int>> generateReceipt({
    required int roomnoview,
    required String date,
    required String time,
    required List<Map<String, dynamic>> items,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Header
    bytes += generator.text("Room No", 
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2));
         bytes += generator.text("Room No : $roomnoview", 
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.hr();
    
    // Order details
    bytes += generator.row([
      PosColumn(text: 'Date', width: 6),
      PosColumn(text: date, width: 6),
    ]);
    
      


    bytes += generator.row([
      PosColumn(text: 'Time', width: 6),
      PosColumn(text: time, width: 6),
    ]);
    
    
   
    bytes += generator.hr();
    
    // Items list
    bytes += generator.text("ITEMS", 
        styles: PosStyles(align: PosAlign.center, bold: true));
    
    for (var item in items) {
      bytes += generator.row([
        PosColumn(
          text: '${item['name']} x ${item['qty']}',
          width: 12,
          styles: item['qty'] == 0 
              ? PosStyles(align: PosAlign.left,) 
              : PosStyles(align: PosAlign.left)
        ),
      ]);
      
      if (item['comment'] != null && item['comment'].isNotEmpty) {
        bytes += generator.text("Note: ${item['comment']}");
      }
      
      if (item['pack'] == true) {
        bytes += generator.text("(PACK)", 
            styles: PosStyles(align: PosAlign.right, bold: true));
      }
    }
    
    // Footer
    bytes += generator.hr();
    bytes += generator.text("KITCHEN COPY", 
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Thank You!", 
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(2);
    bytes += generator.cut();
    
    
    
    
    return bytes;
  }

  @override
  void onClose() {
    selectedPrinter.value?.disconnect();
    super.onClose();
  }
}