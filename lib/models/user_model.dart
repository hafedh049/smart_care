import 'package:smart_care/stuff/globals.dart';

class UserModel {
  String _name;
  String _id;
  String _role;
  String _uid;
  String _imageUrl;
  String _email;
  String _password;
  String _phoneNumber;
  bool _status;
  DateTime _dateOfBirth;
  String _about;
  String _grade;
  String _service;
  String _token;
  String _hospital;

  String get name => _name;
  set name(String value) => _name = value;

  String get id => _id;
  set id(String value) => _id = value;

  String get role => _role;
  set role(String value) => _role = value;

  String get uid => _uid;
  set uid(String value) => _uid = value;

  String get imageUrl => _imageUrl;
  set imageUrl(String value) => _imageUrl = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get password => _password;
  set password(String value) => _password = value;

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) => _phoneNumber = value;

  bool get status => _status;
  set status(bool value) => _status = value;

  DateTime get dateOfBirth => _dateOfBirth;
  set dateOfBirth(DateTime value) => _dateOfBirth = value;

  String get about => _about;
  set about(String value) => _about = value;

  String get grade => _grade;
  set grade(String value) => _grade = value;

  String get service => _service;
  set service(String value) => _service = value;

  String get token => _token;
  set token(String value) => _token = value;

  String get hospital => _hospital;
  set hospital(String value) => _hospital = value;
  UserModel({String? name, String? id, String? role, String? uid, String? imageUrl, String? email, String? password, String? phoneNumber, bool? status, DateTime? dateOfBirth, String? about, String? grade, String? service, String? token, String? hospital})
      : _name = name ?? "",
        _id = id ?? "",
        _role = role ?? "",
        _uid = "",
        _imageUrl = imageUrl ?? noUser,
        _email = email ?? "",
        _password = password ?? "",
        _phoneNumber = phoneNumber ?? "",
        _status = status ?? false,
        _dateOfBirth = dateOfBirth ?? DateTime(1970),
        _about = about ?? "",
        _grade = grade ?? "",
        _service = service ?? "",
        _token = token ?? "",
        _hospital = hospital ?? "";
  UserModel fromJson(Map<String, dynamic> json) => UserModel(name: json['name'] ?? "", id: json['id'] ?? "", role: json['role'] ?? "", uid: json['uid'] ?? "", imageUrl: json['image_url'] ?? "", email: json['email'] ?? "", password: json['password'] ?? "", phoneNumber: json['phone_number'] ?? "", status: json['status'] ?? "", dateOfBirth: DateTime.parse(json['date_of_birth']), about: json['about'] ?? "", grade: json['grade'] ?? "", service: json['service'] ?? "", token: json['token'] ?? "", hospital: json['hospital'] ?? "");

  Map<String, dynamic> toJson() => <String, dynamic>{'name': _name, 'id': _id, 'role': _role, 'uid': _uid, 'image_url': _imageUrl, 'email': _email, 'password': _password, 'phone_number': _phoneNumber, 'status': _status, 'date_of_birth': _dateOfBirth, 'about': _about, 'grade': _grade, 'service': _service, 'token': _token, 'hospital': _hospital};
}
