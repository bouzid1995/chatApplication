import 'package:chatapplication/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/my_button.dart';


class SignInScreen extends StatefulWidget {
  //SignInScreen({required Key key}) : super(key: key);
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


  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  Future<String> signIn(String email, String password) async {
    try{
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return user!.uid;

    }on FirebaseAuthException  catch(error){
      return Future.error(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    //controller: emailInputController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return (" Enter votre Email");
                      }
                      // reg expression for email validation
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z.-]+.[a-z]")
                          .hasMatch(value)) {
                        return (" Enterer un email Valide ");
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
                      hintText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                      SizedBox(height: 20),

                      TextFormField(
                        autofocus: false,
                        obscureText: true,
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
                        //child: Theme.of(context).primaryColor,
                        //textColor: Colors.white,
//name.test@live.com
                        onPressed: () async {
                          if (_loginFormKey.currentState!.validate()) {

                          /* FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: email,
                                password: password)
                                .then((currentUser) =>  FirebaseFirestore.instance
                                .collection("users")
                                .doc( FirebaseAuth.instance.currentUser?.uid)
                                .get()
                                .then((DocumentSnapshot result) =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen())))
                                .catchError((err){
                                 print(err);

                                        }));*/

                            await signIn(email,password).then((onSuccess){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()));
                            }).catchError((err) {
                              print(err);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
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
            ))));
  }
}