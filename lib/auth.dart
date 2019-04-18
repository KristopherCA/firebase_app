import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'community.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignin = GoogleSignIn();

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var imageURL;
  var _welcome = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Board'),
        centerTitle: true,
        backgroundColor: Colors.red.shade800,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageURL == null
                            ? AssetImage("images/account_box.png")
                            : NetworkImage(imageURL),
                        fit: BoxFit.fill)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: 200,
                child: FlatButton(
                  onPressed: () => _gSignin(),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.red.shade800,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),
            Container(
              width: 200,
              child: FlatButton(
                onPressed: () => _signinWithEmail(),
                child: Text(
                  'Sign in with Email',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                color: Colors.red.shade800,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            Container(
              width: 200,
              child: FlatButton(
                onPressed: () => _createUser(),
                child: Text(
                  'Create account',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                color: Colors.red.shade800,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Welcome $_welcome",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _gSignin() async {
    GoogleSignInAccount googleSignInAccount = await googleSignin.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    print('User is: ${user.photoUrl}');

    if (_auth.currentUser() != null) {
      Future.delayed(Duration(seconds: 5), () {
        navigate();
      });
      setState(() {
        imageURL = user.photoUrl;
        _welcome = user.displayName;
      });
    }

    return user;
  }

  Future _createUser() async {
    FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(
            email: "bobbob@gmail.com", password: "test12345")
        .then((newUser) {
      print("User created ${newUser.displayName}");
      print("Email:${newUser.email}");
    });

    print(user.displayName);
  }

  logout() {
    googleSignin.signOut();
    _auth.signOut();
    imageURL = null;
  }

  navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyHomePage(logoutof: logout(), image: imageURL)),
    );
  }

  _signinWithEmail() {
    _auth
        .signInWithEmailAndPassword(email: null, password: null)
        .catchError((error) {
      print("Something went wrong! ${error.toString()}");
    }).then((newUser) {
      print("User signedin: ${newUser.email}");
    });
  }
}
