import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';

Future<void> notificationService(BluetoothService notificationService) async {
  final ApplicationController controller = Get.find();
  BluetoothCharacteristic notificationCharacteristic =
      notificationService.characteristics[0];
  controller.setPushNotificationService(notificationCharacteristic);
}
