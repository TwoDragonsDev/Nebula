import 'dart:async';

import 'package:Nebula/services/notification.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import 'battery.dart';

Future<void> initServices() async {
//My Services:
//Battery 0x180f
//Push Notification 0x00009071-0000-0000-0000-00a57e401d05

  List<BluetoothService> _services = [];
  final ApplicationController controller = Get.find();

  try {
    controller.myDevice.value.requestMtu(223, predelay: 0);
  } catch (e) {
    print("error: " + e.toString());
  }

  try {
    _services = await controller.myDevice.value.discoverServices();
  } catch (e) {
    print("error: " + e.toString());
  }

  _services.forEach((element) {
    String serviceId = ("0x" + element.serviceUuid.toString());
    if (serviceId == "0x180f") {
      batteryService(element);
    }
    if (serviceId == "0x00009071-0000-0000-0000-00a57e401d05") {
      notificationService(element);
    }
  });
}
