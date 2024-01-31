
import 'dart:ffi' if (dart.library.html) 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/constants.dart';
import 'package:mensa_match/pages/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';


class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;

  AuthAPI auth = AuthAPI();
  late final Storage storage;

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
    storage = new Storage(client);
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


  Future<bool> doesUserExist(String? email) async {
    try {
      final response = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        queries: [
          Query.equal('email', [email]),
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

  Future<Document> createUser(String name, String email, String course) async {
    // Check if user with the same user_id already exists
    final userExists = await doesUserExist(email);
    final documentId = await ID.unique();
    auth = AuthAPI();
    await auth.loadUser();
    if (!userExists) {
      // If the user doesn't exist, create the user in the database
      return await databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_USERS,
        documentId: documentId,
        data: {
          'name': name,
          'course': course,
          'email': email,
          'age': 0,
          'semester': 0,
          'bio': "",
          'preferences': [], // Change here
          'user_id': auth.userid,
          'profile_picture': "",
        },
      );
    } else {
      // Handle the case where the user already exists
      print('User with email already exists');
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
    int? semester,
  }) async {
    try {
      auth = AuthAPI();
      await auth.loadUser();
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

      if (existingUserProfile?.semester != semester) {
        updateData['semester'] = semester ?? existingUserProfile?.semester;
      }


      print("new Data");
      print(updateData);
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

  void _updateField(Map<String, dynamic> updateData, String fieldName, dynamic newValue, dynamic oldValue) {

    if (newValue != null) {
      if (newValue is int) {
        updateData[fieldName] = newValue.toString();
      } else if (newValue is List && newValue.isNotEmpty) {
        updateData[fieldName] = newValue;
      } else if (newValue is String && newValue.isNotEmpty) {
        updateData[fieldName] = newValue;
      }
    } else if (oldValue != null && oldValue is String && oldValue.isNotEmpty) {
      updateData[fieldName] = oldValue;
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    auth = AuthAPI();
    await auth.loadUser();

    final user = await databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_USERS,
      queries: [
        Query.equal("user_id", [auth.userid]),
      ],
    );

    if (user.documents.isNotEmpty) {
      try {
        final userDataMap = user.documents.first.data;

        final name = userDataMap['name'] as String? ?? '';
        final email = userDataMap['email'] as String? ?? '';
        final bio = userDataMap['bio'] as String? ?? '';
        final course = userDataMap['course'] as String? ?? '';
        final age = userDataMap['age'] as int? ?? 0;
        final semester = userDataMap['semester'] as int? ?? 0;
        final profile_picture = userDataMap['profile_picture'] as String? ?? '';

        print("current user preferences");
        print(userDataMap['preferences']);
        // Handle the comma-separated string for preferences
        final preferencesString = userDataMap['preferences'] as String? ?? '';
        final preferences = preferencesString.split(',').map((e) => e.trim()).toList();
        print(preferences);
        return {
          'name': name,
          'email': email,
          'bio': bio,
          'course': course,
          'age': age,
          'semester': semester,
          'preferences': preferences,
          'profile_picture': profile_picture,
        };
      } catch (e) {
        print("Error retrieving user data: $e");
        return {};
      }
    } else {
      return {}; // Return empty map if user document is not found
    }
  }



  Future<UserProfile?> getUserProfile() async {
    try {
      auth = AuthAPI();
      await auth.loadUser();
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
          print("preferences");
          print(userDataMap["preferences"]);
          final userProfile = UserProfile(
              name: userDataMap['name'],
              course: userDataMap['course'],
              email: userDataMap['email'],
              age: userDataMap['age'] as int,
              bio: userDataMap['bio'],
              preferences: userDataMap['preferences'],
              semester: userDataMap['semester'] as int,
              user_id: userDataMap['user_id']
          );
          return userProfile;
        } catch (e) {
          print("Error creating UserProfile: $e");
          return null;
        }
      } else {
        return null;
      }
    }
    catch(e){
      return null;
    }
  }

  Future<Document> addMatch({required List<String>  place, String major="", int semester = 0, required int starthour, required int startmin, required int endhour, required int endmin, required DateTime date}) {
    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MATCH,
        documentId: ID.unique(),
        data: {
          'Name': auth.username,
          'Place': jsonEncode(place),
          'Major': major,
          'Semester': semester,
          'Starthour': starthour,
          'Startmin': startmin,
          'Endhour': endhour,
          'Endmin': endmin,
          'user_id': auth.userid,
          'Date': date.toIso8601String(),
        });
  }

  Future<DocumentList> getMatches() async {
    auth = AuthAPI();
    await auth.loadUser();
    final userMatches = await databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MATCH,
      queries: [
        Query.notEqual("user_id", [auth.userid]),
        Query.equal("matcher_id", ["empty"])
      ],
    );

    return userMatches;
  }

  Future<DocumentList> getFoundMatches() async{
    auth = AuthAPI();
    await auth.loadUser();
    final userMatches = await databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MATCH,
      queries: [
        Query.equal("user_id", [auth.userid]),
        Query.notEqual("matcher_id", ["empty"])
      ],
    );

    final reciverMatches = await databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MATCH,
      queries: [
        Query.equal("matcher_id", [auth.userid])
      ],
    );

    // Combine the results of both requests
    final List<Document> combinedMatches = [
      ...userMatches.documents,
      ...reciverMatches.documents,
    ];

    // Create a DocumentList with the combined and sorted messages
    final documentList = DocumentList(
      documents: combinedMatches,
      total: combinedMatches.length,
    );

    return documentList;
  }


  Future<dynamic> updateMatch({required String id, required int starthour, required int startmin}) {
    return databases.updateDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MATCH,
        documentId: id,
        data: {
          'matcher_id': auth.userid,
          'Starthour': starthour,
          'Startmin': startmin,
        }
    );
  }


  saveimage({required XFile image}) async{
    String fileid = await auth.userid as String;
    if(kIsWeb){
      List<int> imageForWeb = await image.readAsBytes();
      if(image.path !=null && image.name!=null && fileid!=null){
        return storage.createFile(
            bucketId: COLLECTION_Images,
            fileId:  fileid,
            file: InputFile.fromBytes(bytes: imageForWeb, filename: image.name)
        );
      }else{
        print("path, imageName or userid was null");
      }
    }else{
      if(image.path !=null && image.name!=null && fileid!=null){
        return storage.createFile(
            bucketId: COLLECTION_Images,
            fileId:  fileid,
            file: InputFile.fromPath(path: image.path, filename: image.name)
        );
      }else{
        print("path, imageName or userid was null");
      }
    }
  }
}