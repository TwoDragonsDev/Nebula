import 'package:Nebula/utils/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/device_controller.dart';
import 'device_connection.dart';
import 'mio_bio.dart';
import 'screens/ResumeRoutePage.dart';
import 'screens/example_page.dart';
import 'screens/scan_screen.dart';
import 'services/init_services.dart';
import 'utils/snackbar.dart';
import 'widgets/smartwatch_info.dart';
import 'package:get/get.dart';

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  ApplicationController controller = ApplicationController();
  Get.put(controller);
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  ApplicationController controller = ApplicationController();
  Get.put(controller);
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const ExamplePage(),
        '/resume-route': (context) => const ResumeRoutePage(),
      },
    );
  }
}
