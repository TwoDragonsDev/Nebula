import 'dart:isolate';

import 'package:Nebula/applications_configuration.dart';
import 'package:Nebula/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import '../flutter_foreground_task.dart';
import '../main.dart';
import '../permissions.dart';
import 'applications_configuration.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ReceivePort? _receivePort;

  Future<bool> _startForegroundTask() async {
    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    final ApplicationController controller = Get.find();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      bool isConnected = data['isConnected'];
      int batteryPercentage = data['batteryPercentage'];
      String deviceName = data['deviceName'];

      controller.setDeviceInfoBattery(batteryPercentage);
      controller.setDeviceInfoConnected(isConnected);
      controller.setDeviceInfoName(deviceName);
      /* 
      if (data is int) {
        print('eventCount: $data');
      } else if (data is String) {
        if (data == 'onNotificationPressed') {
          Navigator.of(context).pushNamed('/resume-route');
        }
      } else if (data is DateTime) {
        print('timestamp: ${data.toString()}');
      } */
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  final ApplicationController controller = Get.find();
  bool isConnected = true;
  bool findMyWatch = true;
  bool syncTime = true;
  bool silencePhone = false;
  bool showIncomingCalls = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RequestPermissionForAndroid();
      InitForegroundTask();
      ApplicationsConfiguration();
      _startForegroundTask();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isWatchConnected = false;
  double watchBatteryLevel = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nebula'),
      ),
      body: Obx(() => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.watch,
                      size: 64,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.myDeviceInfo.value.batteryPercentage
                                  .toString() +
                              "%",
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          controller.myDeviceInfo.value.deviceName.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to weather settings page
                      },
                      child: Text('Weather Settings'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to watch search page
                      },
                      child: Text('Search Watch'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Take screenshot of smartwatch
                      },
                      child: Text('Take Screenshot'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to notification settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ApplicationsConfigurationPage()),
                        );
                      },
                      child: Text('Notification Settings'),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: Text('Sync Time'),
                      value: true,
                      onChanged: (value) {
                        // Update sync time state
                      },
                    ),
                    SwitchListTile(
                      title: Text('Silence Phone on Connect'),
                      value: true,
                      onChanged: (value) {
                        // Update silence phone state
                      },
                    ),
                    SwitchListTile(
                      title: Text('Show Incoming Calls'),
                      value: true,
                      onChanged: (value) {
                        // Update show incoming calls state
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.0), // Margin e inferiore
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScanScreen(),
              ),
            );
          },
          child: Icon(Icons.bluetooth_searching),
        ),
      ),
    );
  }
}
