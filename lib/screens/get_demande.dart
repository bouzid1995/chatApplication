import 'package:chatapplication/screens/signin_screen.dart';
import 'package:chatapplication/screens/updateSuggestion.dart';
import 'package:chatapplication/screens/updategroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../model/basket.dart';
import '../model/UsersModels.dart';
import 'Details.dart';
import 'WelcomeScreen.dart';
import 'add_sceen.dart';
import 'main_drawer.dart';

class GetDemande extends StatefulWidget {
  static const String screenRoute = 'Demande_screen';

  const GetDemande({Key? key}) : super(key: key);

  @override
  State<GetDemande> createState() => _GetDemandeState();
}

class _GetDemandeState extends State<GetDemande> {
  List<Item> demandeItem = [];
  List<UsersModels> UserItem = [];
  final _auth = FirebaseAuth.instance;
  List<dynamic> RoleList = [
    {"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}
  ];
  Color mycolor = Colors.white;
  String text = "";

  Stream<QuerySnapshot> StreamGroupe = FirebaseFirestore.instance
      .collection('basket_items')
      .orderBy('DateProp', descending: true)
      .snapshots();

  Stream<QuerySnapshot> MyStream = FirebaseFirestore.instance
      .collection('basket_items')
      .orderBy('DateProp', descending: true)
      .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();


  final descriptionEditingController = new TextEditingController();
  final AvantEditingController = new TextEditingController();
  final ApresEditingController = new TextEditingController();
  Icon actionButton = Icon(Icons.search);
  Widget appBarTitle = new Text('Liste des suggestions');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getstream(_auth.currentUser?.uid.toString());
    super.initState();
  }

  getstream(dynamic username) async {
    List dataList = [];
    print('entet function');

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

      if (this.mounted) {
        setState(() {
          RoleList = dataList;
        });
      }

      if (this.RoleList[0]['Role'] == 'Admin') {
        print('user connected is Admin');

        this.StreamGroupe = await FirebaseFirestore.instance
            .collection('basket_items')
            .orderBy('DateProp', descending: true)
            .snapshots();
      } else if (this.RoleList[0]['Role'] == 'user') {
        print('User connected is  user');

        setState(() {
          this.StreamGroupe = FirebaseFirestore.instance
              .collection('basket_items')
              .where("Etat", isEqualTo: "Approuved")
              .snapshots();
        });
      }

      return StreamGroupe;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Date() {
    String datetime = DateFormat("dd-MM-yyyy").format(DateTime.now());
    print(datetime);
    return datetime;
  }

  //Creation d'une demande
  CreateDemande() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    Map<String, dynamic> data = {
      "Description": descriptionEditingController.text,
      "SituationAvant": AvantEditingController.text,
      "SituationApres": ApresEditingController.text,
      "user": user.uid,
      "DateProp": Date(),
      "Etat": 'En attente',
      "Remarque": ""
    };

    await firebaseFirestore.collection("basket_items").add(data);
  }

  deletSugg(String ID) async {
    var collection = FirebaseFirestore.instance.collection('basket_items');
    await collection.doc(ID).delete();
  }

