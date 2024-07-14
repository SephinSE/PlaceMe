import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'classes/user_profile_class.dart';
import 'functions/get_credentials.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? errorMessage = '';

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _isSigningOut = false;
  bool get isSigningOut => _isSigningOut;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void onNavBarTap(index) {
    _selectedIndex = index;
    notifyListeners();
  }

  StreamSubscription<DocumentSnapshot>? _userSubscription;
  UserProfileClass? _userProfile;
  UserProfileClass? get userProfile => _userProfile;

  void updateUserProfileClass(UserProfileClass newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }


  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _userSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          final userData = snapshot.data() as Map<String, dynamic>;
          final username = userData['username'];
          final isAdmin = userData['isAdmin'];
          final photoURL = userData['photoURL'];
          final fullName = userData['displayName'];
          final departmentID = userData['departmentID'];
          final department = getDepartment(departmentID);
          final genderID = userData['genderID'];
          final gender = getGender(genderID);
          final registerNumber = userData['registerNumber'];
          final phoneNumber = userData['phoneNumber'];
          final dob = userData['dateOfBirth'];

          if (username != null && registerNumber != null && phoneNumber != null && fullName != null && departmentID != null && genderID != null && dob != null && isAdmin != null && photoURL != null) {
            updateUserProfileClass(
              UserProfileClass(
                username: username,
                isAdmin: isAdmin,
                photoURL: photoURL,
                fullName: fullName,
                department: department,
                departmentID: departmentID,
                gender: gender,
                genderID: genderID,
                registerNumber: registerNumber,
                phoneNumber: phoneNumber,
                dob: dob,
              )
            );
            notifyListeners();
          }
        });
      } else {
        _loggedIn = false;
        _userSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required int departmentID,
    required int registerNumber,
    required int genderID,
    required int phoneNumber,
    required DateTime dob,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final userData = {
        'uid' : credential.user!.uid,
        'isAdmin' : false,
        'email' : email,
        'displayName' : fullName,
        'username' : credential.user!.email!.split('@')[0],
        'departmentID' : departmentID,
        'registerNumber' : registerNumber,
        'genderID' : genderID,
        'phoneNumber' : phoneNumber,
        'dateOfBirth' : dob,
        'photoURL' : 'https://firebasestorage.googleapis.com/v0/b/app-placeme.appspot.com/o/displayPictures%2Fdefault.png?alt=media&token=6aa3c980-4e1d-40eb-b954-ca4d356e00a8',
        'timestamp' : DateTime.now(),
        //'bio' : '',
      };
      await credential.user!.updateDisplayName(fullName);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData)
          .onError((e, _) => print("Error writing document: $e"));
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isSigningOut = true;
    _selectedIndex = 0;
    notifyListeners();
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } finally {
      _isSigningOut = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(<String, String>{
        'photoURL' : imageUrl
      }, SetOptions(merge: true));
    }
    notifyListeners(); // Now called after update is complete
  }

}