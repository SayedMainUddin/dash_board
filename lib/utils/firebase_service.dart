import 'package:dash_board/utils/local_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class FirebaseApi  {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async{
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final fCMToken=await messaging.getToken();
    LocalStorage.FcmTOKEN=fCMToken!;
    print('Admin granted permission: ${fCMToken}');


  }

}
/*
Future<void> displayIncomingCall(String uuid) async {

  final config = CallKeepIncomingConfig(
    uuid: uuid,
    callerName: 'Hien Nguyen',
    appName: 'CallKeep',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    hasVideo: false,
    duration: 30000,
    acceptText: 'Accept',
    declineText: 'Decline',
    missedCallText: 'Missed call',
    callBackText: 'Call back',
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    androidConfig: CallKeepAndroidConfig(
      logo: "ic_logo",
      showCallBackAction: true,
      showMissedCallNotification: true,
      ringtoneFileName: 'system_ringtone_default',
      accentColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      incomingCallNotificationChannelName: 'Incoming Calls',
      missedCallNotificationChannelName: 'Missed Calls',
    ),
    iosConfig: CallKeepIosConfig(
      iconName: 'CallKitLogo',
      handleType: CallKitHandleType.generic,
      isVideoSupported: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtoneFileName: 'system_ringtone_default',
    ),
  );
  await CallKeep.instance.displayIncomingCall(config);
}*/
