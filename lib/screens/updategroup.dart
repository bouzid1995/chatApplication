import 'dart:html';

import 'package:chatapplication/screens/groupescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class UpdateGroupe extends StatefulWidget {
  var Description;
  var Name;



  UpdateGroupe({super.key,
    required this.Idgroupe,
    required this.Name,
    required this.Description

  });

  final String Idgroupe;

  @override
  State<UpdateGroupe> createState() => _UpdateGroupeState();
}

class _UpdateGroupeState extends State<UpdateGroupe> {
  final formKey = new GlobalKey<FormState>();
  List GroupList = [];
  List<dynamic> dataList1 = [
    {"uid": "", "secondName": "", "email": "", "firstName": ""}
  ];
  List users = [];
  final String value='';
  final NameEditingController = TextEditingController(text:'');
  final Stream<QuerySnapshot> symptomsStream = FirebaseFirestore.instance.collection('users').snapshots();

  UpdateGroupe(String Name,String Description ,List UserID ) async {
    var collection = FirebaseFirestore.instance.collection('group');
    collection
        .doc(this.widget.Idgroupe)
        .update(
        {'Name': Name, 'Description': Description, 'UserID':UserID}) // <-- Nested value
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
  }

  @override
  void initState() {
    this.getgroupeDetail();
    super.initState();
     //var DescriptionEditingController = TextEditingController(text: widget.Idgroupe);
     //var NameEditingController = TextEditingController(text: widget.Idgroupe);
  }

  getgroupeDetail() async {
    List ListGrouoDet = [];
    try {
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
        this.GroupList = ListGrouoDet;
      });

      print(GroupList[0]['UserID']);
      return GroupList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text('Update Groupe'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              child: SingleChildScrollView(
            child: Column(children: <Widget>[
              TextFormField(
                controller: TextEditingController(text:widget.Name),
                //controller: widget.Description,
                onChanged: (value) {

                    this.widget.Name =value;

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
                controller: TextEditingController(text:widget.Description),

//onChanged:(name)=>name=controller.text
                onChanged: (value) {

                    this.widget.Description = value;

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
                                       if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || (snapshot.hasError)) {
                                         print("probleme here");
                      return const Center(

                        child: CircularProgressIndicator(),
                      );
                    }

                    final List groupssList = [];
                    //fill up the list Group
                    snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      groupssList.add(a['firstName']);
                      a['id'] = document.id;
                    }).toList();


                    return MultiSelectFormField(
                      autovalidate: AutovalidateMode.disabled,
                      chipBackGroundColor: Colors.blue[900],
                      chipLabelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      dialogTextStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
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
                        for (dynamic i in groupssList) {'value': i},
                      ],
                      textField: 'value',
                      valueField: 'value',
                      okButtonLabel: 'Valider',
                      cancelButtonLabel: 'Annuler',
                      hintWidget:
                      Text('Selectionner un ou plus Membre'),
                      initialValue: (this.GroupList[0]['UserID']== '' ? '' : this.GroupList[0]['UserID']  ) ,


                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          users = value;
                        });
                      },
                    );
                  }),

              SizedBox(height: 30,),

              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue[300],
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  //minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                   UpdateGroupe(this.widget.Name,this.widget.Description,users);
                   if (formKey != false) {
                     Fluttertoast.showToast(
                         msg: 'Groupe mise a jour   avec succceé ',
                         backgroundColor:Colors.red,
                       timeInSecForIosWeb: 6,
                     );

                     Navigator.pop(context);
                   }
                    print(this.widget.Name);
                    print(this.widget.Description);

                   // Navigator.pop(context);
                    users.clear();
                   // NameEditingController.clear();
                    // DescriptionEditingController.clear();
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GroupeScreen()),
                    );*/


                  },
                  child: const Text(
                    "Update Groupe",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),




            ]),
          )),
       ));
  }
}


