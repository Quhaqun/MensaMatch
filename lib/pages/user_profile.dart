class UserProfile {
  final String user_id;
  final String name;
  final String course;
  final String email;
  final int age;
  final String bio;
  final String preferences;

  UserProfile({
    required this.user_id,
    this.name = '',
    this.course = '',
    this.email = '',
    this.age = 0,
    this.bio = '',
    this.preferences = '',
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      user_id: map['user_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      course: map['course'] ?? '',
      age: map['age'] as int ?? 0,
      preferences: map['preferences'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'course': course,
      'age': age,
      'preferences': preferences,
    };
  }
}