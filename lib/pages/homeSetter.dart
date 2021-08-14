import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/services/user.dart';

class HomeSetterPage extends StatefulWidget {
  HomeSetterPage({Key? key}) : super(key: key);
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static AppUser? mainUser;
  static setMainUser(User? user) async {
    var u = await HomeSetterPage.store.collection('users').doc(user!.uid).get();
    HomeSetterPage.mainUser = AppUser(
      id: HomeSetterPage.auth.currentUser!.uid,
      cName: u.data()!['cname'],
      cNumber: int.parse(u.data()!['cnumber']),
      fullName: u.data()!['fullname'],
      college: u.data()!['college'],
      email: u.data()!['email'],
      intake: int.parse(u.data()!['intake']),
      lat: u.data()!['lat'],
      long: u.data()!['long'],
      pAlways: u.data()!['palways'],
      pLocation: u.data()!['plocation'],
      pMaps: u.data()!['pmaps'],
      pPhone: u.data()!['pphone'],
      photoUrl: u.data()!['photourl'],
      phone: u.data()!['phone'],
      timeStamp: DateTime.parse(u.data()!['lastonline']),
      premium: u.data()!['premium'],
      verified: u.data()!['verified'],
      celeb: u.data()!['celeb'],
      bountyHead: u.data()!['bountyhead'],
      bountyHunter: u.data()!['bountyhunter'],
    );
  }

  @override
  _HomeSetterPageState createState() => _HomeSetterPageState();
}

class _HomeSetterPageState extends State<HomeSetterPage> {
  User? user;

  loggedInNotifier() {
    setState(() {});
  }

  @override
  void initState() {
    user = HomeSetterPage.auth.currentUser;
    if (user != null) {
      HomeSetterPage.setMainUser(user!);
    }
    HomeSetterPage.auth.authStateChanges().listen(
      (user) {
        if (mounted) {
          if (this.user != user) {
            setState(
              () {
                this.user = user;
                if (user != null) {
                  HomeSetterPage.setMainUser(user);
                } else {
                  HomeSetterPage.mainUser = null;
                }
              },
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      if (HomeSetterPage.mainUser == null) HomeSetterPage.setMainUser(user);
      return FutureBuilder(
        future: HomeSetterPage.store.collection('users').doc(user!.uid).get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.data() == null) {
                return CompleteAccountPage(
                  loggedInNotifier: loggedInNotifier,
                );
              } else {
                // Display home
                return RealHome();
              }
            }
          }
          return Scaffold();
        },
      );
    } else {
      // return RealHome();
      return LoginPage();
    }
  }
}

class CompleteAccountPage extends StatefulWidget {
  CompleteAccountPage({required this.loggedInNotifier});

  final Function loggedInNotifier;

  @override
  _CompleteAccountPageState createState() => _CompleteAccountPageState();
}

