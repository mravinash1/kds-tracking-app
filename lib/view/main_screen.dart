import 'package:billhosts/controller/hotel_screen_controller.dart';
import 'package:billhosts/controller/kds_display_controller.dart';
import 'package:billhosts/controller/login_controller.dart';
import 'package:billhosts/utils/bluetooth_printer_helper.dart';
import 'package:billhosts/utils/printer_selection.dart';
import 'package:billhosts/view/clubitem/club_item_screen.dart';
import 'package:billhosts/view/hotel_screen/hotel_screen.dart';
import 'package:billhosts/view/hotel_screen/notification_hotel_screen.dart';
import 'package:billhosts/view/kichen_display/kichen_display.dart';
import 'package:billhosts/view/kichen_display/notification_kitchen_screen.dart';
import 'package:billhosts/view/kichen_display/stock_update_screen.dart';
import 'package:billhosts/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late KDSDisplayController controller;
  late HotelDisplayController hotelcontroller;
  late LoginController loginController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  final BluetoothPrinterManager printerManager = BluetoothPrinterManager();

  @override
  void initState() {
    controller = Get.put(KDSDisplayController());
    hotelcontroller = Get.put(HotelDisplayController());
    loginController = Get.put(LoginController());
    _initializeControllers();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await printerManager.scanDevices();
      showDialog(
          context: context,
          builder: (context) =>
              PrinterSelectionDialog(printerManager: printerManager));
    });
  }

  Future<void> _initializeControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('userId');

    if (storedUserId != null) {
      final loginController = Get.put(LoginController());
      loginController.userId = storedUserId;

      controller = Get.put(KDSDisplayController());
      hotelcontroller = Get.put(HotelDisplayController());
      controller?.fetchData();
      hotelcontroller?.fetchData();

      setState(() {
        isLoading = false;
      });
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          // Prevent back button from navigating to login screen
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,

          appBar: AppBar(
            title: Text(
              'Kitchen Display System',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.green[600],

            // Drawer Open Button
            leading: InkWell(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),

            actions: [
              // Kitchen Notification Icon
              Obx(() => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none,
                            size: 30, color: Colors.white),
                        onPressed: () {
                          Get.to(NotificationKitchenScreen());
                        },
                      ),
                      if (controller.notificationCount.value > 0)
                        Positioned(
                          right: 5,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            constraints: const BoxConstraints(
                                minWidth: 22, minHeight: 22),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              controller.notificationCount.value.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),

              // Hotel Notification Icon
              Obx(() => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none,
                            size: 30, color: Colors.white),
                        onPressed: () {
                          Get.to(NotificationHotelScreen());
                        },
                      ),
                      if (hotelcontroller.notificationCount.value > 0)
                        Positioned(
                          right: 5,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            constraints: const BoxConstraints(
                                minWidth: 22, minHeight: 22),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              hotelcontroller.notificationCount.value
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
            ],

            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(
                  child: Text(
                    'Restaurant',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Tab(
                  child: Text(
                    'Room Services',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Tab(
                  child: Text(
                    'Bulk items',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Drawer Implementation
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('Bill-Host'),
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/billhost.png'),
                    backgroundColor: Colors.white,
                  ),
                  decoration: BoxDecoration(color: Colors.green[600]),
                ),
                ListTile(
                  //   leading: const Icon(Icons.info_outline,color: Colors.black,),
                  leading: const Icon(
                    Icons.trending_up_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Items Stock update",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    final loginController = Get.find<LoginController>();
                    int shopId = loginController.userId;

                    Get.to(() => ItemListScreen(
                          shopId: shopId,
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Get.to(LoginScreen());
                    loginController.logout();
                  },
                ),
              ],
            ),
          ),

          // Tab Views for Restaurant and Room Services
          body: const TabBarView(
            children: [
              KitchenScreen(),
              HotelScreen(),
              ClubItemScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
