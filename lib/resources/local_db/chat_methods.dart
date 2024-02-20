import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newapp/constants/strings.dart';
import 'package:newapp/models/contact.dart';
import 'package:newapp/models/message.dart';
import 'package:meta/meta.dart';

class ChatMethods {
  final CollectionReference _messageCollection = FirebaseFirestore.instance.collection('messages');

  Future<void> addToContacts({required String senderId, required String receiverId}) async {
    DocumentSnapshot receiverSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('contacts')
        .doc(senderId)
        .get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: Timestamp.now().toDate(), // convert Timestamp to DateTime
      );

      var senderMap = senderContact.toMap();

      await _messageCollection
          .doc(receiverId)
          .collection('contacts')
          .doc(senderId)
          .set(senderMap)
          .catchError((error) => print("Failed to add contact: $error"));
    }
  }

  Future<void> setImageMsg({
    required String url,
    required String receiverId,
    required String senderId,
    required String messageType,
  }) async {
    Message _message;

    _message = Message.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now().toDate(), // convert Timestamp to DateTime
      type: messageType,
    );

    var map = _message.toImageMap();

    await _messageCollection
        .doc(senderId)
        .collection(receiverId)
        .add(map)
        .then((value) => _messageCollection
        .doc(receiverId)
        .collection(senderId)
        .add(map))
        .catchError((error) => print("Failed to add image message: $error"));

    addToContacts(senderId: senderId, receiverId: receiverId);
  }

  Future<DocumentSnapshot> getContactsDocument({required String of, required String forContact}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(of)
        .collection('contacts')
        .doc(forContact)
        .get();
  }
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchContacts({required String userId}) {
    return _firestore.collection('contacts').doc(userId).collection('userContacts').snapshots();
  }
}