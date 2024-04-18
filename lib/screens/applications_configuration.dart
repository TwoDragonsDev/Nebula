import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class ApplicationsConfigurationPage extends StatefulWidget {
  const ApplicationsConfigurationPage({Key? key}) : super(key: key);
  @override
  _ApplicationsConfigurationPageState createState() =>
      _ApplicationsConfigurationPageState();
}

class _ApplicationsConfigurationPageState
    extends State<ApplicationsConfigurationPage> {
  final List<String> _options = [
    'Default',
    'No notifications',
    'Silent',
    'Vibrate',
    'Strong vibration',
    'Ringtone',
  ];

  final Map<AppInfo, String> _selections = {};

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
  }

  Future<void> _loadInstalledApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
    setState(() {
      for (var app in apps) {
        _selections[app] = 'Default';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification setting'),
        leading: BackButton(),
      ),
      body: ListView.builder(
        itemCount: _selections.length,
        itemBuilder: (context, index) {
          AppInfo appInfo = _selections.keys.elementAt(index);
          String appName = appInfo.name;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: CircleAvatar(
                child: ClipOval(
                  child: Image.memory(
                    appInfo.icon!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(appName),
              subtitle: Text(_selections.keys.elementAt(index).packageName),
              trailing: DropdownButton<String>(
                value: _selections[appInfo],
                onChanged: (String? newValue) {
                  setState(() {
                    _selections[appInfo] = newValue!;
                  });
                },
                items: _options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                underline: Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}
