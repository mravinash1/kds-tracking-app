// printer_selection_dialog.dart
import 'package:billhosts/utils/bluetooth_printer_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrinterSelectionDialog extends StatelessWidget {
  final BluetoothPrinterManager printerManager;

  const PrinterSelectionDialog({super.key, required this.printerManager});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Printer'),
      content: Obx(() {
        if (printerManager.isScanning.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SizedBox(
          width: double.maxFinite,
          height: 300,
          child: printerManager.availableDevices.isEmpty
              ? const Center(child: Text('No printers found'))
              : ListView.builder(
                  itemCount: printerManager.availableDevices.length,
                  itemBuilder: (context, index) {
                    final device = printerManager.availableDevices[index];
                    return ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.remoteId.toString()),
                      trailing: printerManager.selectedPrinter.value?.remoteId == device.remoteId
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () => printerManager.selectPrinter(device),
                    );
                  },
                ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (printerManager.selectedPrinter.value != null) {
              printerManager.connect();
            }
          },
          child: const Text('Connect'),
        ),
      ],
    );
  }
}