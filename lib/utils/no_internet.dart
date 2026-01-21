import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.wifi_off, size: 80, color: Colors.red),
          SizedBox(height: 16),
          Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
