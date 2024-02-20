import 'dart:math';
import 'package:sqflite/sqflite.dart';
import '../../../models/log.dart';
import '../../../models/call.dart';
import '../../../models/user.dart';
import '../../../models/dial.dart';

class LogRepository {
  final Database _database;

  LogRepository(this._database);

  Future<void> addLogs(Log log) async {
    final db = await _database;
    await db.insert(
      'logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Add other methods like fetching logs, updating logs, and deleting logs
}

class Log {
  final String callerName;
  final String callerPic;
  final String callStatus;
  final String receiverName;
  final String receiverPic;
  final String timestamp;
  final String logId;

  Log({
    required this.callerName,
    required this.callerPic,
    required this.callStatus,
    required this.receiverName,
    required this.receiverPic,
    required this.timestamp,
    required this.logId,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerName': callerName,
      'callerPic': callerPic,
      'callStatus': callStatus,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'timestamp': timestamp,
      'logId': logId,
    };
  }
}
Future<void> addLogs({required Log log}) async {
  // Other code...
}

dial({required User from, required User to, context}) async {
  Call call = Call(
    callerId: from.uid!,
    callerName: from.name!,
    callerPic: from.profilePhoto!,
    receiverId: to.uid!,
    receiverName: to.name!,
    receiverPic: to.profilePhoto!,
    channelId: Random().nextInt(1000).toString(),
    hasDialled: true,
  );
}
