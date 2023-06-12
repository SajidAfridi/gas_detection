// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gas_detection/screens/Menu.dart';
import '../common/app_colors.dart';
import '../widgets/button_style.dar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_paint_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final databaseReference = FirebaseDatabase.instance.ref().child('test');
  late DatabaseReference _tempRef;
  late DatabaseReference _fanStatusRef;
  late DatabaseReference _valveStatusRef;
  late DatabaseReference _smokeRef;
  late DatabaseReference _fireRef;
  late DatabaseReference _gasRef;
  String Gas = '0';
  String Smoke = '0';
  String Temp = '0';
  String Fan = 'false';
  String Valve = 'false';
  String Fire = '';

  void _launchCaller(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _tempRef = databaseReference.child('temp');
    _fanStatusRef = databaseReference.child('fan_status');
    _valveStatusRef = databaseReference.child('valve_status');
    _smokeRef = databaseReference.child('smoke');
    _fireRef = databaseReference.child('fire');
    _gasRef = databaseReference.child('gas');

    _fanStatusRef.onValue.listen((event) {
      setState(() {
        Fan = event.snapshot.value.toString();
      });
    });

    _valveStatusRef.onValue.listen((event) {
      setState(() {
        Valve = event.snapshot.value.toString();
      });
    });

    _tempRef.onValue.listen((event) {
      setState(() {
        Temp = event.snapshot.value.toString();
      });
    });

    _gasRef.onValue.listen((event) {
      setState(() {
        Gas = event.snapshot.value.toString();
      });
    });

    _smokeRef.onValue.listen((event) {
      setState(() {
        Smoke = event.snapshot.value.toString();
      });
    });

    _fireRef.onValue.listen((event) {
      setState(() {
        if (event.snapshot.value.toString() == 'false') {
          Fire = 'No';
        } else if (event.snapshot.value.toString() == 'true') {
          Fire = 'Off';
        } else {
          Fire = 'None';
        }
      });
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(message.notification?.title ?? ''),
            content: Text(message.notification?.body ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.scaffoldBg,
        body: FutureBuilder(
          future: _fApp,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        const Text(
                          'Gas Detection System',
                          style: TextStyle(
                            color: Colours.fontColor2,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colours.fontColor2,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colours.containerBg,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colours.themeColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.16,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    'GAS:',
                                    style: TextStyle(
                                      color: Colours.fontColor1,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.25,
                                    height:
                                        MediaQuery.of(context).size.width * 0.25,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final chartSize = constraints.maxWidth;
                                        final indicatorSize = chartSize * 0.2;

                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CustomPaint(
                                              size: Size(chartSize, chartSize),
                                              painter: ChartPainter(
                                                double.parse(Gas) / 100,
                                                // Convert Gas to a numeric type
                                                indicatorSize,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${Gas.toString()}%',
                                                style: const TextStyle(
                                                  color: Colours.fontColor1,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colours.themeColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.11,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          'SMOKE',
                                          style: TextStyle(
                                            color: Colours.fontColor1,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final chartSize =
                                                  constraints.maxWidth;
                                              final indicatorSize =
                                                  chartSize * 0.2;

                                              return Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  CustomPaint(
                                                    size: Size(
                                                        chartSize, chartSize),
                                                    painter: ChartPainter(
                                                      double.parse(Smoke) / 100,
                                                      // Convert Gas to a numeric type
                                                      indicatorSize,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '${Smoke.toString()}%',
                                                      style: const TextStyle(
                                                        color:
                                                            Colours.fontColor1,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colours.themeColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.11,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'FIRE: $Fire',
                                        style: const TextStyle(
                                          color: Colours.fontColor1,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Text(
                              'Temperature: $Temp °C',
                              style: const TextStyle(
                                color: Colours.fontColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    const Center(
                      child: Text(
                        'Control System',
                        style: TextStyle(
                          color: Colours.fontColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        width: MediaQuery.of(context).size.width * 0.87,
                        decoration: const BoxDecoration(
                          color: Colours.scaffoldBg,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colours.containerBg,
                              spreadRadius: 6,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    toggleValveStatus();
                                  },
                                  style: buttonStyle,
                                  child: Text(
                                    'Valve: $Valve',
                                    style: const TextStyle(
                                      color: Colours.fontColor1,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    toggleFanStatus();
                                  },
                                  style: buttonStyle,
                                  child: Text(
                                    'Fan: $Fan',
                                    style: const TextStyle(
                                      color: Colours.fontColor1,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  style: buttonStyle,
                                  onPressed: () {
                                    _launchCaller('1122');
                                  },
                                  child: const Text(
                                    'Call Emergency',
                                    style: TextStyle(
                                      color: Colours.fontColor1,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void toggleValveStatus() {
    _databaseReference.child('test').update({
      'valve_status': Valve == 'true' ? false : true,
    });
  }

  void toggleFanStatus() {
    _databaseReference.child('test').update({
      'fan_status': Fan == 'true' ? false : true,
    });
  }
}
