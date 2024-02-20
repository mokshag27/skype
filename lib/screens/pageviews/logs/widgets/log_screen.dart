import 'package:flutter/material.dart';
import 'package:newapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:newapp/screens/pageviews/logs/widgets/floating_column.dart';
import 'package:newapp/screens/pageviews/logs/widgets/log_list_component.dart';
import 'package:newapp/utils/universal_variables.dart';
import 'package:newapp/widgets/skype_appbar.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: SkypeAppBar(
          key: Key('skype_appbar'), // Provide a key argument
          title: Text(
            "Calls",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
