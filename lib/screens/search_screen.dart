import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newapp/models/user.dart';
import 'package:newapp/resources/local_db/auth_methods.dart';
import 'package:newapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:newapp/screens/chatscreens/chat_screen.dart';
import 'package:newapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:newapp/utils/universal_variables.dart';
import 'package:newapp/widgets/custom_tile.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<User> userList = [];
  AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    User firebaseUser = await _authMethods.getCurrentUser();
    _authMethods.fetchAllUsers(firebaseUser).then((List<User> list) {
      setState(() {
        userList = list;
      });
    });
  }

  Widget buildSuggestions(String query) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        User searchedUser = userList[index];

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiver: searchedUser,
                    )));
          },
          leading: CachedImage(
            searchedUser.profilePhoto,
            radius: 25,
            isRound: true,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: UniversalVariables.greyColor),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(searchController.text),
        ),
      ),
    );
  }

  AppBar searchAppBar(BuildContext context) {
    return GradientAppBar(
      title: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }
}