import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../models/smartwatch_device_info.dart';

class ApplicationController extends GetxController {
  Rx<BluetoothDevice> myDevice =
      BluetoothDevice(remoteId: DeviceIdentifier("")).obs;

  Rx<SmartwatchDeviceInfo> myDeviceInfo = SmartwatchDeviceInfo(
    deviceName: '',
    deviceAddress: '',
    isConnected: false,
    batteryPercentage: 0,
  ).obs;

  final Map<String, String> notificationIcons = {
    "code.name.monkey.retromusic": "ios-musical-notes",
    "com.android.chrome": "logo-chrome",
    "com.android.dialer": "ios-call",
    "com.android.mms": "ios-text",
    "com.android.vending": "md-appstore",
    "com.chrome.beta": "logo-chrome",
    "com.chrome.dev": "logo-chrome",
    "com.devhd.feedly": "logo-rss",
    "com.dropbox.android": "logo-dropbox",
    "com.facebook.groups": "logo-facebook",
    "com.facebook.katana": "logo-facebook",
    "com.facebook.Mentions": "logo-facebook",
    "com.facebook.orca": "ios-text",
    "com.facebook.work": "logo-facebook",
    "com.google.android.apps.docs.editors.docs": "ios-document",
    "com.google.android.apps.giant": "md-analytics",
    "com.google.android.apps.maps": "ios-map",
    "com.google.android.apps.messaging": "ios-text",
    "com.google.android.apps.photos": "ios-images",
    "com.google.android.apps.plus": "logo-googleplus",
    "com.google.android.calendar": "ios-calendar",
    "com.google.android.contacts": "ios-contacts",
    "com.google.android.dialer": "ios-call",
    "com.google.android.gm": "ios-mail",
    "com.google.android.googlequicksearchbox": "logo-google",
    "com.google.android.music": "ios-musical-notes",
    "com.google.android.talk": "ios-quote",
    "com.google.android.videos": "ios-film",
    "com.google.android.youtube": "logo-youtube",
    "com.instagram.android": "logo-instagram",
    "com.instagram.boomerang": "logo-instagram",
    "com.instagram.layout": "logo-instagram",
    "com.jb.gosms": "ios-text",
    "com.joelapenna.foursquared": "logo-foursquare",
    "com.keylesspalace.tusky": "md-mastodon",
    "com.keylesspalace.tusky.test": "md-mastodon",
    "com.linkedin.android.jobs.jobseeker": "logo-linkedin",
    "com.linkedin.android.learning": "logo-linkedin",
    "com.linkedin.android": "logo-linkedin",
    "com.linkedin.android.salesnavigator": "logo-linkedin",
    "com.linkedin.Coworkers": "logo-linkedin",
    "com.linkedin.leap": "logo-linkedin",
    "com.linkedin.pulse": "logo-linkedin",
    "com.linkedin.recruiter": "logo-linkedin",
    "com.mattermost.rnbeta": "logo-mattermost",
    "com.mattermost.rn": "logo-mattermost",
    "com.maxfour.music": "ios-musical-notes",
    "com.microsoft.office.lync15": "logo-skype",
    "com.microsoft.xboxone.smartglass.beta": "logo-xbox",
    "com.microsoft.xboxone.smartglass": "logo-xbox",
    "com.noinnion.android.greader.reader": "logo-rss",
    "com.pinterest": "logo-pinterest",
    "com.playstation.mobilemessenger": "logo-playstation",
    "com.playstation.remoteplay": "logo-playstation",
    "com.playstation.video": "logo-playstation",
    "com.reddit.frontpage": "logo-reddit",
    "com.runtastic.android": "ios-walk",
    "com.runtastic.android.pro2": "ios-walk",
    "com.scee.psxandroid": "logo-playstation",
    "com.sec.android.app.music": "ios-musical-notes",
    "com.skype.android.access": "logo-skype",
    "com.skype.raider": "logo-skype",
    "com.snapchat.android": "logo-snapchat",
    "com.sonyericsson.conversations": "ios-text",
    "com.spotify.music": "ios-musical-notes",
    "com.tinder": "md-flame",
    "com.tumblr": "logo-tumblr",
    "com.twitter.android": "logo-twitter",
    "com.valvesoftware.android.steam.community": "logo-steam",
    "com.vimeo.android.videoapp": "logo-vimeo",
    "com.whatsapp": "logo-whatsapp",
    "com.yahoo.mobile.client.android.atom": "logo-yahoo",
    "com.yahoo.mobile.client.android.finance": "logo-yahoo",
    "com.yahoo.mobile.client.android.im": "logo-yahoo",
    "com.yahoo.mobile.client.android.mail": "logo-yahoo",
    "com.yahoo.mobile.client.android.search": "logo-yahoo",
    "com.yahoo.mobile.client.android.sportacular": "logo-yahoo",
    "com.yahoo.mobile.client.android.weather": "logo-yahoo",
    "de.number26.android": "ios-card",
    "flipboard.app": "logo-rss",
    "im.vector.app": "ios-chatbubbles-outline",
    "it.hype.app": "ios-card",
    "net.etuldan.sparss.floss": "logo-rss",
    "net.frju.flym": "logo-rss",
    "net.slideshare.mobile": "logo-linkedin",
    "org.buffer.android": "logo-buffer",
    "org.kde.kdeconnect_tp": "md-phone-portrait",
    "org.telegram.messenger": "ios-paper-plane",
    "org.thoughtcrime.securesms": "logo-signal",
    "org.thunderdog.challegram": "ios-paper-plane",
    "org.joinmastodon.android": "md-mastodon",
    "org.wordpress.android": "logo-wordpress",
    "tv.twitch.android.app": "logo-twitch",
    "ws.xsoh.etar": "ios-calendar"
  };

  final Rx<BluetoothCharacteristic?> pushNotificationsService =
      (null as BluetoothCharacteristic?).obs;

  void setDevice(BluetoothDevice device) {
    myDevice.value = device;
  }

  void disconnectDevice() {
    myDevice.value = BluetoothDevice(remoteId: DeviceIdentifier(""));
  }

  void setDeviceInfo(SmartwatchDeviceInfo deviceInfo) {
    myDeviceInfo.value = deviceInfo;
  }

  void setDeviceInfoName(String deviceInfoName) {
    myDeviceInfo.value = SmartwatchDeviceInfo(
      deviceName: deviceInfoName,
      deviceAddress: myDeviceInfo.value.deviceAddress,
      isConnected: myDeviceInfo.value.isConnected,
      batteryPercentage: myDeviceInfo.value.batteryPercentage,
    );
  }

  void setDeviceInfoBattery(int batteryPercentage) {
    myDeviceInfo.value = SmartwatchDeviceInfo(
      deviceName: myDeviceInfo.value.deviceName,
      deviceAddress: myDeviceInfo.value.deviceAddress,
      isConnected: myDeviceInfo.value.isConnected,
      batteryPercentage: batteryPercentage,
    );
  }

  void setPushNotificationService(BluetoothCharacteristic data) {
    pushNotificationsService.value = data;
  }
}
