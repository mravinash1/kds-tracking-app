import 'package:billhosts/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/endpoint.dart';
import '../models/login_shop_models.dart';
import '../utils/api_service_class.dart';

  class LoginController extends GetxController {
  int userId=0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Loginshopmallmodels? loginShopModel;
  List<Loginshopmallmodels> loginshop = [];
  bool isLoading = false;

  Future loginData() async {
    isLoading = true;
    try {
      var response = await HttpService().get(
          "${AppConstants.loginshope}${emailController.text}/${passwordController.text}");
  //      print('>>>>>>>>>>>>>>>>>>>>>response $response');

  //    debugPrint("response  $response");
      if (response != null) {
        loginshop = List<Loginshopmallmodels>.from(
            response.map((x) => Loginshopmallmodels.fromJson(x)));
        if (loginshop.isNotEmpty) {
          userId=loginshop[0].id!;
         Get.to(()=>  MainScreen());
          update();



  Get.snackbar(
  'User Found',
  'login successful',
  snackPosition: SnackPosition.TOP,
  backgroundColor: Colors.green,
  colorText: Colors.black,
  icon: Icon(Icons.check_circle_outline_outlined, color: Colors.black,),
  borderRadius: 15,
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  duration: Duration(seconds: 2),
  forwardAnimationCurve: Curves.easeOutBack,  
       );
                
      }
      else{
   // Get.snackbar('faild', 'Enter valid enter and password ');
   Get.snackbar(
  'faild',
  'Enter valid enter and password',
  snackPosition: SnackPosition.TOP,
  backgroundColor: Colors.red,
  colorText: Colors.black,
  icon: Icon(Icons.error_outline, color: Colors.black),
  borderRadius: 15,
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  duration: Duration(seconds: 4),
  forwardAnimationCurve: Curves.easeOutBack,  
       );
      }

        debugPrint("data  $loginshop");
        isLoading = false;
        update();
      }
      
    } catch (e) {
      isLoading = false;

      update();
      debugPrint("catch  $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    //loginData();
    // TODO: implement onInit
    super.onInit();
  }
}
