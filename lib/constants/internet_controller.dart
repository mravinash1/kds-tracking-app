import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();

    Connectivity().onConnectivityChanged.listen((result) async {
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      isConnected.value = hasInternet;
    });
  }
}
