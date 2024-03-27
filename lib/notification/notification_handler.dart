import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart' as xml;
import '../controllers/device_controller.dart';

AppInfo? findAppByName(List<AppInfo> apps, String packageName) {
  return apps.firstWhere(
    (app) => app.packageName == packageName,
  );
}

Future<void> notificationHandler() async {
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  final ApplicationController controller = Get.find();
  final Map<String, String> notificationIcons = controller.notificationIcons;

  List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);

  _subscription =
      NotificationListenerService.notificationsStream.listen((event) {
    if (event.hasRemoved!) {
      sendNotification(controller.pushNotificationsService.value!,
          deleteNotification(event));
      return;
    }
    sendNotification(controller.pushNotificationsService.value!,
        createNotification(event, notificationIcons, apps));
  });
}

Uint8List createNotification(ServiceNotificationEvent event,
    Map<String, String> notificationIcons, List<AppInfo> apps) {
  AppInfo? appFound = findAppByName(apps, event.packageName!);

  var message = xml.XmlBuilder();
  message.element('insert', nest: () {
    message.element('pn', nest: event.packageName);
    message.element('id', nest: event.id);
    message.element('an', nest: appFound?.name);
    message.element('ai', nest: notificationIcons[event.packageName]);
    message.element('su', nest: event.title);
    message.element('bo', nest: event.content);
    message.element('vb', nest: 'normal');
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
  await service.write(xmlBytes,
      withoutResponse: service.properties.writeWithoutResponse);
}
