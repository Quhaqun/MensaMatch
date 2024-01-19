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

  Future<DocumentList> getMessages() {
    return databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES,
      queries:
      [
        Query.equal("user_id", [auth.userid]),
      ]
    );
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
          'reciever_id': "65a15c814a8f1f1e2cbd",
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
}
