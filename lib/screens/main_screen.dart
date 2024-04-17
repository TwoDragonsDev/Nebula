import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import '../device_connection.dart';
import '../flutter_foreground_task.dart';
import '../main.dart';
import '../permissions.dart';
import '../widgets/smartwatch_info.dart';
import 'scan_screen.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.watch,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              '80%',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Naviga alla pagina delle impostazioni meteo
                  },
                  child: Text('Weather Settings'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Naviga alla pagina di ricerca dell'orologio
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
                    // Esegui uno screenshot dello smartwatch
                  },
                  child: Text('Take Screenshot'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Naviga alla pagina delle impostazioni delle notifiche
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
                  value: true, // Valore booleano per la sincronizzazione ora
                  onChanged: (value) {
                    // Aggiorna lo stato della sincronizzazione ora
                  },
                ),
                SwitchListTile(
                  title: Text('Silence Phone on Connect'),
                  value: true, // Valore booleano per il silenzio del telefono
                  onChanged: (value) {
                    // Aggiorna lo stato del silenzio del telefono
                  },
                ),
                SwitchListTile(
                  title: Text('Show Incoming Calls'),
                  value:
                      true, // Valore booleano per la visualizzazione delle chiamate in arrivo
                  onChanged: (value) {
                    // Aggiorna lo stato della visualizzazione delle chiamate in arrivo
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
