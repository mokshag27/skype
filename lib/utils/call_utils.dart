import 'dart:math';
import 'package:flutter/material.dart';
import 'package:newapp/constants/strings.dart';
import 'package:newapp/models/call.dart';
import 'package:newapp/models/log.dart';
import 'package:newapp/models/user.dart';
import 'package:newapp/resources/local_db/call_methods.dart';
import 'package:newapp/resources/local_db/repository/log_repository.dart';
import 'package:newapp/screens/callscreens/pickup/call_screen.dart';
import 'package:uuid/uuid.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  final Uuid uuid = Uuid();

  static dial({required User from, required User to, required BuildContext context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
      hasDialled: true,
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
      logId: uuid.v4(), // Generate a unique ID for the log entry
    );

    bool callMade = await callMethods.makeCall(call: call);

    if (callMade) {
      // enter log
      LogRepository.addLogs(log: log);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}