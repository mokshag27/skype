import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newapp/models/message.dart';

class LastMessageContainer extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream; // Update the type of the stream

  LastMessageContainer({
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // Update the type of StreamBuilder
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) { // Update the type of AsyncSnapshot
        if (snapshot.hasData && snapshot.data != null) {
          var docList = snapshot.data!.docs;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data() as Map<String, dynamic>);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            );
          }
          return Text(
            "No Message",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
}
