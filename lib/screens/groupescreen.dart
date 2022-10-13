import 'dart:html';

import 'package:chatapplication/screens/updategroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import 'chat_screen.dart';

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
  List symptoms = [];

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
        this.UserList = ListUserNom;
      });

      print('UserList Nom ');
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Liste Groupe '),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('group')
              .where("UserID", arrayContains: UserList[0]['firstName'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data?.size == '' ||
                snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            }

            {
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
                                        Description:
                                            doc.get('Description').toString(),
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
                             // print('ici Id ' + doc.id);
                              //deletGroupe(doc.id);
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) =>GroupeScreen()));
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateGroupe(Idgroupe:doc.id,Name:doc.get('Name').toString(),Description:doc.get('Description').toString(),)));
                             showDialog(
                             context: context,
                             builder: (BuildContext context) {
                                return AlertDialog(
                                title: const Text("Suppression Groupe "),
                                content: const Text("Voulez vous supprimez cette groupe ?"),
                                actions: <Widget>[
                                  TextButton(
                                    child:  const Text("Continue"),
                                    onPressed: () {
                                      deletGroupe(doc.id);
                                      if (formKey != false) {
                                        Fluttertoast.showToast(
                                            msg: 'Groupe Supprimé  avec succceé ',
                                            backgroundColor:Colors.red,
                                            timeInSecForIosWeb: 6,
                                        );


                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                   TextButton(
                                    child: const Text("Cancel"),
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
            }
          },
        ),

        // button d'ajout
        floatingActionButton: Visibility(
          visible: visibility,
          child: FloatingActionButton(
              tooltip: 'ajouter group',
              child: const Icon(Icons.group_add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: false,
                      title: Text('Nouvelle Groupe'),
                      content: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          child: SingleChildScrollView(
                              child: Column(children: <Widget>[
                            TextFormField(
                              controller: NameEditingController,
                              onSaved: (value) {
                                NameEditingController.text = value!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Nom de Groupe',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            TextFormField(
                              controller: DescriptionEditingController,
                              onSaved: (value) {
                                DescriptionEditingController.text = value!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Description ',
                                icon: Icon(Icons.description),
                              ),
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            StreamBuilder(
                                stream: symptomsStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    print('Something went wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final List usersList = [];
                                  final List listed = [];
                                  //fill up the list symptoms
                                  snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map a =
                                        document.data() as Map<String, dynamic>;
                                    usersList.add(a['firstName']);
                                    a['id'] = document.id;
                                    listed.add(a['id']);
                                  }).toList();
                                  print('id est suivant ');
                                  print(listed);

                                  return MultiSelectFormField(
                                    autovalidate: AutovalidateMode.disabled,
                                    chipBackGroundColor: Colors.blue[900],
                                    chipLabelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    dialogTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    checkBoxActiveColor: Colors.blue[900],
                                    checkBoxCheckColor: Colors.white,
                                    dialogShapeBorder:
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0))),
                                    title: const Text(
                                      "Membres ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.length == 0) {
                                        return 'Selectionner un ou plus Membre ';
                                      }
                                      return null;
                                    },
                                    dataSource: [
                                      for (String i in usersList) {'value': i},
                                    ],
                                    textField: 'value',
                                    valueField: 'value',
                                    okButtonLabel: 'Valider',
                                    cancelButtonLabel: 'Annuler',
                                    hintWidget:
                                        Text('Selectionner un ou plus Membre'),
                                    initialValue: users,
                                    onSaved: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        users = value;
                                      });
                                    },
                                  );
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue[300],
                                child: MaterialButton(
                                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  //minWidth: MediaQuery.of(context).size.width,
                                  onPressed: () {
                                    CreateGroupe();
                                    if (formKey != false) {
                                      Fluttertoast.showToast(
                                          msg: 'Groupe ajouté avec succceé ',
                                          timeInSecForIosWeb: 6
                                      );
                                      users.clear();
                                      NameEditingController.clear();
                                      DescriptionEditingController.clear();
                                      Navigator.pop(context);

                                    }  //Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Ajouter groupe",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue[300],
                              child: MaterialButton(
                                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                //minWidth: MediaQuery.of(context).size.width,
                                onPressed: () {
                                  Navigator.pop(context);
                                  users.clear();
                                  NameEditingController.clear();
                                  DescriptionEditingController.clear();
                                },
                                child: const Text(
                                  "Annuler",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ])),
                        ),
                      ),
                      /* actions: [
                        cancelButton,
                        continueButton,
                      ],*/
                    );
                  },
                );
              }),
        ));
  }
}
