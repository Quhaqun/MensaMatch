import 'dart:ffi';
import 'dart:html';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/constants.dart';
import 'package:flutter/widgets.dart';


class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  AuthAPI auth = AuthAPI();

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

  Future<dynamic> updateMessage({required String id}) {
    return databases.updateDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: id);
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

  Future<Document> addMatch(
      {required String place, String major="", int semester = 0, required int starthour, required int startmin, required int endhour, required int endmin}) {
    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MATCH,
        documentId: ID.unique(),
        data: {
          'Name': auth.username,
          'Place': place,
          'Major': major,
          'Semester': semester,
          'Starthour': starthour,
          'Startmin': startmin,
          'Endhour': endhour,
          'Endmin': endmin,
          'user_id': auth.userid,
        });
  }

  Future<DocumentList> getMatches() async {
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
}
