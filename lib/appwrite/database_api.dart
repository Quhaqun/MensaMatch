import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/constants.dart';
import 'package:mensa_match/pages/user_profile.dart';

class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> getMessages() async {
    final userMessages = await databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES,
      queries: [
        Query.equal("user_id", [auth.userid]),
      ],
    );

    final recieverMessages = await databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES,
      queries: [
        Query.equal("reciever_id", [auth.userid]),
      ],
    );

    // Combine the results of both requests
    final List<Document> combinedMessages = [
      ...userMessages.documents,
      ...recieverMessages.documents,
    ];

    // Sort the combined messages by timestamp
    combinedMessages.sort((a, b) {
      final timestampA = DateTime.parse(a.data['timestamp']);
      final timestampB = DateTime.parse(b.data['timestamp']);
      return timestampA.compareTo(timestampB); // Sort in ascending order
    });

    // Create a DocumentList with the combined and sorted messages
    final documentList = DocumentList(
      documents: combinedMessages,
      total: combinedMessages.length,
    );

    return documentList;
  }


  Future<Document> addMessage({required String message}) {
    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: ID.unique(),
        data: {
          'text': message,
          'timestamp': DateTime.now().toString(),
          'user_id': auth.userid,
          'reciever_id': "65a0cc62e7b9d856bbef",
        });
  }

  Future<dynamic> deleteMessage({required String id}) {
    return databases.deleteDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: id);
  }

  Future<dynamic> updateMessage(
      {required String id, Map<String, dynamic>? updatedFields}) {
    if (updatedFields == null || updatedFields.isEmpty) {
      // If no fields are provided, return a Future.error
      return Future.error('No fields provided for update');
    }

    return databases.updateDocument(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES,
      documentId: id,
      data: updatedFields,
    );
  }

  Future<bool> isSender(String id) async {
    try {
      final document = await databases.getDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: id,
      );

      final userId = document.data['user_id'];
      return userId == auth.userid;
    } catch (e) {
      print("Error in isSender(): $e");
      return false;
    }
  }

  Future<bool> doesUserExist(String? userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        queries: [
          Query.equal('user_id', [userId]),
        ],
      );

      // If the response contains any documents, the user already exists
      return response.documents.isNotEmpty;
    } catch (e) {
      // Handle errors as needed
      print('Error checking user existence: $e');
      return false;
    }
  }

  Future<Document> createUser() async {
    // Check if user with the same user_id already exists
    final userExists = await doesUserExist(auth.userid);
    final documentId = await ID.unique();
    if (!userExists) {
      // If the user doesn't exist, create the user in the database
      return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        documentId: documentId,
        data: {
          'name': auth.username,
          'course': "",
          'email': auth.email,
          'age': 0,
          'semester': 0,
          'bio': "",
          'preferences': "",
          'user_id': auth.userid
        },
      );
    } else {
      // Handle the case where the user already exists
      print('User with user_id already exists');
      // You might want to return an error or handle it differently based on your requirements
      throw Exception('User with user_id already exists');
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? bio,
    String? course,
    int? age,
    String? preferences,
  }) async {
    try {
      final existingUserProfile = await getUserProfile();
      final filteredUser = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        queries: [
          Query.equal("user_id", [auth.userid]),
        ],
      );

      var docId = filteredUser.documents.first.$id;

      final Map<String, dynamic> updateData = {};

      _updateField(updateData, 'name', name, existingUserProfile?.name);
      _updateField(updateData, 'email', email, existingUserProfile?.email);
      _updateField(updateData, 'bio', bio, existingUserProfile?.bio);
      _updateField(updateData, 'course', course, existingUserProfile?.course);
      _updateField(updateData, 'preferences', preferences, existingUserProfile?.preferences);

      if (existingUserProfile?.age != age) {
        updateData['age'] = age ?? existingUserProfile?.age;
      }

      await databases.updateDocument(
        collectionId: COLLECTION_USERS,
        documentId: docId,
        data: updateData,
        databaseId: APPWRITE_DATABASE_ID,
      );
    } catch (e) {
      // Handle update error
      print('Error updating user profile: $e');
      throw AppwriteException('document_not_found');
    }
  }

  void _updateField(Map<String, dynamic> updateData, String fieldName, String? newValue, String? oldValue) {
    if (newValue != null && newValue.isNotEmpty) {
      updateData[fieldName] = newValue;
    } else if (oldValue != null && oldValue.isNotEmpty) {
      updateData[fieldName] = oldValue;
    }
  }


  Future<UserProfile?> getUserProfile() async {
    try {
      if (auth.userid == null) {
        print('User ID is null');
        return null;
      }
      final response = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        queries: [
          Query.equal('user_id', [auth.userid!]),
        ],
      );
      if (response.documents.isNotEmpty) {
        try {
          final userDataMap = response.documents.first.data;
          final userProfile = UserProfile(
              name: userDataMap['name'],
              course: userDataMap['course'],
              email: userDataMap['email'],
              age: userDataMap['age'] as int,
              bio: userDataMap['bio'],
              preferences: userDataMap['preferences'],
              user_id: userDataMap['user_id']
          );
          return userProfile;
        } catch (e) {
          print("Error creating UserProfile: $e");
          return null;
        }
      } else {
        // Handle the case when the document is not found
        // For example, return an empty UserProfile or throw an exception
        return null; // Replace this with your desired behavior
      }
    }
    catch(e){
      return null;
    }
  }
}