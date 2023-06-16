import 'package:face_recognition/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'camera_detector.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face zint3ch',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          '/': (BuildContext context) => const CameraDetector(),
        },
      ),
    );
  }
}
