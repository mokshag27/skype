import 'package:flutter/material.dart';

class FloatingColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            // Add functionality for the floating action button
          },
          child: Icon(Icons.add),
        ),
        SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            // Add functionality for another floating action button
          },
          child: Icon(Icons.delete),
        ),
      ],
    );
  }
}
