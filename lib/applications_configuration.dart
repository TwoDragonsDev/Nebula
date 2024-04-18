import 'dart:convert';

import 'package:Nebula/models/app_info.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> ApplicationsConfiguration() async {
  final prefs = await SharedPreferences.getInstance();

  final savedMyApps = prefs.getStringList('myApps');
  if (savedMyApps != null) {
    return;
  }

  List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
  List<String> myApps = [];
  for (var app in apps) {
    AppInfoData myApp = AppInfoData(
        name: app.name,
        packageName: app.packageName,
        icon: app.icon,
        option: 'none');
    myApps.add(json.encode(myApp));
  }

  await prefs.setStringList('myApps', myApps);
}
