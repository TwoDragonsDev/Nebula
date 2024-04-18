import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_info.dart';

class ApplicationsConfigurationPage extends StatefulWidget {
  const ApplicationsConfigurationPage({Key? key}) : super(key: key);

  @override
  _ApplicationsConfigurationPageState createState() =>
      _ApplicationsConfigurationPageState();
}

class _ApplicationsConfigurationPageState
    extends State<ApplicationsConfigurationPage> {
  final List<String> _options = ['none', 'normal', 'strong', 'ringtone'];

  List<AppInfoData> _myApps = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInstalledApps();
  }

  Future<void> _loadInstalledApps() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMyApps = prefs.getStringList('myApps');
    if (savedMyApps != null) {
      setState(() {
        _myApps = savedMyApps
            .map((myApp) => AppInfoData.fromJson(json.decode(myApp)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification setting'),
        leading: BackButton(),
      ),
      body: ListView.builder(
        itemCount: _myApps.length,
        itemBuilder: (context, index) {
          AppInfoData appInfo = _myApps[index];
          String appName = appInfo.name;
          String packageName = appInfo.packageName;
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
              subtitle: Text(packageName),
              trailing: DropdownButton<String>(
                value: appInfo.option,
                onChanged: (String? newValue) {
                  setState(() {
                    appInfo.option = newValue!;
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
