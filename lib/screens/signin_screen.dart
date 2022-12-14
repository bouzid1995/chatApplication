import 'dart:io';

import 'package:chatapplication/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/my_button.dart';


class SignInScreen extends StatefulWidget {

  static const String screenRoute = 'signin_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController emailInputController;
  late TextEditingController pwdInputController;
  late String password;
  late String email;
  bool _obscureText = true ;
   String  etat = '';
   String  myetat='';
  bool isLoggedIn = false;
  String name = '';
  late DateTime currentBackPressTime;




  fetch(dynamic user) async {

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .get()
        .then((ds) async {
      if (ds.exists) {

         // setState(() {  });

          etat = ds.data()!['etat'];
          print('etat est ${etat}');

          if(mounted){
            setState(() {
              myetat=etat;
            });
          }

      }
    }).catchError((e) {
      print(e);
    });

    if (myetat=='NonActif') {
      print('test1');
      await Fluttertoast.showToast(
          msg: "votre compte est désactivé contactez votre administration",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

    // do something else
    if (myetat=='Actif') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomeScreen(MyIndex: 0,)));
    }



  }



  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();

      }






  Future<String> signIn(String email, String password) async {


    try{

        UserCredential result = await FirebaseAuth.instance
         .signInWithEmailAndPassword(email: email+'@mspe.tn', password: password);
     User? user = result.user;
     return user!.uid;


    }on FirebaseAuthException  catch(error){
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) =>
    WillPopScope(
        onWillPop: ()async {
          final shouldPop = await onWillPop();
          return shouldPop ;

        },
        child:
        Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(
        height: 150,
      ),
    SizedBox(
    height: 150,
    child: Image.asset('images/MSPE_Logo.png'),
    ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                    TextFormField(
                    autofocus: false, keyboardType: TextInputType.emailAddress,
                    controller: emailInputController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return (" Enter votre Matricule");
                      }

                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Matricule",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                      SizedBox(height: 20),

                      TextFormField(
                        autofocus: false,
                        obscureText: _obscureText,
                        controller: pwdInputController,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Mot de passe obligatoire pour login ");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Entrer mot de passe valide (Min. 6 Character)");
                          }
                        },
                        onChanged: (value) {
                          password= value;
                        },
                       // textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.vpn_key),
                            suffixIcon : GestureDetector(
                              onTap: () {
                              setState(() {
                                _obscureText=!_obscureText;
                              });
                            },
                              child :Icon(_obscureText ? Icons.visibility :Icons.visibility_off),
                            ),
                          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Mot de passe ",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),

                      const SizedBox(
                        height:40
                      ),

                      MyButton (
                        color: Colors.blue[300]!,
                        title: 'Connexion',

                        onPressed: ()  async {
                          if (_loginFormKey.currentState!.validate()) {

                             signIn(email,password).then((onSuccess) async {

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                SharedPreferences.setMockInitialValues({});

                              if(await prefs.setString("email", email.toString()))  {

                                fetch(FirebaseAuth.instance.currentUser!.uid);
                              }
                              else{
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()));
                              }

    }).catchError((err) {
                              print(err);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Erreur"),
                                      content: Text(err.message),
                                      actions: [
                                        TextButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            });

                          }

                        },
                      ),

                    ],
                  ),
                )])
            )))));



  }

Future<bool> onWillPop() {
  DateTime now = DateTime.now();

  var currentBackPressTime;
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;

    return Future.value(true);
  }
  return Future.value(true);
}

