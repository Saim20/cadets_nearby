import 'dart:developer';

import 'package:animate_icons/animate_icons.dart';
import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/bottom_sheet.dart';
import 'package:cadets_nearby/pages/ui_elements/verification_steps.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/settings_provider.dart';
import 'package:cadets_nearby/services/sign_out.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController cNumberTextController = TextEditingController();
  TextEditingController cNameTextController = TextEditingController();
  TextEditingController intakeTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController fbTextController = TextEditingController();
  TextEditingController instaTextController = TextEditingController();
  TextEditingController designationTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();

  AnimateIconController controller = AnimateIconController();

  bool locationAccess = true;
  bool phoneAccess = false;
  bool useRegularEmail = false;
  bool enableZoneMonitor = true;

  bool inProgress = false;

  String college = 'Pick your college*';
  String profession = 'Doctor';

  @override
  void dispose() {
    fullNameTextController.dispose();
    cNumberTextController.dispose();
    cNameTextController.dispose();
    intakeTextController.dispose();
    phoneTextController.dispose();
    emailTextController.dispose();
    fbTextController.dispose();
    instaTextController.dispose();
    designationTextController.dispose();
    addressTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    resetEdits();
    super.initState();
  }

  bool editingEnabled = false;
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: const TextStyle(color: Colors.black),
          iconTheme: const IconThemeData(color: Colors.black),
          systemOverlayStyle: systemUiOverlayStyle,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Form(
          key: formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 40.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          children: [
                            if (context.watch<MainUser>().user!.photoUrl == '')
                              Image.asset(
                                'assets/images/user.png',
                                fit: BoxFit.cover,
                              )
                            else
                              Image.network(
                                context.watch<MainUser>().user!.photoUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            if (editingEnabled)
                              Container(
                                color: Colors.black.withOpacity(0.65),
                                width: 80,
                                height: 80,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/dpchange');
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20.0,
                    child: AnimateIcons(
                      startIcon: Icons.edit,
                      endIcon: Icons.cancel,
                      startIconColor: Colors.white,
                      endIconColor: Colors.white,
                      controller: controller,
                      onStartIconPress: () {
                        controller.animateToEnd();
                        setState(() {
                          editingEnabled = true;
                        });
                        return true;
                      },
                      onEndIconPress: () {
                        controller.animateToStart();
                        setState(() {
                          editingEnabled = false;
                          resetEdits();
                        });
                        return true;
                      },
                    ),
                    // Icon(editingEnabled ? Icons.cancel : Icons.edit),
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.watch<MainUser>().user!.fullName,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    if (context.watch<MainUser>().user!.verified != 'yes')
                      const Icon(
                        Icons.info_rounded,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                    if (context.watch<MainUser>().user!.celeb)
                      const Icon(
                        Icons.verified,
                        size: 20,
                        color: Colors.green,
                      ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.watch<MainUser>().user!.cName,
                      style: const TextStyle(fontSize: 17.0),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      context.watch<MainUser>().user!.cNumber.toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    child: ElevatedButton.icon(
                      onPressed: !(!HomeSetterPage
                                  .auth.currentUser!.emailVerified ||
                              context.read<MainUser>().user!.verified != 'yes')
                          ? null
                          : () {
                              showBottomSheetWith(
                                  const [VerificationSteps()], context);
                            },
                      icon: const Icon(Icons.verified_user),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            (!HomeSetterPage.auth.currentUser!.emailVerified ||
                                    context.watch<MainUser>().user!.verified !=
                                        'yes')
                                ? Colors.red
                                : Colors.green),
                      ),
                      label: Text((!HomeSetterPage
                                  .auth.currentUser!.emailVerified ||
                              context.watch<MainUser>().user!.verified != 'yes')
                          ? 'Verification'
                          : 'Verified'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: fullNameTextController,
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Full Name*',
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.account_box_rounded),
                          ),
                        ),
                        style: TextStyle(
                          color: editingEnabled ? Colors.black : Colors.grey,
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            if (fullNameTextController.text !=
                                context.read<MainUser>().user!.fullName) {
                              hasChanged = true;
                            }
                          });
                        },
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
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: cNameTextController,
                        enabled: false,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Cadet Name* -e.g. Rashid',
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.perm_identity_rounded),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
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
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: cNumberTextController,
                        enabled: false,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Cadet Number*',
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.book),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Cadet Number is required';
                          }
                          if (!isInt(val)) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              Icons.house,
                            ),
                          ),
                        ),
                        value: college,
                        isDense: true,
                        onChanged: null,
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
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: intakeTextController,
                        enabled: false,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Intake Year*',
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.date_range),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Intake year is required';
                          }
                          if (!isInt(val)) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: DropdownButtonFormField(
                        hint: const Text('Profession'),
                        decoration: const InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              Icons.work,
                            ),
                          ),
                        ),
                        value: profession,
                        isDense: true,
                        onChanged: !editingEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  profession = value! as String;
                                  if (profession !=
                                      context
                                          .read<MainUser>()
                                          .user!
                                          .profession) {
                                    hasChanged = true;
                                  }
                                });
                              },
                        items: professions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        enabled: editingEnabled,
                        controller: designationTextController,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Designation at institute',
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.location_city),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (designationTextController.text !=
                                context.read<MainUser>().user!.designation) {
                              hasChanged = true;
                            }
                          });
                        },
                        style: TextStyle(
                          color: editingEnabled ? Colors.black : Colors.grey,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        enabled: editingEnabled,
                        controller: addressTextController,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Address*',
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.location_pin),
                          ),
                        ),
                        style: TextStyle(
                          color: editingEnabled ? Colors.black : Colors.grey,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (addressTextController.text !=
                                context.read<MainUser>().user!.address) {
                              hasChanged = true;
                            }
                          });
                        },
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
                    child: Text(
                      'Contact Info',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: emailTextController,
                        enabled: !useRegularEmail && editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Contact E-mail*',
                          prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                Icons.alternate_email,
                              )),
                        ),
                        style: TextStyle(
                          color: editingEnabled ? Colors.black : Colors.grey,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            if (emailTextController.text !=
                                context.read<MainUser>().user!.email) {
                              hasChanged = true;
                            }
                          });
                        },
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
                          final temp = val;
                          final List a = temp.split('@');
                          if (a.length > 2) {
                            return 'Please provide a valid E-mail';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: CheckboxListTile(
                        value: useRegularEmail,
                        title: const Text(
                          'Use login e-mail',
                          maxLines: 2,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        activeColor: Colors.black,
                        onChanged: !editingEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  if (value!) {
                                    emailTextController.text =
                                        HomeSetterPage.auth.currentUser!.email!;
                                  } else {
                                    emailTextController.text = '';
                                  }
                                  useRegularEmail = value;
                                  if (emailTextController.text !=
                                      context.read<MainUser>().user!.email) {
                                    hasChanged = true;
                                  }
                                });
                              }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: fbTextController,
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: InputDecoration(
                          hintText: 'username e.g. "rashid.hr"',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              color:
                                  !editingEnabled ? Colors.grey : Colors.blue,
                            ),
                          ),
                          prefix: Text(
                            '/',
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  !editingEnabled ? Colors.grey : Colors.blue,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (fbTextController.text !=
                                context.read<MainUser>().user!.fbUrl) {
                              hasChanged = true;
                            }
                          });
                        },
                        style: TextStyle(
                          color: editingEnabled ? Colors.black : Colors.grey,
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: instaTextController,
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: InputDecoration(
                          hintText: 'username e.g. "harun.xt"',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              color: !editingEnabled
                                  ? Colors.grey
                                  : Colors.deepOrange,
                            ),
                          ),
                          prefix: Text(
                            '/',
                            style: TextStyle(
                              fontSize: 20,
                              color: !editingEnabled
                                  ? Colors.grey
                                  : Colors.deepOrange,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (instaTextController.text !=
                                context.read<MainUser>().user!.instaUrl) {
                              hasChanged = true;
                            }
                          });
                        },
                        style: TextStyle(
                          color: editingEnabled ? Colors.black : Colors.grey,
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: phoneTextController,
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          hintText: 'Phone',
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.phone),
                          ),
                        ),
                        style: TextStyle(
                          color: editingEnabled ? Colors.black : Colors.grey,
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          if (phoneTextController.text == '') {
                            phoneAccess = false;
                          }
                          setState(() {
                            if (phoneTextController.text !=
                                context.read<MainUser>().user!.phone) {
                              hasChanged = true;
                            }
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    width: 500,
                    child: CheckboxListTile(
                        value: phoneAccess,
                        title: const Text('Make phone number public'),
                        subtitle: const Text(
                            'Anyone near you can use your phone number'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        activeColor: Colors.black,
                        onChanged: (phoneTextController.text == '' ||
                                !editingEnabled)
                            ? null
                            : (value) {
                                setState(() {
                                  phoneAccess = value!;
                                  if (phoneAccess !=
                                      context.read<MainUser>().user!.pPhone) {
                                    hasChanged = true;
                                  }
                                });
                              }),
                  ),
                  Container(
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: CheckboxListTile(
                        value: !locationAccess,
                        title: const Text(
                          'Hide my exact location',
                        ),
                        subtitle: const Text('Still show me in nearby result'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        activeColor: Colors.black,
                        onChanged: !editingEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  locationAccess = !value!;
                                  if (locationAccess !=
                                      context
                                          .read<MainUser>()
                                          .user!
                                          .pLocation) {
                                    hasChanged = true;
                                  }
                                });
                              }),
                  ),
                  Container(
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: CheckboxListTile(
                        value: enableZoneMonitor,
                        title: const Text(
                          'Enable Zone Monitor',
                          maxLines: 2,
                        ),
                        subtitle: const Text(
                            'Get notified when anyone enters your 5km zone'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        activeColor: Colors.black,
                        onChanged: !editingEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  enableZoneMonitor = value!;
                                  if (enableZoneMonitor !=
                                      context.read<Settings>().zoneDetection) {
                                    hasChanged = true;
                                  }
                                });
                              }),
                  ),
                ],
              ),
              Container(
                width: 500,
                margin: const EdgeInsets.fromLTRB(100, 20, 100, 0),
                child: ElevatedButton.icon(
                  onPressed: !(editingEnabled && hasChanged && !inProgress)
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            inProgress = true;
                          });
                          if (formKey.currentState!.validate()) {
                            String cName = cNameTextController.text;
                            String first = cName[0];
                            first = first.toUpperCase();
                            cName = first + cName.substring(1);

                            String fullName = '';
                            final parts =
                                fullNameTextController.text.split(' ');
                            final StringBuffer fname = StringBuffer();
                            for (final each in parts) {
                              first = each[0];
                              first = first.toUpperCase();
                              fname.write('$first${each.substring(1)} ');
                            }
                            fullName = fname.toString().trim();
                            try {
                              await HomeSetterPage.auth.currentUser!
                                  .updateDisplayName('Saim Ul Islam');
                              await HomeSetterPage.store
                                  .collection('users')
                                  .doc(HomeSetterPage.auth.currentUser!.uid)
                                  .update({
                                'fullname': fullName,
                                'phone': phoneTextController.text,
                                'email': emailTextController.text,
                                'pphone': phoneAccess,
                                'plocation': locationAccess,
                                'fburl': fbTextController.text,
                                'instaurl': instaTextController.text,
                                'designation': designationTextController.text,
                                'profession': profession,
                                'address': addressTextController.text,
                              });

                              context.read<MainUser>().user = AppUser(
                                id: context.read<MainUser>().user!.id,
                                cName: cName,
                                cNumber: int.parse(cNumberTextController.text),
                                fullName: fullName,
                                college: college,
                                email: emailTextController.text,
                                intake: int.parse(intakeTextController.text),
                                pAlways: context.read<MainUser>().user!.pAlways,
                                pLocation: locationAccess,
                                pMaps: context.read<MainUser>().user!.pMaps,
                                pPhone: phoneAccess,
                                photoUrl:
                                    context.read<MainUser>().user!.photoUrl,
                                phone: phoneTextController.text,
                                fbUrl: fbTextController.text,
                                instaUrl: instaTextController.text,
                                timeStamp:
                                    context.read<MainUser>().user!.timeStamp,
                                premiumTo:
                                    context.read<MainUser>().user!.premiumTo,
                                premium: context.read<MainUser>().user!.premium,
                                verified:
                                    context.read<MainUser>().user!.verified,
                                celeb: context.read<MainUser>().user!.celeb,
                                treatHead:
                                    context.read<MainUser>().user!.treatHead,
                                treatHunter:
                                    context.read<MainUser>().user!.treatHunter,
                                designation: designationTextController.text,
                                profession: profession,
                                manualDp:
                                    context.read<MainUser>().user!.manualDp,
                                treatCount:
                                    context.read<MainUser>().user!.treatCount,
                                sector: context.read<MainUser>().user!.sector,
                                address: addressTextController.text,
                                contact: context.read<MainUser>().user!.contact,
                                coupons: context.read<MainUser>().user!.coupons,
                              );

                              if (context.read<Settings>().zoneDetection !=
                                  enableZoneMonitor) {
                                if (!enableZoneMonitor) {
                                  FlutterBackgroundService()
                                      .sendData({'action': 'setAsForeground'});
                                } else {
                                  FlutterBackgroundService.initialize(onLogin);
                                }

                                context.read<Settings>().zoneDetection =
                                    enableZoneMonitor;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: const Text(
                                    'Account settings updated',
                                  ),
                                ),
                              );
                            } catch (e) {
                              log(e.toString());
                            }
                            setState(() {
                              hasChanged = false;
                              editingEnabled = false;
                              inProgress = false;
                            });
                          } else {
                            setState(() {
                              inProgress = false;
                            });
                          }
                        },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                ),
              ),
              Container(
                width: 500,
                margin: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    signOut();
                  },
                  child: const Text('Sign Out'),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isInt(String? value) {
    if (value == null) {
      return false;
    }
    final int? number = int.tryParse(value);
    return number != null;
  }

  void resetEdits() {
    locationAccess = context.read<MainUser>().user!.pLocation;
    phoneAccess = context.read<MainUser>().user!.pPhone;
    fullNameTextController.text = context.read<MainUser>().user!.fullName;
    cNameTextController.text = context.read<MainUser>().user!.cName;
    cNumberTextController.text =
        context.read<MainUser>().user!.cNumber.toString();
    intakeTextController.text =
        context.read<MainUser>().user!.intake.toString();
    phoneTextController.text = context.read<MainUser>().user!.phone;
    emailTextController.text = context.read<MainUser>().user!.email;
    fbTextController.text = context.read<MainUser>().user!.fbUrl;
    instaTextController.text = context.read<MainUser>().user!.instaUrl;
    profession = context.read<MainUser>().user!.profession;
    designationTextController.text = context.read<MainUser>().user!.designation;
    addressTextController.text = context.read<MainUser>().user!.address;
    college = context.read<MainUser>().user!.college;
    useRegularEmail = context.read<MainUser>().user!.email ==
        HomeSetterPage.auth.currentUser!.email;
    enableZoneMonitor = context.read<Settings>().zoneDetection;
    if (formKey.currentState != null) {
      formKey.currentState!.validate();
    }
  }

  @override
  bool get wantKeepAlive => true;
}