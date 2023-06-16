import 'dart:async';
import 'dart:collection';
import 'dart:io';
// import 'dart:typed_data';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
// import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart' hide Image;

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();
  factory AuthService() {
    return _instance;
  }

  final _dio = Dio();

  // Create storage
  final _storage = const FlutterSecureStorage();

  // late String ip = "192.168.100.105";
  // late String deviceid = "100136de95";

  late String ip = "";
  late String deviceid = "";
  late List<String> ips = [];

  Future getConfig() async {
    deviceid = await getDeviceId();
    ip = await getIp();
  }

  Future saveDevideId(String deviceId) async {
    await _storage.write(
      key: 'deviceId',
      value: deviceId,
    );
  }

  Future<String> getDeviceId() async {
    final deviceId = await _storage.read(key: 'deviceId');
    print(deviceId);
    return deviceId.toString();
  }

  Future saveIp(String ip) async {
    await _storage.write(
      key: 'ip',
      value: ip,
    );
  }

  Future<String> getIp() async {
    final ip = await _storage.read(key: 'ip');
    return ip.toString();
  }

  Future<bool> changeStatus(String status) async {
    final data = {
      "deviceid": deviceid,
      "data": {
        "switch": status,
      }
    };

    try {
      final resp = await _dio.post(
        'http://$ip:8081/zeroconf/switch',
        data: data,
      );

      debugPrint(resp.toString());
      return false;
    } catch (e) {
      return false;
    }
  }

  // changeValues(String ipNew, String idNew) async {
  //   ip = ipNew;
  //   deviceid = idNew;
  // }

  Future<void> scanNetwork() async {
    final interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var address in interface.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          final subnet = Uint8List.fromList(address.rawAddress);
          subnet[3] = 0; // Set last byte to 0 to get network address
          final networkAddress = InternetAddress.fromRawAddress(subnet);
          print(networkAddress);
          for (var i = 1; i <= 254; i++) {
            final hostBytes = List<int>.from(subnet); // Create a copy of subnet
            hostBytes[3] = i; // Set the last byte of the host address to i
            final host = InternetAddress.fromRawAddress(
              Uint8List.fromList(
                hostBytes,
              ),
            );
            if (host.rawAddress[3] == address.rawAddress[3]) {
              // Skip the IP address of the local device
              continue;
            }
            try {
              final socket = await Socket.connect(
                host,
                8081,
                //8080,
                timeout: Duration(
                  milliseconds: 300,
                ),
              );
              print(
                'Dispositivo Sonoff encontrado en: $host',
              );
              ips.add(host.address);
              List<String> result = LinkedHashSet<String>.from(ips).toList();
              ips = result;
              socket.destroy();
            } catch (e) {
              //print(e);
            }
          }
        }
      }
    }
  }

  Future getInfoDivece({required String ip}) async {
    final data = {
      "deviceid": "",
      "data": {},
    };

    try {
      final resp = await _dio.post(
        'http://$ip:8081/zeroconf/info',
        data: data,
      );

      print(resp.data["data"]["deviceid"]);
      return resp.data["data"]["deviceid"];
    } catch (e) {
      return false;
    }
  }

  Future rekognition() async {
    final ByteData bytes = await rootBundle.load('assets/face.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final service = Rekognition(
      region: "us-east-1",
      credentials: AwsClientCredentials(
        accessKey: "AKIATK5OHAXZX74DY64A",
        secretKey: "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",
      ),
    );

    final result = await service.searchFacesByImage(
      collectionId: "UsersTestL",
      maxFaces: 1,
      faceMatchThreshold: 99,
      image: Image(
        bytes: list,
      ),
    );

    print(result);
  }

  // Future s3UploadImage() async {
  //   final service = AwsS3.uploadFile(
  //     accessKey: "AKxxxxxxxxxxxxx",
  //     secretKey: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
  //     file: File("path_to_file"),
  //     bucket: "bucket_name",
  //     region: "us-east-2",
  //     metadata: {"test": "test"},
  //   );
  // }
}
