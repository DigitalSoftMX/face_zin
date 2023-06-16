import 'package:face_recognition/helpers/helpers.dart';
import 'package:face_recognition/services/socket_service.dart';
import 'package:face_recognition/theme/colors_theme.dart';
import 'package:face_recognition/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'camera_detector.dart';
import 'services/auth_service.dart';
import 'models/locations.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Locations> divices = [];
  final authService = AuthService();
  // TextEditingController _textFieldController = TextEditingController();
  // TextEditingController _textFieldIdController = TextEditingController();
  late bool status = false;
  late bool loading = true;
  //late String ip = '';

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );

    authService.getConfig().then(
      (value) {
        final socketService = Provider.of<SocketService>(
          context,
          listen: false,
        );

        //if (authService.deviceid != "null") {
        socketService.connet(
          location: authService.deviceid,
        );
        socketService.socket.on(
          'open-door',
          _handleActiveBands,
        );
        socketService.socket.on(
          'active-bands',
          _handleActiveDivice,
        );
        //}
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(
      context,
      listen: false,
    );
    // socketService.socket.off('active-bands');
    socketService.disconnet();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: 10,
            ),
            child: (socketService.serverStatus == ServerStatus.online)
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.2),
              child: SizedBox(
                width: size.width * 0.35,
                height: size.width * 0.35,
                child: Lottie.asset(
                  'assets/lottie/face.json',
                  key: Key('homeLottie'),
                  fit: BoxFit.contain,
                  repeat: true,
                  reverse: true,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.3),
              child: Container(
                alignment: Alignment.center,
                width: size.width * 0.8,
                height: size.width * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Zint3ch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Reconocimiento facial',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.6),
              child: GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          authService.scanNetwork().then((value) {
                            loading = false;
                            setState(() {});
                          });
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Center(
                              child: Container(
                                width: size.width * 0.7,
                                height: size.height * 0.5,
                                decoration: BoxDecoration(
                                  color: MainColor.bgPrimary,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment(-0.8, -0.975),
                                      child: Container(
                                        width: size.width * 0.4,
                                        height: size.height * 0.05,
                                        alignment: Alignment.centerLeft,
                                        child: CustomText(
                                          color: MainColor.dark,
                                          fontWeight: FontWeight.bold,
                                          string: 'Dispositivos Sonoff',
                                          fontsize: size.height * 0.02,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(1, -1),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                        ),
                                      ),
                                    ),
                                    if (loading) ...[
                                      Center(
                                        child: LottieBuilder.asset(
                                          "assets/lottie/search.json",
                                        ),
                                      )
                                    ] else ...[
                                      Align(
                                        alignment: Alignment(0, 1),
                                        child: setupAlertDialoadContainer(
                                          ips: authService.ips,
                                          socketService: socketService,
                                          size: size,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).then(
                    (value) async {
                      await authService.getConfig();
                      setState(() {});
                    },
                  );
                  // _displayTextInputDialog(context).then(
                  //   (value) => setState(
                  //     () {
                  //       final authService = AuthService();

                  //       authService.changeValues(
                  //         _textFieldController.text,
                  //         _textFieldIdController.text,
                  //       );
                  //     },
                  //   ),
                  // );
                },
                child: Text(
                  'Configurar',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.95),
              child: SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (authService.ip != "" &&
                            authService.deviceid != "" &&
                            authService.ip != "null" &&
                            authService.deviceid != "null") {
                          // await authService.scanNetwork();
                          //await authService.rekognition();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraDetector(),
                              // builder: (context) =>  AWSPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              if (authService.ip != "" &&
                                  authService.deviceid != "" &&
                                  authService.ip != "null" &&
                                  authService.deviceid != "null") ...[
                                Colors.deepPurple,
                                Colors.deepPurple.shade200,
                              ] else ...[
                                Colors.deepPurple.withOpacity(0.5),
                                Colors.deepPurple.shade200.withOpacity(0.5),
                              ]
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Iniciar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        socketService.socket.emit('get-bands', {});
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Center(
                                    child: Container(
                                      width: size.width * 0.7,
                                      height: size.height * 0.5,
                                      decoration: BoxDecoration(
                                        color: MainColor.bgPrimary,
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment(-0.8, -0.975),
                                            child: Container(
                                              width: size.width * 0.4,
                                              height: size.height * 0.05,
                                              alignment: Alignment.centerLeft,
                                              child: CustomText(
                                                color: MainColor.dark,
                                                fontWeight: FontWeight.bold,
                                                string: 'Dispositivos Sonoff',
                                                fontsize: size.height * 0.02,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(1, -1),
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(
                                                Icons.close,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(0, 1),
                                            child:
                                                setupAlertDialoadContainerDivice(
                                              divices: divices,
                                              socketService: socketService,
                                              size: size,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );

                        // setState(() {});

                        // socketService.socket.emit(
                        //   'open-door',
                        //   {
                        //     "to": "100136ec0b",
                        //   },
                        // );
                      },
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade200,
                              Colors.deepPurple.shade800,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Abrir dispositivo externo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget setupAlertDialoadContainer({
    required List<String> ips,
    required SocketService socketService,
    required Size size,
  }) {
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.425,
      child: Stack(
        children: [
          if (ips.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              itemCount: ips.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.vpn_lock_rounded),
                  trailing: authService.ip == ips[index]
                      ? IconButton(
                          onPressed: () async {
                            authService.saveIp("null");
                            authService.saveDevideId("null");
                            await showAlert(
                              context: context,
                              title: "Configuración de dispositivo",
                              message: "Dispositivo quitado correctamente",
                            ).then(
                              (value) {
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: Icon(Icons.delete_forever))
                      : SizedBox(),
                  title: Text(ips[index]),
                  onTap: () async {
                    showLoading(context);
                    final reponse = await authService.getInfoDivece(
                      ip: ips[index],
                    );
                    if (reponse != false) {
                      authService.saveIp(ips[index]);
                      authService.saveDevideId(reponse);
                      await showAlert(
                        context: context,
                        title: "Configuración de dispositivo",
                        message: "La configuración se realizo correctamente",
                      ).then(
                        (value) {
                          socketService.connet(
                            location: authService.deviceid,
                          );
                          socketService.socket.on(
                            'active-bands',
                            _handleActiveBands,
                          );
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      showAlert(
                        context: context,
                        title: "Configuración de dispositivo",
                        message:
                            "No se pudo configurar el dispositivo, verifica la conexión",
                      );
                    }
                    //Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ] else ...[
            Center(
              child: CustomText(
                string: "No se encontraron dispositivos.",
                color: MainColor.dark,
                fontWeight: FontWeight.normal,
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget setupAlertDialoadContainerDivice({
    required List<Locations> divices,
    required SocketService socketService,
    required Size size,
  }) {
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.425,
      child: Stack(
        children: [
          if (divices.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              itemCount: divices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.perm_device_info_rounded),
                  title: Text(divices[index].name!),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraDetector(
                          externalValidation: true,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ] else ...[
            Center(
              child: CustomText(
                string: "No se encontraron dispositivos.",
                color: MainColor.dark,
                fontWeight: FontWeight.normal,
              ),
            )
          ]
        ],
      ),
    );
  }

  _handleActiveBands(dynamic payload) async {
    print("aqui $payload");

    await authService.changeStatus(payload["switch"]);

    // this.bands = (payload as List)
    //     .map(
    //       (band) => Lacations.fromMap(
    //         band,
    //       ),
    //     )
    //     .toList();

    setState(() {});
  }

  _handleActiveDivice(dynamic payload) {
    (payload as List).forEach(
      (element) {
        if (element["name"] != "null") {
          divices.add(Locations.fromMap(element));
        }
      },
    );
    var seen = Set<String>();
    List<Locations> uniquelist = divices
        .where(
          (divice) => seen.add(
            divice.name!,
          ),
        )
        .toList();

    this.divices = uniquelist;

    setState(() {});
  }
}
