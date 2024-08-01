import 'package:face_camera/face_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'features/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize(); //Add this
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

// Future<bool> startForegroundService() async {
//   const androidConfig = FlutterBackgroundAndroidConfig(
//     notificationTitle: 'HSBC',
//     notificationText: 'HSBC Assistant',
//     notificationImportance: AndroidNotificationImportance.Default,
//     notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
//   );
//   await FlutterBackground.initialize(androidConfig: androidConfig);
//   return FlutterBackground.enableBackgroundExecution();
// }
