import 'dart:html';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/constants.dart';
import 'package:flutter/widgets.dart';
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

    if (!userExists) {
      // If the user doesn't exist, create the user in the database
      return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        documentId: ID.unique(),
        data: {
          'name': auth.username,
          'course': "",
          'email': auth.email,
          'age': 0,
          // Assuming Age is an integer, you can change it accordingly
          'semester': 0,
          // Assuming Semester is an integer, you can change it accordingly
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
    required String name,
    required String email,
    required String bio,
    required String course,
    required int age,
    required String preferences,
  }) async {
    try {
      // Ensure auth.userid is not null before proceeding
      if (auth.userid == null) {
        return; // Handle the case when userid is null
      }

      await databases.updateDocument(
        collectionId: COLLECTION_USERS,
        documentId: auth.userid!,
        data: {
          'name': name,
          'email': email,
          'bio': bio,
          'course': course,
          'age': age,
          'preferences': preferences,
          // Add other fields as needed
        },
        databaseId: APPWRITE_DATABASE_ID,
      );
    } catch (e) {
      // Handle update error
      print('Error updating user profile: $e');
      throw AppwriteException('document_not_found');
    }
  }


  Future<UserProfile?> getUserProfile() async {
    try {
      print("1.1");
      print(auth.userid);

      if (auth.userid == null) {
        print('User ID is null');
        return null;
      }

      print("1.2");

      final response = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        queries: [
          Query.equal('user_id', [auth.userid!]),
        ],
      );

      print("1.3");

      if (response.documents.isNotEmpty) {
        final userData = response.documents.first.data;
        print("User data: $userData");
        return UserProfile.fromMap(userData);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print(auth.userid);
      print(auth.status);
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
