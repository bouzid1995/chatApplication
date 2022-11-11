import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class UpdateSuggestion extends StatefulWidget {
  var Idgsugg;
  var SituationAvant, SituationApres, Description;

  UpdateSuggestion({
    super.key,
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
  final String value = '';
  final NameEditingController = TextEditingController(text: '');
  final Stream<QuerySnapshot> symptomsStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  UpdateSuggestion(String Description, String SituationAvant,
      String SituationApres, dynamic DateProp) async {
    var collection = FirebaseFirestore.instance.collection('basket_items');
    collection
        .doc(this.widget.Idgsugg)
        .update({
          'Description': Description,
          'SituationAvant': SituationAvant,
          'SituationApres': SituationApres,
          'DateProp': DateProp
        }) // <-- Nested value
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
          title: Text('Modifier suggestion'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: formKey,
              child: SingleChildScrollView(

                child: Column(children: <Widget>[
                  Image.asset('images/sug.png',width: 250,height: 250,),

                  TextFormField(
                    autofocus: false,
                    controller: TextEditingController(text: widget.Description),
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{10,}$');
                      if (value!.isEmpty) {
                        return ("Déscription ne peut pas être vide");
                      }
                      if (!regex.hasMatch(value)) {
                        return (" Description invalide ( Minimun 10 caractère )");
                      }
                      return null;
                    },
                    onChanged: (value) {
                      this.widget.Description = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Déscription suggestion ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: TextEditingController(text: widget.SituationAvant),
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{10,}$');
                      if (value!.isEmpty) {
                        return ("Situation avant ne peut pas être vide");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Situation avant invalide ( Minimun 10 caractère )");
                      }
                      return null;
                    },
                    onChanged: (value) {
                      this.widget.SituationAvant = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.safety_check_sharp),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Situation avant ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller:
                        TextEditingController(text: widget.SituationApres),
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{10,}$');
                      if (value!.isEmpty) {
                        return ("Situation aprés ne peut pas être vide ");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Situation aprés invalide (Minimun 10 caractères)");
                      }
                      return null;
                    },
                    onChanged: (value) {
                      this.widget.SituationApres = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.safety_check_rounded),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Situation aprés ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue[300],
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      //minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                        UpdateSuggestion(
                            widget.Description,
                            widget.SituationAvant,
                            widget.SituationApres,
                            Date());

                        Fluttertoast.showToast(
                          msg: 'suggestion modifier avec succceé ',
                          backgroundColor: Colors.green,
                          timeInSecForIosWeb: 2,
                        );

                        Navigator.pop(context);
                      }},
                      child: const Text(
                        "Modifier suggestion ",
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
