import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  static const route = "/signupScreen";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final Firestore _firestore = Firestore.instance;
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  String _email;
  String _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> registerUser() async{
    _password = _passwordController.text;
    _email = _emailController.text;
     await _auth.createUserWithEmailAndPassword(
      email: _email,
      password: _password
    );
    await _firestore.collection('users').add({
      'user': _email,
    });
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 300,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.email),
                  hintText: "Enter your email",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 300,
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Enter your password",
                ),
              ),
            ),
            RaisedButton(
              onPressed: registerUser,
              child:Text("Sign Up") ,
            )
          ],
        ),
      ),
    );
  }
}
