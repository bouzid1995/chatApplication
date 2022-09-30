import 'package:chatapplication/screens/WelcomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/UsersModels.dart';
import '../model/basket.dart';
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
      required this.Approuved});

  final String Iduser;
  final String Description;
  final String Date;
  final String SituationAvant;
  final String SituationApres;
  final String Remarque;
  final String Approuved;
  final String IdDoc;

  @override
  State<DetailDemande> createState() => _DetailDemandeState();
}

class _DetailDemandeState extends State<DetailDemande> {
  List<UsersModels> UserItem = [];

 // List<dynamic> dataList1 = [];

  List<dynamic> dataList1 = [{"uid":"","secondName":"","email":"","firstName":""}];
  final RemarqueEditingController = new TextEditingController();

  //List<Object> _historyList = [];

  @override
  void initState() {
    getData(this.widget.Iduser);
    super.initState();

  }

  Future getData(String username) async {
    List dataList = [];
    try {
      await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: username).get().then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          dataList.add(doc.data());
        }),
      });
      print('testing this step');
      print(dataList[0]['firstName']);
      print(dataList[0]['email']);
      print(dataList[0]['secondName']);
      print(dataList[0]['Groupe']);
      print(dataList[0]['Fonction']);
      print(dataList[0]['uid']);
      print(dataList);
      setState(() {
        this.dataList1 = dataList;
      });

      return dataList;

    } catch (e) {
      print(e.toString());
      return null;
    }
  }



  updatedemande(String remarque) async{
    final CollectionReference _products = FirebaseFirestore.instance.collection('user');
    //await _products.Update({"name":remarque});
  }

  UpdateDemande(String Doc,String MyRemarque ) async {

  var collection = FirebaseFirestore.instance.collection('basket_items');
  collection
      .doc(Doc)
      .update({'Approuved' : 'true','Remarque':MyRemarque }) // <-- Nested value
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
          return ("Remarque Cannot be empty ");
        }
        return null;
      },
      onSaved: (value) {
        RemarqueEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.safety_check_rounded),
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: ()=>'',
        ),
        contentPadding: EdgeInsets.fromLTRB(50, 15, 20, 40),
        hintText: "Remarque Suggestion ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    GlobalKey<FormState> _key = GlobalKey();
    final addButton = Material(
      //elevation: 3,
      borderRadius: BorderRadius.circular(20),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
       // minWidth: MediaQuery.of(context).size.width,
        onPressed: () {


          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetDemande()))
        },
        child: const Text(
          "Approuver Suggestion",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 10 , color: Colors.white, fontWeight: FontWeight.bold ),
        ),
      ),
    );



    return Scaffold(
        appBar: AppBar(
          title:  Text(this.widget.IdDoc),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blueAccent, Colors.blueGrey])),
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 180.0,
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
                              horizontal: 20.0, vertical: 3.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 22.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children:   [
                                      const Text(
                                        'Nom et Prenom',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        dataList1[0]['firstName'] == '' ? '' : '${dataList1[0]['firstName']}  ${dataList1[0]['secondName']}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children:   [
                                      const Text(
                                        "Groupe",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '${dataList1[0]['Groupe']}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children:  [
                                      const Text(
                                        "Fonction ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '${dataList1[0]['Fonction']}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
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
            Container(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const Text(
                      "Description:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      this.widget.Description.toString(),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(

              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const Text(
                      "Situation Avant:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(this.widget.SituationAvant.toString(),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

             Container(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const Text(
                      "Situation Apres:",
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(widget.SituationApres.toString(),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(child: Padding(
              padding: EdgeInsets.all(20), //apply padding to all four sides
              child: RemarqueField,
            )),

            //const SizedBox(height: 5),
            Expanded(child: Padding(
              padding: EdgeInsets.all(20),
             child: ElevatedButton(
               onPressed: () async {
                 UpdateDemande(widget.IdDoc,RemarqueEditingController.text);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetDemande()));
                await Navigator.pushNamed(context, WelcomeScreen.screenRoute);
                 // Navigator.of(context).pop()await sleepAsync(1000);
                 //await Navigator.pop(context);

               },
    child: Text('Raised Button'),
    ),
    ),
            )
           // addButton

          ],
        ),
    );
  }
}



