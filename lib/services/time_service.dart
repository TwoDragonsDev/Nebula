import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';

Future<void> timeService(BluetoothService bluetoothService) async {
  final ApplicationController controller = Get.find();
  BluetoothCharacteristic timeCharacteristic =
      bluetoothService.characteristics[0];
  controller.setTimeService(timeCharacteristic);
}
