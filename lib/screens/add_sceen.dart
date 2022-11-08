
import 'dart:convert';

import 'package:chatapplication/screens/WelcomeScreen.dart';
import 'package:chatapplication/screens/get_demande.dart';
import 'package:chatapplication/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


import 'groupescreen.dart';
import 'login.dart';


class AddScreen extends StatefulWidget {

  static const String screenRoute = 'add_screen';



  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreen();
}
    //Description , Destination , Etat , Groupe , Image , Name , uid
class _AddScreen extends State<AddScreen> {
  final String Approuved='False' ;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final descriptionEditingController = new TextEditingController();
  final AvantEditingController = new TextEditingController();
  final ApresEditingController = new TextEditingController();

  Date() {

    String datetime = DateFormat("dd-MM-yyyy").format(DateTime.now());
    print(datetime);
    return datetime;
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
        contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 15),
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
        contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 15),
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
        contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 15),
        hintText: "Situation Après ",
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomeScreen(MyIndex: 0,)));


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



    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue,
        title: Text('Ajoute une Nouvelle Suggestion '),
        automaticallyImplyLeading: false,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(left:20,right: 20,top:30,bottom:200),
              child: Form(
                key: _formKey,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Image.asset('images/sug.png',width: 150,height: 150,),
                    const SizedBox(height: 25),
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
            ),

        ),
      ),
    );

  }



     CreateDemande() async {

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser!;

          Map<String,dynamic> data = {"Description":descriptionEditingController.text,"SituationAvant":AvantEditingController.text,"SituationApres":ApresEditingController.text,"user":user.uid,"DateProp": Date(),"Etat":'En attente', "Remarque":""};

          await firebaseFirestore.collection("basket_items").add(data);

    }





}









