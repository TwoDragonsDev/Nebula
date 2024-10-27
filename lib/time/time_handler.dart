import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import '../controllers/device_controller.dart';

Future<void> timeHandler() async {
  final ApplicationController controller = Get.find();
  print('Time service called!');
  if (controller.myDevice.value.isConnected &&
      controller.timeService.value != null) {
    print('Time handler started!');
    sendTimeMessage(controller.timeService.value!, createDate());
    print('Time handler ended!');
  }
}

Uint8List createDate() {
  final now = DateTime.now();
  print("time is : " + now.toString());
  int year = now.year - 1900;
  int month = now.month - 1;
  int day = now.day;
  int hour = now.hour;
  int minute = now.minute;
  int second = now.second;

  return Uint8List.fromList([year, month, day, hour, minute, second]);
}

Future<void> sendTimeMessage(
    BluetoothCharacteristic service, Uint8List data) async {
  try {
    await service.write(data,
        withoutResponse: service.properties.writeWithoutResponse);
  } catch (e) {
    print('Error: The device may be disconnected');
    print('Actual Error: $e');
  }
}
