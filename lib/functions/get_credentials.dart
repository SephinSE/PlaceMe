String getDepartment(int departmentID) {
  int index = departmentID;
  Map<int, String> departmentMap = {
    0 : 'BTech Civil, School of Engineering',
    1 : 'BTech CS, School of Engineering',
    2 : 'BTech EC, School of Engineering',
    3 : 'BTech EEE, School of Engineering',
    4 : 'BTech IT, School of Engineering',
    5 : 'BTech Mech, School of Engineering',
    6 : 'BTech Safety, School of Engineering',
  };
  return departmentMap[index]!;
}

String getGender(int genderID) {
  int index = genderID;
  Map<int, String> genderMap = {
    0 : 'Male',
    1 : 'Female',
    2 : 'Other',
  };
  return genderMap[index]!;
}

int getDepartmentID(String department) {
  String dep = department;
  Map<int, String> departmentMap = {
    0 : 'BTech Civil, School of Engineering',
    1 : 'BTech CS, School of Engineering',
    2 : 'BTech EC, School of Engineering',
    3 : 'BTech EEE, School of Engineering',
    4 : 'BTech IT, School of Engineering',
    5 : 'BTech Mech, School of Engineering',
    6 : 'BTech Safety, School of Engineering',
  };
  return departmentMap.values.toList().indexOf(dep);
}

int getGenderID(String gender) {
  String gen = gender;
  Map<int, String> genderMap = {
    0 : 'Male',
    1 : 'Female',
    2 : 'Other',
  };
  return genderMap.values.toList().indexOf(gen);
}
