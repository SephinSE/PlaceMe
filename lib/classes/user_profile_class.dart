class UserProfileClass {
  UserProfileClass({
    required this.username,
    required this.isAdmin,
    required this.photoURL,
    required this.registerNumber,
    required this.phoneNumber,
    required this.fullName,
    required this.departmentID,
    required this.department,
    required this.genderID,
    required this.gender,
    required this.dob,
  });

  final String username;
  final bool isAdmin;
  final String photoURL;
  final int registerNumber;
  final int phoneNumber;
  final String fullName;
  final int departmentID;
  final String department;
  final int genderID;
  final String gender;
  final DateTime dob;

}