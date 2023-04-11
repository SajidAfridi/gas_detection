import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../widgets/elevatedButtons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  final databaseReference = FirebaseDatabase.instance.ref().child('test');
  String Gas = '0';
  String Smoke = '0';
  String Temp = '0';
  String Fire = '';

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
                final temp =
                    FirebaseDatabase.instance.ref().child('test').child('temp');
                final smoke = FirebaseDatabase.instance
                    .ref()
                    .child('test')
                    .child('smoke');
                final fire =
                    FirebaseDatabase.instance.ref().child('test').child('fire');
                final gas =
                    FirebaseDatabase.instance.ref().child('test').child('gas');
                gas.onValue.listen((event) {
                  setState(() {
                    Gas = event.snapshot.value.toString();
                  });
                });
                temp.onValue.listen((event) {
                  setState(() {
                    Temp = event.snapshot.value.toString();
                  });
                });
                smoke.onValue.listen((event) {
                  setState(() {
                    Smoke = event.snapshot.value.toString();
                  });
                });
                fire.onValue.listen((event) {
                  setState(
                    () {
                      if (event.snapshot.value.toString() == 'false') {
                        Fire = 'No';
                      } else if(event.snapshot.value.toString() == 'true') {
                        Fire = 'Yes';
                      }
                      else {
                        Fire = 'None';
                      }
                    },
                  );
                });

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      const Text(
                        '    Gas Detection System',
                        style: TextStyle(
                          color: Colours.fontColor2,
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                        ),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colours.themeColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.16,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Center(
                                  child: Text(
                                    'GAS: $Gas',
                                    style: const TextStyle(
                                      color: Colours.fontColor1,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.11,
                                      width: MediaQuery.of(context).size.width *
                                          0.33,
                                      child: Center(
                                        child: Text(
                                          'SMOKE: $Smoke',
                                          style: const TextStyle(
                                            color: Colours.fontColor1,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colours.themeColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.11,
                                      width: MediaQuery.of(context).size.width *
                                          0.33,
                                      child: Center(
                                        child: Text(
                                          'FIRE: $Fire',
                                          style: const TextStyle(
                                            color: Colours.fontColor1,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
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
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: elevatedButton('Value Cut: OFF'),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: elevatedButton('Fans: Turn ON'),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: elevatedButton('Call Emergency'),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.23,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: const BoxDecoration(
                            color: Colours.containerBg,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications,
                                    color: Colours.themeColor,
                                    size: 45,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              const Text(
                                '00',
                                style: TextStyle(
                                  color: Colours.fontColor2,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  color: Colours.fontColor2,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
    );
  }
}
// StreamBuilder(
// stream: databaseReference.child('data').onValue,
// builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return CircularProgressIndicator(); // show progress indicator while waiting for data
// }
// if (snapshot.hasError) {
// return Text('Error: ${snapshot.error}');
// }
// if (!snapshot.hasData) {
// return Text('No data found');
// }
// final data = snapshot.data!.snapshot.value;
// return
// },
// ),
