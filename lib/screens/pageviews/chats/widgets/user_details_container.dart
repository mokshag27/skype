import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newapp/enum/user_state.dart';
import 'package:newapp/models/user.dart';
import 'package:newapp/provider/user_provider.dart';
import 'package:newapp/resources/local_db/auth_methods.dart';
import 'package:newapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:newapp/screens/login_screen.dart';
import 'package:newapp/screens/pageviews/chats/widgets/shimmering_logo.dart';
import 'package:newapp/widgets/appbar.dart';

// UserDetailsContainer class
class UserDetailsContainer extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    void signOut() async {
      final bool isLoggedOut = await authMethods.signOut();
      if (isLoggedOut) {
        authMethods.setUserState(
          userId: userProvider.getUser?.uid ?? '',
          userState: UserState.Offline,
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            // Provide required parameters
            key: GlobalKey(), // Example of providing a key
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: ShimmeringLogo(),
            actions: <Widget>[
              TextButton(
                onPressed: () => signOut(),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

// UserDetailsBody class
class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User? user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user?.profilePhoto ?? '',
            isRound: true,
            radius: 50,
            height: 100,
            width: 100, // Provide required width parameter
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user?.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
