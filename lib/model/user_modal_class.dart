class User {
  String name;
  String gender;
  String phoneNumber;
  String email;
  String password;
  String id;
  String role;
  List<String> rolesList;
  String uid;
  String imageUrl;
  bool status;
  String yearsOfExperience;
  List patientsCheckedList;
  String location;
  String workLocation;
  String speciality;
  String rating;
  List schedulesList;
  List<String> availableTime;
  DateTime dateOfBirth;
  String about;
  List<double> geolocation;

  User({
    required this.name,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.id,
    required this.role,
    required this.rolesList,
    required this.uid,
    required this.imageUrl,
    required this.status,
    required this.yearsOfExperience,
    required this.patientsCheckedList,
    required this.location,
    required this.workLocation,
    required this.speciality,
    required this.rating,
    required this.schedulesList,
    required this.availableTime,
    required this.dateOfBirth,
    required this.about,
    required this.geolocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
      'id': id,
      'role': role,
      'roles_list': rolesList,
      'uid': uid,
      'image_url': imageUrl,
      'status': status,
      'years_of_experience': yearsOfExperience,
      'patients_checked_list': patientsCheckedList,
      'location': location,
      'work_location': workLocation,
      'speciality': speciality,
      'rating': rating,
      'schedules_list': schedulesList,
      'available_time': availableTime,
      'date_of_birth': dateOfBirth,
      'about': about,
      'geolocation': geolocation,
    };
  }

  static User? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return User(
      name: map['name'],
      gender: map['gender'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      password: map['password'],
      id: map['id'],
      role: map['role'],
      rolesList: List<String>.from(map['roles_list'] ?? []),
      uid: map['uid'],
      imageUrl: map['image_url'],
      status: map['status'] ?? false,
      yearsOfExperience: map['years_of_experience'],
      patientsCheckedList: map['patients_checked_list'],
      location: map['location'],
      workLocation: map['work_location'],
      speciality: map['speciality'],
      rating: map['rating'],
      schedulesList: map['schedules_list'],
      availableTime: List<String>.from(map['available_time'] ?? []),
      dateOfBirth: map['date_of_birth']?.toDate(),
      about: map['about'],
      geolocation: List<double>.from(map['geolocation'] ?? []),
    );
  }
}
