import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'controllers/device_controller.dart';
import 'flutter_foreground_task.dart';
import 'screens/main_screen.dart';
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
  runApp(const UIApp());
}

class UIApp extends StatelessWidget {
  const UIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
      },
    );
  }
}
