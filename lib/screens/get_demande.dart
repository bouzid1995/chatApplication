import 'package:chatapplication/screens/signin_screen.dart';
import 'package:chatapplication/screens/updateSuggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/basket.dart';
import '../model/UsersModels.dart';
import 'Details.dart';
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
  String etat ="";

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

String email ='';

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
        print('etat user est ${this.RoleList[0]['etat']}');

        this.StreamGroupe = await FirebaseFirestore.instance
            .collection('basket_items')
            .orderBy('DateProp', descending: true)
            .snapshots();
      } else if (this.RoleList[0]['Role'] == 'user') {
        print('User connected is  user');
        print('etat user est ${this.RoleList[0]['etat']}');
        setState(() {
          this.StreamGroupe = FirebaseFirestore.instance
              .collection('basket_items')
              .where("Etat", isEqualTo: "Approuver")
              .snapshots();
        });
      }
      //NonActif

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


  fetchstate() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) async {
        if (ds.exists) {
          return  setState(() {
            etat = ds.data()!['etat'];

          });
        }
      }).catchError((e) {
        print(e);
      });
    setState(() {
      etat;
    });

    if(etat=='NonActif'){
      await FirebaseAuth.instance.signOut();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SignInScreen()));

    }


  }


  @override
  void initState() {
    getstream(_auth.currentUser?.uid.toString());
    super.initState();
    fetchstate();
    getData();
  }


  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var optionemail = prefs.getString('email')!;
      setState(() {
        email = optionemail;
      });
      print(email);
    });
  }

  @override
  Widget build(BuildContext context) {





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
                        hintText: "Recherhcer... ",
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
                    this.text = '';
                  }
                });
              },
            )
          ],
          bottom: const TabBar(
            tabs: [Text('Tous les suggestions',style: TextStyle(fontSize:18 ),), Text('Mes suggestions',style: TextStyle(fontSize:18 ),)],
          ),

        ),
        body:
          TabBarView(
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
                                            4),style: TextStyle(fontSize: 15),),
                                   subtitle: Text(data['Etat'].toString(),style: TextStyle(fontSize: 13)),
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
                                            4),style: TextStyle(fontSize: 15)),
                                subtitle: Text(data['Etat'],style: TextStyle(fontSize: 13)) ,
                                trailing: Text(data['DateProp'].toString(),style: TextStyle(fontSize: 15)),
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
                            if (text.isEmpty  ) {
                              if(data['Description'] !='Approuver')
                                {
                                  mycolor = Colors.orange;
                                }
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
                                      .toString(),style: TextStyle(fontSize: 15),),
                                  subtitle: Text(data['Etat'].toString(),style: TextStyle(fontSize: 13)) ,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                     // Text(data['DateProp'].toString()),
                                      Visibility(
                                        visible: data['Etat'] == 'En attente' ? true : false ,
                                          child:IconButton(
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
                                      )),
                                      Visibility(
                                        visible: data['Etat'] == 'En attente' ? true : false ,
                                        child: IconButton(
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


