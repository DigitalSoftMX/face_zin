import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'dart:io' show Platform;

enum ServerStatus {
  connecting,
  offline,
  online,
}

class SocketService with ChangeNotifier {
  late ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  // SocketService() {
  //   _initConfig();
  // }

  Function get emit => _socket.emit;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  void connet({required String location}) async {
    try {
      // Dart client
      _socket = IO.io(
        'https://face-rekonition.herokuapp.com/',
        // Platform.isAndroid
        //     ? 'http://10.0.2.2:3000'
        //     :
        // 'http://192.168.100.17:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders(
              {
                "Location": location,
              },
            )
            .build(),
      );

      _socket.onConnect(
        (_) {
          _serverStatus = ServerStatus.online;
          notifyListeners();
        },
      );

      _socket.onDisconnect(
        (_) {
          _serverStatus = ServerStatus.offline;
          notifyListeners();
        },
      );
    } catch (e) {
      print("aqui");
    }
  }

  void disconnet() {
    _socket.disconnect();
  }
}
