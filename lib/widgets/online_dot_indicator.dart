import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newapp/enum/user_state.dart';
import 'package:newapp/models/user.dart';
import 'package:newapp/resources/local_db/auth_methods.dart';
import 'package:newapp/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  late final String uid;
  final AuthMethods _authMethods = AuthMethods();

  Color getColor(int state) {
    switch (Utils.numToState(state)) {
      case UserState.Offline:
        return Colors.red;
      case UserState.Online:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text('User not found');
          }

          User _user = User.fromMap(snapshot.data!.data()!);

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: getColor(_user.state ?? 0), // Provide a default value if _user.state is null
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}
