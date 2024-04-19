import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

import 'controllers/device_controller.dart';
import 'device_connection.dart';
import 'notification/notification_handler.dart';

class MyTaskHandler extends TaskHandler {
  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    notificationHandler();

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    final ApplicationController controller = Get.find();
    final String status =
        controller.myDevice.value.isConnected ? 'Connected' : 'Disconnected';
    final String deviceName = controller.myDeviceInfo.value.deviceName;
    final int battery = controller.myDeviceInfo.value.batteryPercentage;
    FlutterForegroundTask.updateService(
      notificationTitle: 'Nebula Sync',
      notificationText: '$status to $deviceName ($battery%)',
    );

    final Map<String, dynamic> deviceData = {
      'isConnected': controller.myDevice.value.isConnected,
      'batteryPercentage': controller.myDeviceInfo.value.batteryPercentage,
      'deviceName': deviceName,
    };

    // Send data to the main isolate.
    sendPort?.send(deviceData);

    connectToDeviceButton();
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    print('onDestroy');
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/");
  }
}

void InitForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      id: 500,
      channelId: 'foreground_service',
      channelName: 'Foreground Service Notification',
      channelDescription:
          'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
      iconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
        backgroundColor: Color.fromARGB(255, 255, 0, 234),
      ),
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 5000,
      isOnceEvent: false,
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}
