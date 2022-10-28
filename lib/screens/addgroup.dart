
import 'package:chatapplication/screens/groupescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multiselect/multiselect.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class AddGroup extends StatefulWidget {



  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<dynamic> UserList = [
    {"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}
  ];

  final formKey = new GlobalKey<FormState>();
  List GroupList = [];
  List<dynamic> dataList1 = [
    {"uid": "", "secondName": "", "email": "", "firstName": ""}
  ];

  //List users = [];
  List<String> selected = [];
  final String value = '';
  final NameEditingController = TextEditingController(text: '');
  final Stream<QuerySnapshot> symptomsStream =
  FirebaseFirestore.instance.collection('users').snapshots();

  Future<QuerySnapshot<Map<String, dynamic>>> usersStream =
  FirebaseFirestore.instance.collection('users').get();

  final usersRef = FirebaseFirestore.instance.collection('users');

  final DescriptionEditingController = TextEditingController(text: '');
  bool visibility = false;
  List RoleList = [];
  List users = [];

  List _myActivities = [];
  var _myActivitiesResult = '';

  _saveForm() {
    var form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
      });
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

  @override
  void initState() {
    getUserNom();
    getMy(FirebaseAuth.instance.currentUser?.uid);
    super.initState();
  }



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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Groupe'),
          centerTitle: true,
        ),
        body: Form(
            key: formKey,
            child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                            TextFormField(
                              controller: NameEditingController,
                              validator: (value) {
                              if (value!.isEmpty) {
                              return (" choisir  Le nom de groupe");
                              }
                              },
                              //controller: widget.Description,
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
                              validator: (value) {

                              if (value!.isEmpty) {
                              return ("Description ne peut pas etre vide");
                              }

                              return null;
                              },
                              //controller: widget.Description,
                              onSaved: (value) {
                              DescriptionEditingController.text = value!;
                              },

                              decoration: const InputDecoration(
                                labelText: ' Description  de Groupe',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
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
                                    Map a = document.data() as Map<String, dynamic>;
                                    usersList.add(a['firstName']);
                                    a['id'] = document.id;
                                    listed.add(a['id']);
                                  }).toList();

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
                                    dialogShapeBorder: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0))),
                                    title: const Text(
                                      "Membres de groupe  ",
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

                                      value.add(UserList[0]['firstName']);

                                      users = value ;
                                    },
                                  );
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue[300],
                              child: MaterialButton(
                                padding: EdgeInsets.fromLTRB(32, 35, 32, 35),
                                //minWidth: MediaQuery.of(context).size.width,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    _saveForm;
                                    CreateGroupe();
                                    Fluttertoast.showToast(
                                      msg: 'Groupe ajouté avec succceé',
                                      backgroundColor: Colors.green,
                                      timeInSecForIosWeb: 1,
                                    );

                                    Navigator.pop(context);
                                  }
                                },

                                child: const Text(
                                  "Ajouter Groupe",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]))
    )
        ),
    );
                }
}