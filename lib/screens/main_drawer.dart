
import 'package:chatapplication/screens/WelcomeScreen.dart';
import 'package:chatapplication/screens/profiledit.dart';
import 'package:chatapplication/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_sceen.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}




class _MainDrawerState extends State<MainDrawer> {

  String? firstName ='';
  String?  myfonction ='';
  String?  myGroupe ='';
  String? myNumTel ='';
  String? uiduser = '' ;
  String? email ='' ;
  String? Role ='' ;

  fetchdata() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) async {
        if (ds.exists) {
          return  setState(() {
            firstName = ds.data()!['firstName'];
            myfonction = ds.data()!['Fonction'];
            myGroupe = ds.data()!['Groupe'];
            myNumTel = ds.data()!['NumTel'];
            email = firebaseUser.email;
            Role = ds.data()!['Role'];
          });
        }
      }).catchError((e) {
        print(e);
      });
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width:double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children:<Widget> [

                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30,bottom: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                     image: DecorationImage(image:NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                         fit:BoxFit.fill ),

                    ),

                  ),

                  Text(this.email.toString(),style: TextStyle(fontSize: 22,color: Colors.white),),
                  Text(this.firstName.toString(),style: TextStyle(color: Colors.white),)

                ],
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.home_filled),
              title: Text('Acceuil',style: TextStyle(fontSize: 18),),
              onTap:(){ Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WelcomeScreen(MyIndex: 0,)));
              }
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile',style: TextStyle(fontSize: 18),),
              onTap:(){ Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WelcomeScreen(MyIndex: 4,)));
              }
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Ajouter Suggestion ',style: TextStyle(fontSize: 18),),
            onTap:(){ Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) =>
          AddScreen()));
            }
          ),

         Visibility(
           visible:false ,
           child:ListTile(
             leading: Icon(Icons.person_add),
             title: Text('Ajouter utilisateur ',style: TextStyle(fontSize: 18),),
             onTap:(){ Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) =>
                         WelcomeScreen(MyIndex: 1,)));
             }
         ), ),



          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Déconnexion',style: TextStyle(fontSize: 18),),
            onTap:() async {
              await FirebaseAuth.instance.signOut();
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SignInScreen()));
            },
          )
        ],
      ),
    );
  }
}
