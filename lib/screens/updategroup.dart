
import 'package:chatapplication/screens/groupescreen.dart';
import 'package:chatapplication/widgets/my_button.dart';
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

class UpdateGroupe extends StatefulWidget {
  var Description;
  var Name;
  var selecteduser;

  UpdateGroupe(
      {super.key,
      required this.Idgroupe,
      required this.Name,
      required this.Description,
      required this.selecteduser});

  final String Idgroupe;

  @override
  State<UpdateGroupe> createState() => _UpdateGroupeState();
}

class _UpdateGroupeState extends State<UpdateGroupe> {
  List<dynamic> UserList = [
    {"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}
  ];

  final formKey = new GlobalKey<FormState>();
  List GroupList = [];
  bool testuid = false;
  List<dynamic> dataList1 = [
    {"uid": "", "secondName": "", "email": "", "firstName": ""}
  ];
  List UidList2 = [];
  List NomList2 = [];
  //List users = [];
  List<String> selected = [];
  final String value = '';
  final NameEditingController = TextEditingController(text: '');
  final Stream<QuerySnapshot> symptomsStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  Future<QuerySnapshot<Map<String, dynamic>>> usersStream =
      FirebaseFirestore.instance.collection('users').get();

  final usersRef = FirebaseFirestore.instance.collection('users');

List test = ['pWB4Gs8o0BYuLWANt9PMBtqJdhD2','rTQfV6lTGuPxvrAMoDxDuMCAsz42','rTQfV6lTGuPxvrAMoDxDuMCAsz42'];

  getUserListNom(List olduidList) async {
    List data = [];
    List NomList = [];
    List ListUserNom = [];
    final firestoreInstance = FirebaseFirestore.instance;
    final value = await firestoreInstance.collection('users').get();
    value.docs.forEach((doc) {
      ListUserNom.add(doc.data());
    });
    setState(() {
      dataList1 = ListUserNom;
    });

    for (var j = 0; j < olduidList.length; j++) {
      data = data +
          dataList1
              .where((row) => (row["uid"].contains(olduidList[j])))
              .toList();

      if (j == olduidList.length - 1) {
        for (var e = 0; e < data.length; e++) {
          NomList.add(data[e]['firstName']);
        }
      }
    }
    setState(() {
      NomList2 = NomList;
    });
    print('from function Name testing ');
    print(NomList2);
    return NomList2;
  }


  getgroupeDetail() async {
    List ListGrouoDet = [];
    List data = [];
    List NomList = [];
    List ListUserNom = [];
    await FirebaseFirestore.instance
        .collection('group')
        .where(FieldPath.documentId, isEqualTo: widget.Idgroupe)
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        ListGrouoDet.add(doc.data());
      }),
    });
    setState(() {
      this.GroupList = ListGrouoDet[0]['UserID'];
    });
    print("GroupList");
    print(GroupList);

    final firestoreInstance = FirebaseFirestore.instance;
    final value = await firestoreInstance.collection('users').get();
    value.docs.forEach((doc) {
      ListUserNom.add(doc.data());
    });
    setState(() {
      dataList1 = ListUserNom;
    });

    for (var j = 0; j < GroupList.length; j++) {
      data = data +
          dataList1
              .where((row) => (row["uid"].contains(GroupList[j])))
              .toList();

      if (j == GroupList.length - 1) {
        for (var e = 0; e < data.length; e++) {
          NomList.add(data[e]['firstName']);
        }
      }
    }
    setState(() {
      NomList2 = NomList;
    });
    print('from function Name testing ');
    print(NomList2);
    return NomList2;
  }


  UpdateGroupe(String Name, String Description, List UserID) async {
    var collection = FirebaseFirestore.instance.collection('group');
    collection
        .doc(this.widget.Idgroupe)
        .update({
          'Name': Name,
          'Description': Description,
          'UserID': UserID
        }) // <-- Nested value
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
  }





  getUserUid(List Nom) async {
    List data = [];
    List UidList = [];
    List ListUserNom = [];
    final firestoreInstance = FirebaseFirestore.instance;
    final value = await firestoreInstance.collection('users').get();
    value.docs.forEach((doc) {
      ListUserNom.add(doc.data());
    });
    setState(() {
      dataList1 = ListUserNom;
    });
    testuid = true;
    for (var j = 0; j < Nom.length; j++) {
      data = data +
          dataList1
              .where((row) => (row["firstName"].contains(Nom[j])))
              .toList();

      if (j == Nom.length - 1) {
        for (var e = 0; e < data.length; e++) {
          UidList.add(data[e]['uid']);
        }
      }
    }
    setState(() {
      UidList2 = UidList;
    });
    print('from function');
    print(UidList2);
    return UidList2;
  }

  @override
  void initState()  {
    this.getgroupeDetail();
    super.initState();
    //getUserListNom(GroupList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Modifier Groupe'),
          centerTitle: true,
        ),
        body: Form(
            key: formKey,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('group')
                    .doc(widget.Idgroupe)
                    .get(),
                builder: (_, snapshot) {
                  if (!snapshot.hasError) {
                    print('error ');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var data = snapshot.data!.data();

                  var Nom = data!['Name'];
                  var Description = data['Description'];
                  var users = data['UserID'];

                  return Container(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                           // Image.asset('images/edit.png',width: 150,height: 150,),
                            SizedBox(height: 20,),
                        TextFormField(
                          controller: TextEditingController(text: Nom),
                          //controller: widget.Description,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("Nom ne peut pas être vide ");
                            }
                            if (!regex.hasMatch(value)) {
                              return (" Nom invalide ( Minimun 3 Character)");
                            }
                            return null;
                          },
                          onChanged: (value) {
                            Nom = value;
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
                          controller: TextEditingController(text: Description),
                          //controller: widget.Description,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{10,}$');
                            if (value!.isEmpty) {
                              return ("Description ne peut pas être vide ");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Description invalide (Minimun 10 Character)");
                            }
                            return null;
                          },

                          onChanged: (value) {
                            Description = value;
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
                                chipBackGroundColor: Colors.blue,
                                chipLabelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                dialogTextStyle: const TextStyle(
                                   /* fontWeight: FontWeight.bold*/ ),
                                checkBoxActiveColor: Colors.blue,
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

                                    return 'Selectionner un ou plusieurs  Membre ';

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
                                    Text('Selectionner un ou plusieurs Membre'),
                                //GroupList

                                initialValue:  NomList2,
                                onSaved: (value) async {
                                  if (value == null) return;
                                 // value.add(UserList[0]['firstName']);
                                  NomList2 = value;
                                  print('useres est ${NomList2}');
                                  print(' length useres est ${NomList2.length}');
                                  var  myuser =  await getUserUid(NomList2);
                                  //getUserUid(users);
                                  print('from dropdown');
                                  print(myuser);
                                  print(this.UidList2);

                                },
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),

                            MyButton(color:Colors.blue[300],onPressed: () {
                              if (formKey.currentState!.validate()) {
                                //_saveForm;
                                UpdateGroupe(Nom, Description, this.UidList2);
                                Fluttertoast.showToast(
                                  msg: 'Groupe modifier avec succceé ',
                                  backgroundColor: Colors.green,
                                  timeInSecForIosWeb: 1,
                                );

                                Navigator.pop(context);
                              }}, title: 'Modifier groupe',
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                      ])));
                })));

  }
}
