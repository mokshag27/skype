// import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String senderId;
  late String receiverId;
  late String type;
  late String message;
  late DateTime timestamp; // Changed to DateTime type
  late String photoUrl;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.message,
    required this.timestamp,
  });

  // Will be only called when you wish to send an image
  // named constructor
  Message.imageMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.photoUrl,
  });

  get text => null;

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Map<String, dynamic> toImageMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'photoUrl': photoUrl,
    };
  }

  // named constructor
  Message.fromMap(Map<String, dynamic> map) {
    senderId = map['senderId'];
    receiverId = map['receiverId'];
    type = map['type'];
    message = map['message'];
    timestamp = DateTime.parse(map['timestamp']);
    photoUrl = map['photoUrl'];
  }
}
