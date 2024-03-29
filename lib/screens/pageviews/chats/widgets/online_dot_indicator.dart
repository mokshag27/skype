import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newapp/enum/user_state.dart';
import 'package:newapp/models/user.dart';
import 'package:newapp/resources/local_db/auth_methods.dart';
import 'package:newapp/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int? state) {
      switch (Utils.numToState(state!)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            User user = User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
            return Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(right: 5, top: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColor(user.state),
              ),
            );
          } else {
            return Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(right: 5, top: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange, // Default color when user data is not available
              ),
            );
          }
        },
      ),
    );
  }
}
