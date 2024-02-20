import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';
import 'user.dart' as custom_user;
import 'call.dart';

void dial({required firebase_auth.User from, required custom_user.User to, required BuildContext context}) async {
  Call call = Call(
    callerId: from.uid,
    callerName: from.displayName!,
    callerPic: 'https://example.com/profile.jpg', // Replace this with the actual profile photo URL of the caller
    receiverId: to.user.uid,
    receiverName: to.name!,
    receiverPic: to.profilePhoto!,
    channelId: Random().nextInt(1000).toString(),
    hasDialled: true,
  );
}