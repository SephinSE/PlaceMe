import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/functions/get_credentials.dart';
import '/styles.dart';
import '../app_state.dart';
import '../appbar/appbar.dart';

class PlaceMeEditProfilePage extends StatefulWidget {
  const PlaceMeEditProfilePage({super.key});

  @override
  State<PlaceMeEditProfilePage> createState() => _PlaceMeEditProfilePageState();
}

class _PlaceMeEditProfilePageState extends State<PlaceMeEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDepartment;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = Provider.of<ApplicationState>(context, listen: false).userProfile;
      if (userProfile != null) {
        setState(() {
          selectedDepartment = userProfile.department; // Update controller as well
          selectedGender = userProfile.gender; // Update controller as well
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ApplicationState>(context).currentUser;
    final textStyle = AppStyles.textStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400);

    return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        final userProfile = appState.userProfile;
        if (user != null && userProfile != null) {
          String username = userProfile.username;
          String fullName = userProfile.fullName;
          DateTime dob = userProfile.dob;
          int registerNumber = userProfile.registerNumber;
          int phoneNumber = userProfile.phoneNumber;
          int departmentID = userProfile.departmentID;
          String department = userProfile.department;
          int genderID = userProfile.genderID;
          String gender = userProfile.gender;
          final TextEditingController controllerFullName = TextEditingController(text: fullName);
          final TextEditingController controllerUsername = TextEditingController(text: username);
          final TextEditingController controllerRegisterNumber = TextEditingController(text: registerNumber.toString());
          final TextEditingController controllerPhone = TextEditingController(text: phoneNumber.toString());
          final TextEditingController controllerDOB = TextEditingController(text: dob.toString());
          final List<String> departmentOptions = [
            'BTech Civil, School of Engineering',
            'BTech CS, School of Engineering',
            'BTech EC, School of Engineering',
            'BTech EEE, School of Engineering',
            'BTech IT, School of Engineering',
            'BTech Mech, School of Engineering',
            'BTech Safety, School of Engineering',
          ];
          final List<String> genderOptions = [
            'Male',
            'Female',
            'Other',
          ];

          return Scaffold(
              appBar: const PlaceMeAppbar(title: 'Edit Profile'),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Full name: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: controllerFullName,
                                style: textStyle,
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).colorScheme.surfaceBright,
                                  filled: true,
                                  labelStyle: textStyle,
                                  hintStyle: textStyle.copyWith(
                                    fontSize: 18,
                                    color: AppStyles.thistleColor2,
                                  ),
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: AppStyles.thistleColor2,
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Username: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: controllerUsername,
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: '',
                                  hintStyle: textStyle,
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: AppStyles.thistleColor2,
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                style: textStyle,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Department: ', style: textStyle),
                            DropdownMenu<String>(
                              width: 260,
                              initialSelection: selectedDepartment,
                              textStyle: textStyle,
                              inputDecorationTheme: InputDecorationTheme(
                                fillColor: AppStyles.onThistleColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppStyles.thistleColor, width: 2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onSelected: (String? newValue) {
                                setState(() {
                                  selectedDepartment = newValue;
                                });
                              },
                              dropdownMenuEntries: departmentOptions.map((String option) {
                                return DropdownMenuEntry(value: option, label: option);
                              }).toList(),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Gender: ', style: textStyle),
                            DropdownMenu<String>(
                              width: 260,
                              initialSelection: selectedGender,
                              textStyle: textStyle,
                              inputDecorationTheme: InputDecorationTheme(
                                fillColor: AppStyles.onThistleColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppStyles.thistleColor, width: 2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onSelected: (String? newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                              dropdownMenuEntries: genderOptions.map((String option) {
                                return DropdownMenuEntry(value: option, label: option);
                              }).toList(),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Register Number: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: controllerRegisterNumber,
                                maxLines: null,
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).colorScheme.surfaceBright,
                                  filled: true,
                                  hintText: '',
                                  hintStyle: textStyle,
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: AppStyles.thistleColor2,
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                style: textStyle,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: controllerPhone,
                                maxLines: null,
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).colorScheme.surfaceBright,
                                  filled: true,
                                  hintText: '',
                                  hintStyle: textStyle,
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: AppStyles.thistleColor2,
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                style: textStyle,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date of birth: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: controllerDOB,
                                maxLines: null,
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).colorScheme.surfaceBright,
                                  filled: true,
                                  hintText: '',
                                  hintStyle: textStyle,
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: AppStyles.thistleColor2,
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                style: textStyle,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(AppStyles.thistleColor),
                                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                textStyle: WidgetStateProperty.all<TextStyle>(textStyle.copyWith(
                                  fontSize: 18,
                                )),
                                padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
                                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .set(<String, dynamic>{
                                'displayName' : controllerFullName.text,
                                'username' : controllerUsername.text,
                                'departmentID' : getDepartmentID(selectedDepartment!),
                                'genderID' : getGenderID(selectedGender!),
                                'registerNumber': int.parse(controllerRegisterNumber.text),
                                'phoneNumber': int.parse(controllerPhone.text),
                                'dob': DateFormat('dd-MM-yyyy').parseStrict(controllerDOB.text),
                              }, SetOptions(merge: true));
                            },
                            child: const Text('Update Profile'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        }
        if (userProfile == null) {
          return const CircularProgressIndicator(color: Colors.black); // or some loading widget
        }
        if (user == null) {
          return const Scaffold(
            appBar: PlaceMeAppbar(title: 'user'),
            body: SizedBox(height: double.infinity, width: double.infinity),
          );
        }
        return const CircularProgressIndicator(color: Colors.black);
      },
    );
  }
}