import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:newapp/models/user.dart';
import 'package:newapp/provider/image_upload_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp/resources/local_db/chat_methods.dart';

class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Reference? _storageReference;

  //user class
  User user = User(
    uid: '',
    name: null, // <-- set to null
    email: null, // <-- set to null
    username: '',
    profilePhoto: null, // <-- set to null
  );

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask storageUploadTask = _storageReference!.putFile(imageFile);
      var url = await (await storageUploadTask).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void uploadImage({
    required File image,
    required String receiverId,
    required String senderId,
    required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String? url = await uploadImageToStorage(image);

    if (url != null) {
      // Hide loading
      imageUploadProvider.setToIdle();

      chatMethods.setImageMsg(
        url: url,
        receiverId: receiverId,
        senderId: senderId,
        messageType: 'image', // Assuming messageType should be provided here.
      );

      // Update the user object with the new profile photo URL
      User updatedUser = User(
        uid: user.uid,
        email: user.email,
        name: user.name,
        profilePhoto: url,
        username: user.username,
      );
      user = updatedUser;
    } else {
      // Handle error
      imageUploadProvider.setToIdle();
    }
  }
}