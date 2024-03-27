import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';

Future<void> batteryService(BluetoothService batteryService) async {
  final ApplicationController controller = Get.find();
  BluetoothCharacteristic batteryCharacteristic =
      batteryService.characteristics[0];

//Set init battery value
  List<int> battery = await batteryCharacteristic.read();
  controller.setDeviceInfoBattery(battery[0]);

//Subscribe event
  await batteryCharacteristic.setNotifyValue(true);
  await batteryCharacteristic.lastValueStream.listen((event) {
    List<int> battery = event;
    controller.setDeviceInfoBattery(battery[0]);
  });
}
