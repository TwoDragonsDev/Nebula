import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        toggleableActiveColor: Colors.orange,
      ),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isConnected = true;
  bool findMyWatch = true;
  bool syncTime = true;
  bool silencePhone = false;
  bool showIncomingCalls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('19:28'),
        actions: [
          Icon(Icons.battery_full),
          SizedBox(width: 4),
          Text('58%'),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.bluetooth_connected),
            title: Text('Connesso'),
            trailing: Text(isConnected ? '100%' : '0%'),
            onTap: () {
              // Navigate to Bluetooth settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud),
            title: Text('Impostazioni meteo'),
            onTap: () {
              // Navigate to Weather settings page
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.watch),
            title: Text('Trova il mio orologio'),
            value: findMyWatch,
            onChanged: (bool value) {
              setState(() {
                findMyWatch = value;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.screenshot),
            title: Text('Cattura schermo'),
            onTap: () {
              // Navigate to Screenshot settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Impostazioni notifiche'),
            onTap: () {
              // Navigate to Notification settings page
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.access_time),
            title: Text('Sincronizza ora'),
            value: syncTime,
            onChanged: (bool value) {
              setState(() {
                syncTime = value;
              });
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.phone_disabled),
            title: Text('Silenzio il telefono quando è collegato'),
            value: silencePhone,
            onChanged: (bool value) {
              setState(() {
                silencePhone = value;
              });
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.phone_in_talk),
            title: Text('Mostra chiamate in arrivo'),
            value: showIncomingCalls,
            onChanged: (bool value) {
              setState(() {
                showIncomingCalls = value;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.bluetooth_searching),
        onPressed: () {
          // Implement Bluetooth search functionality
        },
      ),
    );
  }
}
