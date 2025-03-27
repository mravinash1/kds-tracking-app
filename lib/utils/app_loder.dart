import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPageLoader extends StatelessWidget {
const AppPageLoader({super.key,required this.child,required this.isLoading});
final Widget child;
final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(


body: Stack(
  children: [
    isLoading?  Container(height: Get.height,
      width: Get.width,
      color: Colors.grey,
      child: Center(child: CircularProgressIndicator(),),):const SizedBox(),
    child
  ],
  ),
    );
  }
}
