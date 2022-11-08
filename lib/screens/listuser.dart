//ListUser

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'main_drawer.dart';

class ListUser extends StatefulWidget {
  const ListUser({Key? key}) : super(key: key);

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  String name = "";
  String myGroupe = "";
  String etat = "";

  fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) async {
        if (ds.exists) {
          return setState(() {
            etat =  ds.data()!['etat'];

          });
        }
      }).catchError((e) {
        print(e);
      });
  }


  void updateuser( String etat,String uiduser) async{
    //Create an instance of the current user.
    var collectionusers = FirebaseFirestore.instance.collection('users');
    collectionusers
        .doc(uiduser)
        .update(
        { 'etat':etat }) // <-- Nested value
        .then((_) => print('Success'))

        .catchError((error) => print('Failed: $error'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
  }



  deletuser(String ID) async {
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(ID).delete();
  }




  @override
  void initState() {
    super.initState();
    //fetch();
    print('test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
            backgroundColor: Colors.blue[300],
            title: Card(
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()

                          as Map<String, dynamic>;
                    // var iduser = snapshots.data!.docs[index].id;
                      if (name.isEmpty) {
                        return ListTile(
                            title: Text(
                              data['firstName'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              data['etat'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: IconButton(
                                  icon: Icon(Icons.person),
                                  onPressed: () {},
                                  color: Colors.white,
                                )),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () async {
                                        // FlutterPhoneDirectCaller.callNumber(data['NumTel']);
                                        if(data['etat']=='Actif') {

                                          updateuser('NonActif',snapshots.data!.docs[index].id);
                                          Fluttertoast.showToast(
                                            msg: 'etat mise a jour avec succceé ',
                                            backgroundColor:Colors.green,
                                            timeInSecForIosWeb: 1,
                                          );

                                        }

                                        else if(data['etat']=='NonActif'){

                                          updateuser('Actif',snapshots.data!.docs[index].id);
                                          Fluttertoast.showToast(
                                            msg: 'etat mise a jour avec succceé ',
                                            backgroundColor:Colors.green,
                                            timeInSecForIosWeb: 1,
                                          );
                                        }

                                      },
                                      icon: data['etat'] == 'Actif'
                                          ? Icon(Icons.lock_open_outlined,color: Colors.green,)
                                          : Icon(Icons.lock_outline,color: Colors.grey,)),


                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20.0,
                                      color: Colors.brown[900],
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Suppression utilisateur "),
                                            content: const Text(
                                                "Voulez vous supprimez cette utilisateur ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                child:
                                                const Text("Continuer"),
                                                onPressed: () {
                                                  deletuser(snapshots.data!
                                                      .docs[index].id);
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                              ),
                                              TextButton(
                                                child:
                                                const Text("Annuler"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),





                                ]));
                      }
                      if (data['firstName']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['firstName'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['etat'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                  data['firstName'][0] == ''
                                      ? ''
                                      : data['firstName'][0]
                                          .toString()
                                          .toLowerCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ))),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () async {
                                      if(data['etat']=='Actif') {

                                        updateuser('NonActif',snapshots.data!.docs[index].id);
                                        Fluttertoast.showToast(
                                          msg: 'etat mise a jour avec succceé ',
                                          backgroundColor:Colors.green,
                                          timeInSecForIosWeb: 1,
                                        );

                                      }

                                      else if(data['etat']=='NonActif'){

                                        updateuser('Actif',snapshots.data!.docs[index].id);
                                        Fluttertoast.showToast(
                                          msg: 'etat mise a jour avec succceé ',
                                          backgroundColor:Colors.green,
                                          timeInSecForIosWeb: 1,
                                        );
                                      }
                                    },
                                    icon: data['etat'] == 'Actif'
                                        ? Icon(Icons.lock_open_outlined,color:Colors.green ,)
                                        : Icon(Icons.lock_outline,color: Colors.grey,)),

                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20.0,
                                    color: Colors.brown[900],
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Suppression utilisateur "),
                                          content: const Text(
                                              "Voulez vous supprimez cette utilisateur ?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child:
                                              const Text("Continuer"),
                                              onPressed: () {
                                                deletuser(snapshots.data!
                                                    .docs[index].id);
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                            TextButton(
                                              child:
                                              const Text("Annuler"),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),



                              ]),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
