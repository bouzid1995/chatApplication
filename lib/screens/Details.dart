import 'package:chatapplication/widgets/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/UsersModels.dart';
import 'get_demande.dart';

class DetailDemande extends StatefulWidget {
  DetailDemande(
      {super.key,
        required this.IdDoc,
        required this.Iduser,
        required this.Description,
        required this.Date,
        required this.SituationAvant,
        required this.SituationApres,
        required this.Remarque,
        required this.Etat});

  final String Iduser;
  final String Description;
  final String Date;
  final String SituationAvant;
  final String SituationApres;
  final String Remarque;
  final String Etat;
  final String IdDoc;

  @override
  State<DetailDemande> createState() => _DetailDemandeState();
}

class _DetailDemandeState extends State<DetailDemande> {
  List<UsersModels> UserItem = [];

  // List<dynamic> dataList1 = [];

  List<dynamic> dataList1 = [
    {"uid": "", "secondName": "", "email": "", "firstName": ""}
  ];
  List<dynamic> RoleList = [
    {"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}
  ];
  final RemarqueEditingController = new TextEditingController();
  bool myvisibility = false;
  final idConnected = FirebaseAuth.instance.currentUser?.uid.toString();
  bool value = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //List<Object> _historyList = [];
  String? firstName = '';
  String? myfonction = '';
  String? myGroupe = '';

  @override
  void initState() {
    fetch(this.widget.Iduser);
    super.initState();
    getMy(idConnected, widget.Etat.toString());
    // Role(FirebaseAuth.instance.currentUser?.uid,this.widget.Approuved,RoleList);
  }

  List<String> EtatList = ['Approuver', 'Rejeté', 'Réfusé'];
  String? SEtat = 'Approuver';


  fetch(String Iduser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Iduser)
        .get()
        .then((ds) async {
      if (ds.exists) {
        return setState(() {
          firstName = ds.data()!['firstName'];
          myfonction = ds.data()!['Fonction'];
          myGroupe = ds.data()!['Groupe'];
          print(firstName);
          print(myfonction);
          print(myfonction);
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  changedata() {
    setState(() {
      value = true;
    });
  }

  Future getMy(dynamic username, dynamic Etat) async {
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

      (RoleList[0]['Role'] == 'Admin' && Etat == 'En attente')
          ? myvisibility = true
          : myvisibility = false;

      if (RoleList[0]['Role'] == 'user') {
        myvisibility = false;
      }

      return RoleList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  UpdateDemande(String Doc, String MyRemarque,String Etat) async {
    var collection = FirebaseFirestore.instance.collection('basket_items');
    collection
        .doc(Doc)
        .update(
        {'Etat': Etat, 'Remarque': MyRemarque}) // <-- Nested value
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
  }

  @override
  Widget build(BuildContext context) {
    final RemarqueField = TextFormField(
      autofocus: false,
      controller: RemarqueEditingController,
      minLines: 2,
      maxLines: 4,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Remarque ne peut pas etre vide  ");
        }
        return null;
      },
      onSaved: (value) {
        RemarqueEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        //prefixIcon: const Icon(Icons.safety_check_rounded),
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            RemarqueEditingController.clear();
          },
        ),
        contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        hintText: "Remarque Suggestion ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        labelText: 'Remarque  ',
      ),
    );

    GlobalKey<FormState> _key = GlobalKey();
    final addButton = Material(
      //elevation: 3,
      borderRadius: BorderRadius.circular(20),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
        // minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetDemande()))
        },
        child: const Text(
          "Approuver Suggestion",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails Suggestion '),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.white])),
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 220.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          this.widget.Date,
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 15.0),
                          //clipBehavior: Clip.hardEdge,
                          color: Colors.white,
                         // elevation: 35.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Nom',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        ' ${firstName}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  //
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Groupe",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '${myGroupe}',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Fonction ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '${myfonction}',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            SingleChildScrollView(
              // Padding( padding: const EdgeInsets.only(left: 20,bottom: 50)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Description:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                    ),
                    SizedBox(height: 15),
                    Text(
                      this.widget.Description.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Situation Avant:",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      this.widget.SituationAvant.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const Text(
                      "Situation Après:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      this.widget.SituationApres.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Visibility(
                      visible: !myvisibility,
                      child: Text(
                        "Remarque:",
                        style: TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Visibility(
                      visible: !myvisibility,
                      child: Text(
                        this.widget.Remarque.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: double.minPositive, vertical: 5),
                              child: Visibility(
                                visible: myvisibility,
                                child: Padding(
                                    padding: EdgeInsets.only(left:10,right: 10,bottom: 5),
                                    child: DropdownButtonFormField(
                                      value: SEtat,
                                      hint: const Text('selectionner Une Etat'),
                                      items: EtatList.map((e) {
                                        return DropdownMenuItem(child: Text(e),value:e,);
                                      }
                                      ).toList(),
                                      onChanged: (val){
                                        setState(() {
                                          SEtat = val as String;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.blueAccent,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Etat ',
                                        prefixIcon: Icon(
                                          Icons.groups,
                                        ),
                                        border:OutlineInputBorder(),
                                      ),
                                    ) ),),),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:double.minPositive, vertical: 5),
                              child: Visibility(
                                visible: myvisibility,
                                child: Padding(
                                  padding: EdgeInsets.only(left:10,right: 10,bottom: 10),
                                  child: RemarqueField,
                                ),
                              ),
                            ),
                            Center(
                                child: Visibility(
                                  visible: myvisibility,
                                  child: MyButton(color: Colors.blue[300], title: "Confirmer suggestion",
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          UpdateDemande(
                                              widget.IdDoc, RemarqueEditingController.text,SEtat.toString());
                                          Navigator.pop(context, const GetDemande());
                                        }
                                      }
                                  ),
                                ) ),
                          ],
                        )),
                  ],
                ),
              ),

            ),



          ],
        ),
      ),
    );
  }
}
