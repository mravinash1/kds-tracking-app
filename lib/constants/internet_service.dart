// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// class InternetService {
//   StreamController<bool> connectionStatusController = StreamController<bool>();

//   InternetService() {
//     Connectivity().onConnectivityChanged.listen((result) async {
//       bool hasInternet = await InternetConnectionChecker().hasConnection;
//       connectionStatusController.add(hasInternet);
//     });
//   }

//   Stream<bool> get internetStatus => connectionStatusController.stream;

//   void dispose() {
//     connectionStatusController.close();
//   }
// }
