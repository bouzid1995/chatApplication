import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../model/basket.dart';
import '../model/group.dart';

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
  List _symptoms = [];

  List symptoms = [];
  List? _myActivities;
  late String _myActivitiesResult = '';
  final formKey = new GlobalKey<FormState>();
  final Stream<QuerySnapshot> symptomsStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void initState() {
    //fechRecrcords();
    //fechUsers();
    getListUser();
    super.initState();
    //print(symptomsStream);
    // asyncTasks();
  }

  /*getDataFromFirestore(var collection, var data) async {

    await FirebaseFirestore.instance
        .collection(collection)
        .get()
        .then((value) {
      // here we set the data to the data
      data = value.docs;
    });


  }

  asyncTasks() async {

    await getDataFromFirestore("users", data);

    // here we fill up the list symptoms
    for(var item in data) {
      symptoms.add(item["firstName"]);
    }

    setState(() {});
  }*/

  Future getListUser() async {
    List dataList = [];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  dataList.add(doc.data());
                }),
              });

      setState(() {
        this.UserList = dataList;
      });
      // print('user is here');
      // print(UserList);
      return UserList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  _saveForm() {
    var form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
      });
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

//https://bugsfixing.com/solved-how-to-retrieve-data-from-firestore-to-display-in-multi-select-form-field/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Liste Groupe '),
          centerTitle: true,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'List of Group soon :) ',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: 'ajouter group',
            child: new Icon(Icons.group_add),
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
                          const SizedBox(height: 50.0,),

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

                          const SizedBox(height: 50.0,),
                          StreamBuilder(
                              stream: symptomsStream,
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                if(snapshot.hasError){
                                  print('Something went wrong');
                                }
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final List symptomsList = [];
                                //fill up the list symptoms
                                snapshot.data!.docs.map((DocumentSnapshot document){
                                  Map a = document.data() as Map<String, dynamic>;
                                  symptomsList.add(a['firstName']);
                                  a['id'] = document.id;
                                }).toList();

                                return MultiSelectFormField(
                                  autovalidate: AutovalidateMode.disabled,
                                  chipBackGroundColor: Colors.blue[900],
                                  chipLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                                  checkBoxActiveColor: Colors.blue[900],
                                  checkBoxCheckColor: Colors.white,
                                  dialogShapeBorder: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                  title: const Text(
                                    "Symptoms",
                                    style: TextStyle(fontSize:20),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return 'Please select one or more symptoms';
                                    }
                                    return null;
                                  },
                                  dataSource: [
                                    for (String i in symptomsList) {'value' : i}
                                  ],
                                  textField: 'value',
                                  valueField: 'value',
                                  okButtonLabel: 'OK',
                                  cancelButtonLabel: 'CANCEL',
                                  hintWidget: Text('Please choose one or more symptoms'),
                                  initialValue: _symptoms,
                                  onSaved: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _symptoms = value;
                                    }
                                    );
                                  },
                                );
                              }
                          ),
                        ]),
                      ),
                    ),
                   /* actions: [
                      cancelButton,
                      continueButton,
                    ],*/
                  );
                },
              );
            }));
  }
}
