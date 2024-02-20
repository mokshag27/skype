import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/message.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  late User _currentUser;
  late String _currentUserId;

  void pickImage({required ImageSource source}) async {
    XFile? selectedImage = await _imagePicker.pickImage(source: source);
    if (selectedImage != null) {
      // Handle the image upload
    }
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    if (snapshot == null) {
      return Container();
    }
    Message _message = Message.fromMap(snapshot.data() as Map<String, dynamic>);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Align(
        alignment: _message.senderId == _currentUserId ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: _message.senderId == _currentUserId ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(10),
          child: Text(
            _message.text!,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          _currentUser = user;
          _currentUserId = user.uid;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.displayName ?? ''),
      ),
      body: Container(
        child: Column(
          children: [
            // Your chat messages widget here
          ],
        ),
      ),
    );
  }
}
