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

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  ApplicationController controller = ApplicationController();
  Get.put(controller);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: InfoPage(),
    );
  }
}

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final ApplicationController controller = Get.find();

  @override
  void initState() {
    super.initState();
    connectToDevice();
  }

  Future<void> connectToDevice() async {
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
        setState(() {
          controller.myDevice.value = controller.myDevice.value;
        });
        initServices();
      } else {
        Snackbar.show(ABC.c, "UUID or Device Name is empty", success: false);
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    }
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nebula'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BluetoothDeviceInfoWidget(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.0), // Margine inferiore
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut((() => ApplicationController()));
  }
}