class _CompleteAccountPageState extends State<CompleteAccountPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController cNumberTextController = TextEditingController();
  TextEditingController cNameTextController = TextEditingController();
  TextEditingController intakeTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  bool locationAccess = true;
  bool alwaysAccess = false;
  bool phoneAccess = false;
  bool useRegularEmail = false;

  bool inProgress = false;

  String college = 'Pick your college';

  List<String> colleges = [
    'Pick your college',
    'MGCC',
    'JGCC',
    'FGCC',
    'SCC',
    'CCC',
    'PCC',
    'RCC',
    'JCC',
    'FCC',
    'CCR',
    'MCC',
  ];

  @override
  void dispose() {
    fullNameTextController.dispose();
    cNumberTextController.dispose();
    cNameTextController.dispose();
    intakeTextController.dispose();
    phoneTextController.dispose();
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Text(
                      'Complete Account',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 40),
                    child: Text(
                      'Please provide us with the necessary information to set up your account.',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: TextFormField(
                        controller: fullNameTextController,
                        obscureText: false,
                        cursorColor: Colors.grey[800],
                        decoration: InputDecoration(
                          hintText: 'Full Name*',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.account_box_rounded),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: TextFormField(
                        controller: cNameTextController,
                        obscureText: false,
                        cursorColor: Colors.grey[800],
                        decoration: InputDecoration(
                          hintText: 'Cadet Name* -e.g. Rashid',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.perm_identity_rounded),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Cadet name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: cNumberTextController,
                            obscureText: false,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                              hintText: 'Cadet Number*',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(Icons.book),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Cadet Number is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              Icons.house,
                            ),
                          ),
                        ),
                        value: college,
                        isDense: true,
                        onChanged: (value) {
                          setState(() {
                            college = value! as String;
                          });
                        },
                        items: colleges.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (college == 'Pick your college') {
                            return 'Please pick your college';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: intakeTextController,
                            obscureText: false,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                              hintText: 'Intake Year*',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(Icons.date_range),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Intake year is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
                    child: Text(
                      'Contact Info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailTextController,
                            obscureText: false,
                            enabled: !useRegularEmail,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                              hintText: 'Contact E-mail*',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                  child: Icon(
                                    Icons.alternate_email,
                                  )),
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Contact e-mail is required';
                              }
                              if (!val.contains('@') ||
                                  !val.contains('.') ||
                                  val.endsWith('@') ||
                                  val.endsWith('.')) {
                                return 'Please provide a valid E-mail';
                              }
                              var temp = val;
                              List a = temp.split('@');
                              if (a.length > 2)
                                return 'Please provide a valid E-mail';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: CheckboxListTile(
                          value: useRegularEmail,
                          title: Text(
                            'Use login e-mail',
                            maxLines: 2,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          activeColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                emailTextController.text =
                                    HomeSetterPage.auth.currentUser!.email!;
                              } else {
                                emailTextController.text = '';
                              }
                              useRegularEmail = value;
                            });
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: phoneTextController,
                            obscureText: false,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                              hintText: 'Phone',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(Icons.phone),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              if (phoneTextController.text == '') {
                                phoneAccess = false;
                              }
                              setState(() {});
                            },
                            validator: (val) {
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: CheckboxListTile(
                          value: phoneAccess,
                          title: Text('Make phone number public'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          activeColor: Colors.black,
                          onChanged: phoneTextController.text == ''
                              ? null
                              : (value) {
                                  setState(() {
                                    phoneAccess = value!;
                                  });
                                }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: CheckboxListTile(
                          value: !locationAccess,
                          title: Text(
                            'Hide my exact location (Still show me in nearby result)',
                            maxLines: 2,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          activeColor: Colors.black,
                          onChanged: (value) {
                            getLocationPermission();
                            setState(() {
                              locationAccess = !value!;
                            });
                          }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 40),
                    child: Container(
                      width: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              //TODO Incomplete Cancel Account
                              Navigator.of(context).pushNamed('/cancel');
                            },
                            label: Text('Cancel'),
                            icon: Icon(
                              Icons.arrow_left_rounded,
                              size: 20,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              textStyle: MaterialStateProperty.all(
                                TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              elevation: MaterialStateProperty.all(0),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: inProgress
                                ? null
                                : () async {
                                    setState(() {
                                      inProgress = true;
                                    });
                                    if (formKey.currentState!.validate()) {
                                      String cName = cNameTextController.text;
                                      String first = cName[0];
                                      first = first.toUpperCase();
                                      cName = first + cName.substring(1);

                                      String fullName = '';
                                      var parts = fullNameTextController.text
                                          .split(' ');
                                      for (var each in parts) {
                                        first = each[0];
                                        first = first.toUpperCase();
                                        fullName +=
                                            first + each.substring(1) + ' ';
                                      }
                                      fullName = fullName.trim();

                                      try {
                                        await HomeSetterPage.auth.currentUser!
                                            .updateDisplayName(fullName);
                                        await HomeSetterPage.store
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .set(
                                          {
                                            'id': HomeSetterPage
                                                .auth.currentUser!.uid,
                                            'fullname': fullName,
                                            'intake': intakeTextController.text,
                                            'college': college,
                                            'cname': cName,
                                            'cnumber':
                                                cNumberTextController.text,
                                            'phone': phoneTextController.text,
                                            'email': HomeSetterPage
                                                .auth.currentUser!.email,
                                            'pphone': phoneAccess,
                                            'plocation': locationAccess,
                                            'palways': alwaysAccess,
                                            'pmaps': false,
                                            'premium': false,
                                            'verified': false,
                                            'photourl': HomeSetterPage.auth
                                                    .currentUser!.photoURL ??
                                                '',
                                            'celeb': false,
                                            'bountycount': 0,
                                            'bountyhead': true,
                                            'bountyhunter': true,
                                          },
                                        );
                                        HomeSetterPage.mainUser = AppUser(
                                          id: HomeSetterPage
                                              .auth.currentUser!.uid,
                                          cName: cName,
                                          cNumber: int.parse(
                                              cNumberTextController.text),
                                          fullName: fullName,
                                          college: college,
                                          email: FirebaseAuth
                                              .instance.currentUser!.email!,
                                          intake: int.parse(
                                              intakeTextController.text),
                                          pAlways: alwaysAccess,
                                          pLocation: locationAccess,
                                          pMaps: false,
                                          pPhone: phoneAccess,
                                          photoUrl: HomeSetterPage
                                                  .auth.currentUser!.photoURL ??
                                              '',
                                          phone: phoneTextController.text,
                                          premium: false,
                                          verified: false,
                                          timeStamp: DateTime.now(),
                                          celeb: false,
                                          bountyHead: true,
                                          bountyHunter: true,
                                        );
                                        widget.loggedInNotifier();
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    setState(() {
                                      inProgress = false;
                                    });
                                  },
                            label: Text('Continue'),
                            icon: Icon(
                              Icons.arrow_right_alt_rounded,
                              size: 20,
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              textStyle: MaterialStateProperty.all(
                                TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              elevation: MaterialStateProperty.all(0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLocationPermission() async {
    try {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          setState(() {
            print('Location service not enabled...');
          });
          return;
        }
        print('Location service enabled...');
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (!(_permissionGranted == PermissionStatus.granted ||
            _permissionGranted == PermissionStatus.grantedLimited)) {
          setState(() {
            print('Location permission denied...');
          });
          return;
        }
        print('Location permission granted...');
      }
    } catch (e) {
      print(e);
    }
  }
}
