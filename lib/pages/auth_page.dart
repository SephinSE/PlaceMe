import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:placeme/functions/get_credentials.dart';

import '../app_state.dart';
import '../styles.dart';

class PlaceMeAuthPage extends StatefulWidget{
  const PlaceMeAuthPage({super.key});

  @override
  State<PlaceMeAuthPage> createState() => _PlaceMeAuthPageState();
}

class _PlaceMeAuthPageState extends State<PlaceMeAuthPage> {
  String? errorMessage = ApplicationState().errorMessage;
  bool isLogin = true;
  bool registerBool = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerRegisterNumber = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerDOB = TextEditingController();
  String? selectedDepartment;
  String? selectedGender;
  bool _isRegistering = false;
  bool _isSigningIn = false;

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

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      await ApplicationState().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-credential') {
          errorMessage = 'Incorrect password!';
        } else {
          errorMessage = e.message;
        }
      });
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      _isRegistering = true;
    });
    try {
      await ApplicationState().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        fullName: _controllerFullName.text,
        departmentID: getDepartmentID(selectedDepartment!),
        registerNumber: int.parse(_controllerRegisterNumber.text),
        genderID: getGenderID(selectedGender!),
        phoneNumber: int.parse(_controllerPhone.text),
        dob: DateFormat('dd-MM-yyyy').parseStrict(_controllerDOB.text),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if  (e.code == 'email-already-in-use') {
          errorMessage = 'Email is already registered! Please login instead.';
          return;
        } else {
          errorMessage = e.message;
        }
      });
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerFullName.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    _controllerRegisterNumber.dispose();
    _controllerPhone.dispose();
    _controllerDOB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyles.textStyle.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppStyles.thistleColor2,
    );
    final formStyle = AppStyles.formStyle.copyWith(
      hintStyle: textStyle.copyWith(
        fontWeight: FontWeight.w400,
        color: AppStyles.thistleColor2,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
    );
    final buttonStyle = AppStyles.buttonStyle;

    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 450 ? 600 : 45;

    Widget progressIndicator = AppStyles().progressIndicator;

    return Scaffold(
      backgroundColor: AppStyles.onThistleColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: padding, bottom: 15),
                    child: Text(
                      isLogin ? 'sign in' : 'register',
                      style: TextStyle(
                        fontFamily: 'Roboto Flex',
                        color: AppStyles.thistleColor2,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Visibility(
                        visible: registerBool,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                registerBool = !registerBool;
                                errorMessage = '';
                              });
                            },
                            icon: const Icon(Icons.arrow_back, size: 30)
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'PlaceMe',
                      style: TextStyle(
                        fontFamily: 'Roboto Flex',
                        color: AppStyles.thistleColor2,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, 16, padding, 12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: isLogin ? const EdgeInsets.only(bottom: 20) : (registerBool ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero),
                          child: Visibility(
                            visible: isLogin || registerBool,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: TextFormField(
                                  controller: _controllerEmail,
                                  decoration: formStyle.copyWith(hintText: 'email'),
                                  style: textStyle,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),

                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? EdgeInsets.zero : (registerBool ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20)),
                          child: Visibility(
                            visible: !isLogin && !registerBool,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: TextFormField(
                                  controller: _controllerFullName,
                                  decoration: formStyle.copyWith(hintText: 'full name'),
                                  style: textStyle,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? EdgeInsets.zero : (registerBool ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20)),
                          child: Visibility(
                            visible: !isLogin && !registerBool,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: TextFormField(
                                  controller: _controllerRegisterNumber,
                                  decoration: formStyle.copyWith(hintText: 'register number'),
                                  style: textStyle,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? EdgeInsets.zero : (registerBool ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero),
                          child: Visibility(
                            visible: !isLogin && registerBool,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: TextFormField(
                                  controller: _controllerPhone,
                                  decoration: formStyle.copyWith(hintText: 'phone number'),
                                  style: textStyle,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? EdgeInsets.zero : (registerBool ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20)),
                          child: Visibility(
                            visible: !isLogin && !registerBool,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: TextFormField(
                                  controller: _controllerDOB,
                                  decoration: formStyle.copyWith(hintText: 'date of birth'),
                                  style: textStyle,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? EdgeInsets.zero : (registerBool ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20)),
                          child: Visibility(
                            visible: !isLogin && !registerBool,
                            child: DropdownMenu<String>(
                              width: 320,
                              hintText: 'Select department',
                              textStyle: textStyle,
                              inputDecorationTheme: InputDecorationTheme(
                                fillColor: const Color(0xFFFFFFFF),
                                filled: true,
                                hintStyle: textStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppStyles.thistleColor2,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(16),
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? EdgeInsets.zero : (registerBool ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20)),
                          child: Visibility(
                            visible: !isLogin && !registerBool,
                            child: DropdownMenu<String>(
                              width: 320,
                              hintText: 'Select gender',
                              textStyle: textStyle,
                              inputDecorationTheme: InputDecorationTheme(
                                fillColor: const Color(0xFFFFFFFF),
                                filled: true,
                                hintStyle: textStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppStyles.thistleColor2,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(16),
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? const EdgeInsets.only(bottom: 24) : (registerBool ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero),
                          child: Visibility(
                            visible: isLogin || registerBool,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: TextFormField(
                                  controller: _controllerPassword,
                                  decoration: formStyle.copyWith(hintText: 'password'),
                                  obscureText: true,
                                  style: textStyle,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: isLogin ? EdgeInsets.zero : (registerBool ? const EdgeInsets.only(bottom: 24) : EdgeInsets.zero),
                          child: Visibility(
                            visible: !isLogin && registerBool,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: TextFormField(
                                  controller: _controllerConfirmPassword,
                                  decoration: formStyle.copyWith(hintText: 'confirm password'),
                                  obscureText: true,
                                  style: textStyle,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!isLogin && !registerBool) {
                                setState(() {
                                  registerBool = !registerBool;
                                  errorMessage = '';
                                });
                                return;
                              }
                              if (!isLogin && _controllerFullName.text.isEmpty) {
                                setState(() {
                                  errorMessage = 'Full name field cannot be empty! Please try again.';
                                });
                                return;
                              }
                              if (!isLogin && _controllerRegisterNumber.text.isEmpty) {
                                setState(() {
                                  errorMessage = 'Register number field cannot be empty! Please try again.';
                                });
                                return;
                              }
                              if (!isLogin && _controllerDOB.text.isEmpty) {
                                setState(() {
                                  errorMessage = 'Date of birth field cannot be empty! Please try again.';
                                });
                                return;
                              }
                              if (!isLogin && selectedDepartment == null) {
                                setState(() {
                                  errorMessage = 'Please select a department and try again.';
                                });
                                return;
                              }
                              if (!isLogin && selectedGender == null) {
                                setState(() {
                                  errorMessage = 'Please select a gender try again.';
                                });
                                return;
                              }
                              if (!isLogin && _controllerEmail.text.isEmpty) {
                                setState(() {
                                  errorMessage = 'Email field cannot be empty! Please try again.';
                                });
                                return;
                              }
                              if (!isLogin && _controllerPhone.text.isEmpty) {
                                setState(() {
                                  errorMessage = 'Phone number field cannot be empty! Please try again.';
                                });
                                return;
                              }
                              if (_controllerPassword.text.isEmpty) {
                                setState(() {
                                  errorMessage = 'Please provide a password and try again.';
                                });
                                return;
                              }
                              if (!isLogin && _controllerPassword.text != _controllerConfirmPassword.text) {
                                setState(() {
                                  errorMessage = 'Passwords do not match! Please try again.';
                                });
                                return;
                              }
                              if (_formKey.currentState!.validate() && !_isRegistering) {
                                isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
                              }
                            },
                            style: buttonStyle.copyWith(padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20))),
                            child: _isRegistering || _isSigningIn ? progressIndicator : Text(isLogin ? 'sign in' : (registerBool ? 'register' : 'next')),
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                RichText(text: TextSpan(
                    style: textStyle.copyWith(fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                          text: isLogin ? 'Not an existing user? Register ' : 'Already have an account? Sign in ',
                          style: const TextStyle(fontWeight: FontWeight.w400)
                      ),
                      TextSpan(
                          text: 'here.',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            _controllerEmail.clear();
                            _controllerFullName.clear();
                            _controllerPassword.clear();
                            _controllerConfirmPassword.clear();
                            _controllerDOB.clear();
                            _controllerPhone.clear();
                            _controllerRegisterNumber.clear();
                            errorMessage = '';
                            setState(() {
                              isLogin = !isLogin;
                              if (isLogin) {
                                registerBool = false;
                              }
                            });
                          }
                      ),
                    ]
                )),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    errorMessage == '' ? '' : '$errorMessage',
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}