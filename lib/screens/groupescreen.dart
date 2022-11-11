

import 'package:chatapplication/screens/addgroup.dart';
import 'package:chatapplication/screens/updategroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import 'chat_screen.dart';
import 'main_drawer.dart';

class GroupeScreen extends StatefulWidget {
  static const String screenRoute = 'groupe_screen';

  const GroupeScreen({Key? key}) : super(key: key);

  @override
  State<GroupeScreen> createState() => _GroupeScreenState();
}

class _GroupeScreenState extends State<GroupeScreen> {
  List<dynamic> UserList = [
    {"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}
  ];
  var data;
  List users = [];


  late String _myActivitiesResult = '';
  final formKey = new GlobalKey<FormState>();
  final Stream<QuerySnapshot> symptomsStream =
  FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void initState() {
    super.initState();
    getUserNom();
    getMy(FirebaseAuth.instance.currentUser?.uid);
  }

  getUserNom() async {
    List ListUserNom = [];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          ListUserNom.add(doc.data());
        }),
      });
      setState(() {
        UserList = ListUserNom;
      });

      print('Nom user connected  ');
      print(UserList[0]['firstName']);
      return UserList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {},
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed: () {},
  );

  final DescriptionEditingController = TextEditingController(text: '');
  final NameEditingController = TextEditingController(text: '');
  bool visibility = false;
  List RoleList = [];
//https://bugsfixing.com/solved-how-to-retrieve-data-from-firestore-to-display-in-multi-select-form-field/

  Future getMy(dynamic username) async {
    List dataList = [];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: username)
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          dataList.add(doc.data());
        }),
      });

      setState(() {
        this.RoleList = dataList;
      });

      (RoleList[0]['Role'] == 'Admin')
          ? visibility = true
          : visibility = false;

      if (RoleList[0]['Role'] == 'user') {
        visibility = false;
      }

      return RoleList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  CreateGroupe() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;


    Map<String, dynamic> data = {
      "Description": DescriptionEditingController.text,
      "Name": NameEditingController.text,
      "UserID": users,
      "AdminUid": FirebaseAuth.instance.currentUser?.uid
    };

    await firebaseFirestore.collection("group").add(data);
  }


  deletGroupe(String ID) async {
    var collection = FirebaseFirestore.instance.collection('group');
    await collection.doc(ID).delete();
  }

  //group
  @override
  Widget build(BuildContext context){

     return
     Scaffold(
        drawer:MainDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
        children:  const [ SizedBox(width: 20),
      Text('Liste des Groupes   ')
      ],
    ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('group')
              .where("UserID", arrayContains: UserList[0]['firstName'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ) {
              return Center(child: CircularProgressIndicator(),
              );
            }
            else if( snapshot.data?.size == null ){

              return Center(child: CircularProgressIndicator(),
              );
            }
            else
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  // const Icon(Icons.group) Text(doc.id)
                  return Card(
                      child: ListTile(
                        leading: const Icon(Icons.group),
                        title: Text(doc.get('Name').toString()),
                        subtitle: Text(doc.get('Description').toString()),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                Idgroupe: doc.id,
                                Name:doc.get('Name').toString(),
                              )));
                          print('ici Id ' + doc.id);

                        },
                        trailing: Visibility(
                          visible: visibility,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: 20.0,
                                  color: Colors.brown[900],
                                ),
                                onPressed: () {

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UpdateGroupe(
                                        Idgroupe: doc.id,
                                        Name: doc.get('Name').toString(),
                                        Description:doc.get('Description').toString(),
                                        selecteduser:doc.get('UserID'),
                                      )));
                                },
                              ),
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
                                        title: const Text("Suppression Groupe "),
                                        content: const Text("Voulez vous vraiment supprimez cette groupe ?"),
                                        actions: <Widget>[

                                          TextButton(
                                            child:  const Text("Continuer"),
                                            onPressed: () {
                                              deletGroupe(doc.id);
                                              if (formKey != false) {
                                                Fluttertoast.showToast(
                                                  msg: 'Groupe Supprimé  avec succceé ',
                                                  backgroundColor:Colors.red,
                                                  timeInSecForIosWeb: 2,
                                                );

                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Annuler"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );


                                },
                              ),
                            ],
                          ),
                        ),
                      ));
                }).toList(),
              );

          },
        ),

        // button d'ajout
        floatingActionButton: Visibility(
          visible: visibility,
          child: FloatingActionButton(
              tooltip: 'ajouter groupe',
              child: const Icon(Icons.group_add),
              onPressed: () async {
                await  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddGroup()));
              }),
        ));

  }

  }




