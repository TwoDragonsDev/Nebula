import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:Nebula/models/app_info.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;
import '../controllers/device_controller.dart';

AppInfoData? findAppByName(List<AppInfoData> apps, String packageName) {
  return apps.firstWhere(
    (app) => app.packageName == packageName,
  );
}

Future<void> notificationHandler() async {
  final ApplicationController controller = Get.find();
  final Map<String, String> notificationIcons = controller.notificationIcons;
  List<AppInfoData> _myApps = [];
  final prefs = await SharedPreferences.getInstance();
  final savedMyApps = prefs.getStringList('myApps');
  if (savedMyApps != null) {
    _myApps = savedMyApps
        .map((myApp) => AppInfoData.fromJson(json.decode(myApp)))
        .toList();
  }

  print('Notification handler started!');
  NotificationListenerService.notificationsStream.listen((event) {
    if (controller.myDevice.value.isConnected &&
        controller.pushNotificationsService.value != null) {
      AppInfoData? appFound = findAppByName(_myApps, event.packageName!);
      if (appFound!.option == "off") {
        return;
      }
      if (event.id == 500) {
        return;
      }
      if (event.hasRemoved!) {
        sendNotification(controller.pushNotificationsService.value!,
            deleteNotification(event));
        return;
      }
      sendNotification(controller.pushNotificationsService.value!,
          createNotification(event, notificationIcons, appFound));
    }
  });
}

Uint8List createNotification(ServiceNotificationEvent event,
    Map<String, String> notificationIcons, AppInfoData? appFound) {
  var message = xml.XmlBuilder();
  message.element('insert', nest: () {
    message.element('pn', nest: event.packageName);
    message.element('id', nest: event.id);
    message.element('an', nest: appFound?.name);
    message.element('ai', nest: notificationIcons[event.packageName]);
    message.element('su', nest: event.title);
    message.element('bo', nest: event.content);
    message.element('vb', nest: appFound!.option);
  });
  final document = message.buildDocument();
  String xmlString = document.toString();
  var xmlBytes = utf8.encode(xmlString);
  return xmlBytes;
}

Uint8List deleteNotification(ServiceNotificationEvent event) {
  var message = xml.XmlBuilder();
  message.element('removed', nest: () {
    message.element('id', nest: event.id);
  });
  final document = message.buildDocument();
  String xmlString = document.toString();
  var xmlBytes = utf8.encode(xmlString);
  return xmlBytes;
}

Future<void> sendNotification(
    BluetoothCharacteristic service, Uint8List xmlBytes) async {
  try {
    await service.write(xmlBytes,
        withoutResponse: service.properties.writeWithoutResponse);
  } catch (e) {
    print('Error: The device may be disconnected');
    print('Actual Error: $e');
  }
}
