import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newapp/models/user.dart';

import '../resources/local_db/auth_methods.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authMethods = AuthMethods();
  bool isLoginPressed = false;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              RaisedButton(
                onPressed: () {
                  performLogin();
                },
                child: Text('Login'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void performLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoginPressed = true;
      });

      // Use the correct User class
      UserCredential? userCredential = (await _authMethods.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      )) as UserCredential?;

      if (userCredential != null) {
        // Pass the correct User object
        bool isNewUser = await _authMethods.authenticateUser(userCredential.user!);

        if (isNewUser) {
          // Define this method in your AuthMethods class
          _authMethods.addDataToDb(userCredential.user!);
        }
      } else {
        setState(() {
          errorMessage = 'Failed to sign in';
        });
      }

      setState(() {
        isLoginPressed = false;
      });
    }
  }
}