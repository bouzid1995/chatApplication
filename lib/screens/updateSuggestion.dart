
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class UpdateSuggestion extends StatefulWidget {
  var Idgsugg;
  var SituationAvant,SituationApres,Description;



  UpdateSuggestion({super.key,
    required this.Idgsugg,
    required this.SituationAvant,
    required this.SituationApres,
    required this.Description,

  });


  @override
  State<UpdateSuggestion> createState() => _UpdateSuggestionState();
}

class _UpdateSuggestionState extends State<UpdateSuggestion> {
  final formKey = new GlobalKey<FormState>();
  List SuggList = [];
    List users = [];
  final String value='';
  final NameEditingController = TextEditingController(text:'');
  final Stream<QuerySnapshot> symptomsStream = FirebaseFirestore.instance.collection('users').snapshots();

  UpdateSuggestion(String Description,String SituationAvant ,String SituationApres ,dynamic DateProp   ) async {
    var collection = FirebaseFirestore.instance.collection('basket_items');
    collection
        .doc(this.widget.Idgsugg)
        .update(
        {'Description': Description, 'SituationAvant': SituationAvant, 'SituationApres':SituationApres , 'DateProp':DateProp }) // <-- Nested value
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
  }

    Date() {
    String datetime = DateFormat("dd-MM-yyyy").format(DateTime.now());
    print(datetime);
    return datetime;
  }


  @override
  void initState() {
    super.initState();
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text('Edit Suggestion '),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey ,
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: TextEditingController(text:widget.Description),
                    //controller: widget.Description,
                    onChanged: (value) {
                      this.widget.Description =value;
                    },

                    decoration: const InputDecoration(
                      labelText: 'Description Suggestion',
                      icon: Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  TextFormField(
                    controller: TextEditingController(text:widget.SituationAvant),

                    onChanged: (value) {

                      this.widget.SituationAvant = value;

                    },
                    decoration: const InputDecoration(
                      labelText: 'Situation Avant ',
                      icon: Icon(Icons.real_estate_agent_rounded),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  TextFormField(
                    controller: TextEditingController(text:widget.SituationApres),

                    onChanged: (value) {
                      this.widget.SituationApres = value;

                    },
                    decoration: const InputDecoration(
                      labelText: 'Situation Apres ',
                      icon: Icon(Icons.real_estate_agent_rounded),
                    ),
                  ),

                  SizedBox(height: 30,),

                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue[300],
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      //minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        UpdateSuggestion(widget.Description,widget.SituationAvant,widget.SituationApres,Date());

                          Fluttertoast.showToast(
                            msg: 'Groupe mise a jour avec succceé ',
                            backgroundColor:Colors.green,
                            timeInSecForIosWeb: 6,
                          );

                          Navigator.pop(context);

                      },
                      child: const Text(
                        "Mise a jour Suggestion ",
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


