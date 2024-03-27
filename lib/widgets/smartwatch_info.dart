import 'package:flutter/material.dart';
import '../controllers/device_controller.dart';
import '../screens/device_screen.dart';
import 'package:get/get.dart';

class BluetoothDeviceInfoWidget extends StatelessWidget {
  final ApplicationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.watch, size: 64.0),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      controller.myDeviceInfo.value.deviceName,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Identifier: ${controller.myDevice.value.remoteId}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      controller.myDevice.value.isConnected
                          ? 'Connected'
                          : 'Not Connected',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: controller.myDevice.value.isConnected
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.battery_full, size: 16.0),
                        SizedBox(width: 4.0),
                        Text(
                          '${controller.myDeviceInfo.value.batteryPercentage}%',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: controller.myDevice.value.isConnected,
            child: Positioned(
              top: 8.0,
              right: 8.0,
              child: IconButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) =>
                        DeviceScreen(device: controller.myDevice.value),
                    settings: RouteSettings(name: '/DeviceScreen'),
                  );
                  Navigator.of(context).push(route);
                },
                icon: Icon(Icons.construction, size: 32.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
