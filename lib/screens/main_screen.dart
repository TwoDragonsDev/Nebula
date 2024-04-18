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
  Future<bool> _startForegroundTask() async {
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
      body: Center(
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
                      '80%',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      'Device Name',
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
      ),
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