  @override
  Widget build(BuildContext context) {
    final DescriptionField = TextFormField(
      autofocus: false,
      controller: descriptionEditingController,
      minLines: 2,
      maxLines: 5,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return ("Description ne peut pas être vide");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Description (Min. 10 Character)");
        }
        return null;
      },
      onSaved: (value) {
        descriptionEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.description),
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => descriptionEditingController.clear(),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 45, 30, 15),
        hintText: "Description Suggestion ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final SituationAvantField = TextFormField(
      autofocus: false,
      controller: AvantEditingController,
      minLines: 2,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return ("Situation Avant ne peut pas être vide");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Situation Avant (Min. 10 Character)");
        }
        return null;
      },
      onSaved: (value) {
        AvantEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.safety_check_sharp),
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => descriptionEditingController.clear(),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 45, 20, 15),
        hintText: "Situation Avant ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final SituationApresField = TextFormField(
      autofocus: false,
      controller: ApresEditingController,
      minLines: 2,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return ("Situation ne peut pas être vide ");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Situation Apres (Min. 10 Character)");
        }
        return null;
      },
      onSaved: (value) {
        ApresEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.safety_check_rounded),
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => descriptionEditingController.clear(),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 45, 20, 15),
        hintText: "Situation Apres ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );



    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MainDrawer(),

        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: actionButton,
              onPressed: () {
                setState(() {
                  if (this.actionButton.icon == Icons.search) {
                    this.actionButton = new Icon(Icons.close);
                    this.appBarTitle = TextFormField(
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Recherhcer....... ",
                        labelText: 'Rechercher ',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (val) {
                        setState(() {
                          text = val;
                        });
                      },
                    );
                  } else {
                    this.actionButton = new Icon(Icons.search);
                    this.appBarTitle = new Text('Liste des suggestions');
                  }
                });
              },
            )
          ],
          bottom: const TabBar(
            tabs: [Text('Tous les suggestion'), Text('Mes suggestions')],
          ),

          /* actions: [
              IconButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, SignInScreen.screenRoute);

                    //_auth.signOut();
                    // Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],*/
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: StreamGroupe,
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
                            if (text.isEmpty) {
                                  if(data['Etat'] == 'En attente') {
                                    mycolor = Colors.orange;
                                  } else if (data['Etat'] == 'Rejeté')
                                      {
                                        mycolor = Colors.redAccent;
                                      } else if (data['Etat'] == 'Réfusé')
                                            {
                                              mycolor = Colors.red;
                                            }
                                  else
                                    mycolor = Colors.green;

                                  return Card(
                                  child: ListTile(
                                tileColor: Colors.white,
                                title: Text(data['Description']
                                    .toString()
                                    .substring(
                                        0,
                                        data['Description'].toString().length -
                                            4)),
                                   subtitle: Text(data['Etat'].toString()),
                                trailing: Text(data['DateProp'].toString()),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailDemande(
                                          IdDoc: snapshots.data!.docs[index].id,
                                          Iduser: data['user'],
                                          Description: data['Description'],
                                          Date: data['DateProp'],
                                          SituationAvant:
                                              data['SituationAvant'],
                                          SituationApres:
                                              data['SituationApres'],
                                          Remarque: data['Remarque'],
                                          Etat: data['Etat'].toString()),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: Icon(
                                    Icons.article_outlined,
                                    color: mycolor,
                                  ),
                                ),
                              ));
                            }
                            if (data['Description']
                                .toString()
                                .toLowerCase()
                                .startsWith(text.toLowerCase())) {
                              if(data['Etat'] == 'En attente') {
                                mycolor = Colors.orange;
                              } else if (data['Etat'] == 'Rejeté')
                              {
                                mycolor = Colors.redAccent;
                              } else if (data['Etat'] == 'Réfusé')
                              {
                                mycolor = Colors.red;
                              }
                              else
                                mycolor = Colors.green;
                              return Card(
                                  child: ListTile(
                                tileColor: Colors.white,
                                title: Text(data['Description']
                                    .toString()
                                    .substring(
                                        0,
                                        data['Description'].toString().length -
                                            4)),
                                subtitle: data['Etat'] == 'En attente'
                                    ? Text('Pas Approuver')
                                    : Text('Approuver'),
                                trailing: Text(data['DateProp'].toString()),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailDemande(
                                          IdDoc: snapshots.data!.docs[index].id,
                                          Iduser: data['user'],
                                          Description: data['Description'],
                                          Date: data['DateProp'],
                                          SituationAvant:
                                              data['SituationAvant'],
                                          SituationApres:
                                              data['SituationApres'],
                                          Remarque: data['Remarque'],
                                          Etat: data['Etat']),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: Icon(
                                    Icons.article_outlined,
                                    color: mycolor,
                                  ),
                                ),
                              ));
                            }
                            return Container();
                          });

                  return Container();
                }),

            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('basket_items')
                    .where("user",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    //.where('Etat', isEqualTo:'En attente')
                    //.where('Etat', isEqualTo: 'Rejeté')
                    .snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting || snapshots.hasError || !snapshots.hasData )
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;
                            if (text.isEmpty && data['Description'] !='Approuved' ) {
                              if(data['Etat'] == 'En attente') {
                                mycolor = Colors.orange;
                              } else if (data['Etat'] == 'Rejeté')
                              {
                                mycolor = Colors.redAccent;
                              } else if (data['Etat'] == 'Réfusé')
                              {
                                mycolor = Colors.red;
                              }
                              else
                                mycolor = Colors.green;
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Icon(Icons.article_outlined,
                                        color: mycolor),
                                  ),
                                  tileColor: Colors.white,
                                  title: Text(data['Description']
                                      .toString()
                                      .substring(
                                          0,
                                          data['Description']
                                                  .toString()
                                                  .length -
                                              4)),
                                  subtitle: Text(data['Etat'].toString()) ,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(data['DateProp'].toString()),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 20.0,
                                          color: Colors.brown[900],
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          UpdateSuggestion(
                                                            Idgsugg: snapshots
                                                                .data!
                                                                .docs[index]
                                                                .id,
                                                            SituationAvant:
                                                                data['SituationAvant']
                                                                    .toString(),
                                                            SituationApres:
                                                                data['SituationApres']
                                                                    .toString(),
                                                            Description: data[
                                                                    'Description']
                                                                .toString(),
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
                                                title: const Text(
                                                    "Suppression Suggestion "),
                                                content: const Text(
                                                    "Voulez vous supprimez cette Suggestion ?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child:
                                                        const Text("Continuer"),
                                                    onPressed: () {
                                                      deletSugg(snapshots.data!
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
                                    ],
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailDemande(
                                            IdDoc: snapshots.data!.docs[index].id,
                                            Iduser: data['user'],
                                            Description: data['Description'],
                                            Date: data['DateProp'],
                                            SituationAvant:
                                            data['SituationAvant'],
                                            SituationApres:
                                            data['SituationApres'],
                                            Remarque: data['Remarque'],
                                            Etat: data['Etat'].toString()),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            if (data['Description']
                                .toString()
                                .toLowerCase()
                                .startsWith(text.toLowerCase()) && data['Description'] !='Approuved') {
                              if(data['Etat'] == 'En attente') {
                                mycolor = Colors.orange;
                              } else if (data['Etat'] == 'Rejeté')
                              {
                                mycolor = Colors.redAccent;
                              } else if (data['Etat'] == 'Réfusé')
                              {
                                mycolor = Colors.red;
                              }
                              else
                                mycolor = Colors.green;
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Icon(Icons.article_outlined,
                                        color: mycolor),
                                  ),
                                  tileColor: Colors.white,
                                  title: Text(data['Description']
                                      .toString()
                                      .substring(0,
                                          data['Description']
                                                  .toString()
                                                  .length -
                                              4)),
                                  subtitle: Text(data['DateProp'].toString()),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 20.0,
                                          color: Colors.brown[900],
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          UpdateSuggestion(
                                                            Idgsugg: snapshots
                                                                .data!
                                                                .docs[index]
                                                                .id,
                                                            SituationAvant:
                                                                data['SituationAvant']
                                                                    .toString(),
                                                            SituationApres:
                                                                data['SituationApres']
                                                                    .toString(),
                                                            Description: data[
                                                                    'Description']
                                                                .toString(),
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
                                                title: const Text(
                                                    "Suppression Suggestion "),
                                                content: const Text(
                                                    "Voulez vous supprimez cette Suggestion ?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child:
                                                        const Text("Continuer"),
                                                    onPressed: () {
                                                      deletSugg(snapshots.data!
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
                                    ],
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailDemande(
                                            IdDoc: snapshots.data!.docs[index].id,
                                            Iduser: data['user'],
                                            Description: data['Description'],
                                            Date: data['DateProp'],
                                            SituationAvant:
                                            data['SituationAvant'],
                                            SituationApres:
                                            data['SituationApres'],
                                            Remarque: data['Remarque'],
                                            Etat: data['Etat']),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return Container();
                          });

                  return Container();
                }),
          ],
        ),

        /// Redirection vers la page d'ajout d'une suggestion
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(    context, MaterialPageRoute(builder: (context) => AddScreen()));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
