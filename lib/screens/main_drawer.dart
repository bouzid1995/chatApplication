
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
                     image: DecorationImage(image:NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTP76yk4UPaSClbNxLRlY3i94wcuLwg5K3VNg&usqp=CAU'),
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
              leading: Icon(Icons.person),
              title: Text('Acceuil',style: TextStyle(fontSize: 18),),
              onTap:(){ Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WelcomeScreen()));
              }
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile',style: TextStyle(fontSize: 18),),
              onTap:(){ Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileEdit()));
              }
          ),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text('Ajouter Suggestion ',style: TextStyle(fontSize: 18),),
            onTap:(){ Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) =>
          AddScreen()));
            }
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Deconnexion',style: TextStyle(fontSize: 18),),
            onTap:(){
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
