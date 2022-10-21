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
  List<dynamic> RoleList = [{"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}];


  Stream<QuerySnapshot>  StreamGroupe = FirebaseFirestore.instance.collection('basket_items').orderBy('DateProp', descending: true).snapshots();

  Stream<QuerySnapshot>  MyStream = FirebaseFirestore.instance.collection('basket_items').orderBy('DateProp', descending: true).where('user',isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots();

  Stream<QuerySnapshot>  StreamGroupe1 = FirebaseFirestore.instance.collection('basket_items').where("Approuved",isEqualTo:"true").orderBy('DateProp', descending: true).snapshots();
  final descriptionEditingController = new TextEditingController();
  final AvantEditingController = new TextEditingController();
  final ApresEditingController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getstream(_auth.currentUser?.uid.toString());
    super.initState();
  }


  getstream(dynamic username) async {
    List dataList = [];
    print('entet function');

  Stream<QuerySnapshot> StreamGroup =  FirebaseFirestore.instance
      .collection('basket_items').where("Approuved", isEqualTo: "true")
      .orderBy('DateProp', descending: true)
      .snapshots();
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

      }
      else if (this.RoleList[0]['Role'] == 'user') {
        print('User connected is  user');

        setState(()  {
         this.StreamGroupe =   FirebaseFirestore.instance.collection('basket_items').where("Approuved", isEqualTo: "true").snapshots();
        });

      }

      return StreamGroupe ;

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

    Map<String,dynamic> data = {"Description":descriptionEditingController.text,"SituationAvant":AvantEditingController.text,"SituationApres":ApresEditingController.text,"user":user.uid,"DateProp": Date(),"Approuved":"False", "Remarque":""};

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
          onPressed: ()=>descriptionEditingController.clear(),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
          onPressed: ()=>descriptionEditingController.clear(),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
          onPressed: ()=>descriptionEditingController.clear(),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Situation Apres ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );



    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {

          if (_formKey.currentState!.validate()) {
            CreateDemande();
            Fluttertoast.showToast(msg: 'Suggestion ajouteé avec  succees ');
            //Navigator.pushNamed(context, GetDemande.screenRoute);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupeScreen()));

          }
        },
        child: const Text(
          "Ajouter",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20 , color: Colors.white, fontWeight: FontWeight.bold ),
        ),
      ),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
                drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                ),
                title: const Text('Page 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.train,
                ),
                title: const Text('Signout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SignInScreen()));
                },
              ),
            ],
          ),
        ),

          appBar: AppBar(
            backgroundColor: Colors.blue[300],
            title: Row(
              children:  const [ SizedBox(width: 20),
                Text('Liste Des Suggestions ')
              ],
            ),
            bottom: const TabBar(
              tabs:[Text('tous les  suggestion'),Text('Mes Suggestions encours ')],
            ),

            actions: [
              IconButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, SignInScreen.screenRoute);

                    //_auth.signOut();
                    // Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          body:TabBarView(

            children: [
              StreamBuilder<QuerySnapshot>(
                stream: StreamGroupe,
                // : FirebaseFirestore.instance.collection('basket_items') .where("Approuved",isEqualTo: true).snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||!snapshot.hasData ||snapshot.data?.size == '' ||snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  {
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {

                        return Card(
                            child: ListTile(
                              title: Text(doc.get('Description').toString()),
                              subtitle: Text(doc.get('Approuved')),
                              trailing: Text(doc.get('DateProp').toString()),
                              onTap: () async {
                                await  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailDemande(
                                        IdDoc: doc.id,
                                        Iduser: doc.get('user'),
                                        Description: doc.get('Description'),
                                        Date: doc.get('DateProp'),
                                        SituationAvant: doc.get('SituationAvant'),
                                        SituationApres: doc.get('SituationApres'),
                                        Remarque: doc.get('Remarque'),
                                        Approuved: doc.get('Approuved')),
                                  ),
                                );
                              },
                              leading:  const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Icon(Icons.article_outlined),
                              ),

                            ));
                      }).toList(),
                    );

                  }
                }),


   StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance.collection('basket_items').where('Approuved',isEqualTo:'false' ).where("user",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
        //FirebaseFirestore.instance.collection('basket_items') .where("user",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting  ||snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          }
          if(!snapshot.hasData || snapshot.data?.size == '' ){

            return Center(child: Text('Vous avez Aucun Suggestion En cours '),);
          }
    else {
            return ListView(
              children: snapshot.data!.docs.map((doc) {

                return Card(
                    child: ListTile(
                      title: Text(doc.get('Description').toString()),
                      subtitle: Text(doc.get('Approuved')),//Text(doc.get('DateProp'))
                      trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                       // Text(doc.get('DateProp').toString()),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 20.0,
                            color: Colors.brown[900],
                          ),
                          onPressed: () {

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdateSuggestion(
                                  Idgsugg: doc.id,
                                  SituationAvant: doc.get('SituationAvant').toString(),
                                  SituationApres : doc.get('SituationApres'),
                                  Description:doc.get('Description').toString(),
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
                                  title: const Text("Suppression Suggestion "),
                                  content: const Text("Voulez vous supprimez cette Suggestion ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child:  const Text("Continuer"),
                                      onPressed: () {
                                        deletSugg(doc.id);

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

                      onTap: () async {
                        await  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailDemande(
                                IdDoc: doc.id,
                                Iduser: doc.get('user'),
                                Description: doc.get('Description'),
                                Date: doc.get('DateProp').toString(),
                                SituationAvant: doc.get('SituationAvant'),
                                SituationApres: doc.get('SituationApres'),
                                Remarque: doc.get('Remarque'),
                                Approuved: doc.get('Approuved')),
                          ),
                        );
                      },
                      leading:  const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(Icons.article_outlined),
                      ),


                    ));
              }).toList(),
            );
          }


        }),


            ],

          ) ,





 ///Ajouter une suggestion Popup
      floatingActionButton: FloatingActionButton(
      onPressed: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: 180,
                            child: Image.asset(
                              "images/MSPE_Logo.png",
                              fit: BoxFit.contain,
                            )),


                        const SizedBox(height: 20),
                        DescriptionField,
                        const SizedBox(height: 20),
                        SituationAvantField,
                        const SizedBox(height: 20),
                        SituationApresField,
                        const SizedBox(height: 20),
                        // Button d'ahjout
                        addButton,
                        //SizedBox(height: 15)

                      ],
                    ),
                  ),
                  title: const Center(child:Text('Ajouter Une Suggestion')),

                );
              });
            });
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
      ),

      ),
    );
  }
}
