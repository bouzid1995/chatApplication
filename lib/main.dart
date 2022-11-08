
import 'package:chatapplication/screens/WelcomeScreen.dart';
import 'package:chatapplication/screens/get_demande.dart';
import 'package:chatapplication/screens/groupescreen.dart';
import 'package:chatapplication/screens/login.dart';
import 'package:chatapplication/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: const FirebaseOptions(
      apiKey: "AIzaSyAjaF3adML3wxA66_SovcSh5Po709r848Q", // Your apiKey
      appId: "1:66600214455:android:7eb0da0de4599cbd829232", // Your appId
      messagingSenderId: "66600214455", // Your messagingSenderId
      projectId: "messageme-app-6bb4b",
    ),
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  final _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
         debugShowCheckedModeBanner: false,
        title: 'Pac_mspe',

       //'/': (context) => const FirstScreen(),
        initialRoute: _auth.currentUser != null ? WelcomeScreen.screenRoute :SignInScreen.screenRoute ,

        routes: {
          WelcomeScreen.screenRoute:(context)=> WelcomeScreen(MyIndex: 0,),
          SignInScreen.screenRoute:(context)=>   SignInScreen(),
          GroupeScreen.screenRoute:(context)=>const GroupeScreen(),
          Login.screenRoute:(context)=>Login(),
          GetDemande.screenRoute:(context)=>const GetDemande(),
        }
    );
  }

}















