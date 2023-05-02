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
  String location;
  String workLocation;
  String speciality;
  String rating;
  List<String> availableTime;
  DateTime dateOfBirth;
  String about;

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
    required this.location,
    required this.workLocation,
    required this.speciality,
    required this.rating,
    required this.availableTime,
    required this.dateOfBirth,
    required this.about,
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
      'location': location,
      'work_location': workLocation,
      'speciality': speciality,
      'rating': rating,
      'available_time': availableTime,
      'date_of_birth': dateOfBirth,
      'about': about,
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
      location: map['location'],
      workLocation: map['work_location'],
      speciality: map['speciality'],
      rating: map['rating'],
      availableTime: List<String>.from(map['available_time'] ?? []),
      dateOfBirth: map['date_of_birth']?.toDate(),
      about: map['about'],
    );
  }
}
