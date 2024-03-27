class SmartwatchDeviceInfo {
  final String deviceName;
  final String deviceAddress;
  final bool isConnected;
  final int batteryPercentage;

  SmartwatchDeviceInfo({
    required this.deviceName,
    required this.deviceAddress,
    required this.isConnected,
    required this.batteryPercentage,
  });
}
