class UserProfile {
  final String user_id;
  final String name;
  final String course;
  final String email;
  final int age;
  final String bio;
  final String preferences;

  UserProfile({
    this.name,
    this.course,
    this.email,
    this.age,
    this.bio,
    this.preferences,
    required this.user_id,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      user_id: map['user_id'],
      name: map['name'],
      email: map['email'],
      bio: map['bio'],
      course: map['course'] ?? '', // Add this line to handle null values
      age: map['age'] ?? 0, // Add this line to handle null values
      preferences: map['preferences'] ?? '', // Add this line to handle null values
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'course': course, // Add this line to include course in the map
      'age': age, // Add this line to include age in the map
      'preferences': preferences,
    };
  }
}