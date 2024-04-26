import 'dart:typed_data';

//Options:
/* Default
   No notifications
   Silent
   Vibrate
   Strong vibration
   Ringtone */

class AppInfoData {
  String name;
  String packageName;
  Uint8List? icon;
  //Not from app info
  String option;

  AppInfoData({
    required this.name,
    required this.packageName,
    required this.icon,
    //Not from app info
    required this.option,
  });

  factory AppInfoData.fromJson(Map<String, dynamic> json) {
    return AppInfoData(
      name: json['name'],
      packageName: json['packageName'],
      icon: _getImageBinary(json['icon']),
      option: json['option'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'packageName': packageName,
        'icon': icon,
        'option': option,
      };
}

Uint8List _getImageBinary(dynamicList) {
  List<int> intList =
      dynamicList.cast<int>().toList(); //This is the magical line.
  Uint8List data = Uint8List.fromList(intList);
  return data;
}
