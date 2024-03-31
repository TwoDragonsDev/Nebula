import 'package:Nebula/utils/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/device_controller.dart';
import 'screens/scan_screen.dart';
import 'services/init_services.dart';
import 'utils/snackbar.dart';
import 'widgets/smartwatch_info.dart';
import 'package:get/get.dart';

Future<void> connectToDevice() async {
  final ApplicationController controller = Get.find();
  bool isPermissionGranted =
      await NotificationListenerService.isPermissionGranted();

  if (!isPermissionGranted) {
    await NotificationListenerService.requestPermission();
  }

  try {
    final prefs = await SharedPreferences.getInstance();
    final uuid = prefs.getString('uuid') ?? "";
    final deviceName = prefs.getString('deviceName') ?? "";

    if (uuid.isNotEmpty && deviceName.isNotEmpty) {
      controller.setDeviceInfoName(deviceName);
      controller.myDevice.value =
          BluetoothDevice(remoteId: DeviceIdentifier(uuid));
      await controller.myDevice.value.connectAndUpdateStream();
      controller.setDevice(controller.myDevice.value);
      initServices();
    } else {
      Snackbar.show(ABC.c, "UUID or Device Name is empty", success: false);
    }
  } catch (e) {
    Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
  }
  await Future.delayed(Duration(seconds: 1));
}
