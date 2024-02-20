import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newapp/models/contact.dart';
import 'package:newapp/provider/user_provider.dart';
import 'package:newapp/resources/local_db/chat_methods.dart';
import 'package:newapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:newapp/screens/pageviews/chats/widgets/contact_view.dart';
import 'package:newapp/screens/pageviews/chats/widgets/quiet_box.dart';
import 'package:newapp/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:newapp/utils/universal_variables.dart';
import 'package:newapp/widgets/skype_appbar.dart';

import 'widgets/new_chat_button.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: SkypeAppBar(
          key: Key('skypeAppBar'), // Add a key parameter here
          title: UserCircle(),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/search_screen");
              },
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _chatMethods.fetchContacts(
          userId: userProvider.getUser!.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var docList = snapshot.data!.docs;

            if (docList.isEmpty) {
              return QuietBox(
                heading: "This is where all the contacts are listed",
                subtitle:
                "Search for your friends and family to start calling or chatting with them",
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: docList.length,
              itemBuilder: (context, index) {
                Contact contact = Contact.fromMap(docList[index].data());

                return ContactView(contact);
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
