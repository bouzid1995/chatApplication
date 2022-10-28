import 'package:chatapplication/screens/add_sceen.dart';
import 'package:chatapplication/screens/chat_screen.dart';
import 'package:chatapplication/screens/get_demande.dart';
import 'package:chatapplication/screens/groupescreen.dart';
import 'package:chatapplication/screens/profiledit.dart';
import 'package:chatapplication/screens/searchuser.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'basket_page.dart';
import 'login.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'Welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final items = const [
    Icon(
      Icons.list_alt_sharp,
      size: 30,
    ),
    Icon(
      Icons.add,
      size: 30,
    ),
    Icon(
      Icons.group_add,
      size: 30,
    ),

    Icon(
      Icons.perm_contact_cal,
      size: 30,
    ),
    Icon(
      Icons.person,
      size: 30,
    ),
  ];

//final navigationkey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  final _auth = FirebaseAuth.instance.currentUser;

  void inputData() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
     // title: const Text('Curved Navigation Bar'),
      // backgroundColor: Colors.redAccent,

    ),*/





      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selctedIndex) {
          setState(() {
            index = selctedIndex;
          });
        },
        backgroundColor: Colors.white,
        height: 50,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
         color: Colors.blue,
         //color: Colors.blue,
        // backgroundColor: Colors.blue[300]
      ),
      body: Container(
          // color: Colors.redAccent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: getSelectedWidget(index: index)),
    );
  }
  //testing@test.fr

  Widget getSelectedWidget({required int index}) {
    Widget widget;

    switch (index) {
      case 0:
        widget = const GetDemande()  ;
        break;
      case 1:
        widget =  Login() ;
        break;
      case 2:
        widget =  const GroupeScreen() ;
        break;
      case 3:
        widget = const SearchUser();
        break;
      default:
        widget =  const ProfileEdit() ;
        break;
    }
    return widget;
  }
}
