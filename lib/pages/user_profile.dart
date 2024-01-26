class UserProfile {
  final String id;
  final String name;
  final String course;
  final String email;
  final int age;
  final String bio;
  final String preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.course,
    required this.email,
    required this.age,
    required this.bio,
    required this.preferences,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
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