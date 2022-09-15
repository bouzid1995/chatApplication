
import 'dart:convert';

import 'package:chatapplication/screens/get_demande.dart';
import 'package:chatapplication/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';


class AddScreen extends StatefulWidget {

  static const String screenRoute = 'add_screen';



  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreen();
}
    //Description , Destination , Etat , Groupe , Image , Name , uid
class _AddScreen extends State<AddScreen> {

final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  final descriptionEditingController = new TextEditingController();
  final DestinationEditingController = new TextEditingController();
  final EtatEditingController = new TextEditingController();
  final GroupeEditingController = new TextEditingController();
  final NameEditingController = new TextEditingController();

  Future sendEmail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId="service_nyzpiyp";
    const templateId ="template_dssi9xm";
    const userId="";

   final response = await http.post(url,
   headers: {'content-Type':'application/json'},
     body: json.encode({
    "service_id":serviceId ,
    "template_id": templateId,
    "user_id":userId,
      "template_params":{
      "name":"",
        "subject":"Reclamation et demande ",
        "message":"testing message here ",
        "user_email":FirebaseAuth.instance.currentUser!.email,
      }
     })


  );
  }

  final _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {

    final DescriptionField = TextFormField(
      autofocus: false,
      controller: descriptionEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
       RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Description cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 8 Character)");
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
        hintText: "Description demande ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );



    final DestinationField = TextFormField(
      autofocus: false,
      controller: DestinationEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Titre  cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("entrer un titre de votre Demande )");
        }
        return null;
      },
      onSaved: (value) {
        DestinationEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.map),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "titre Demande  ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final EtatField = TextFormField(
      autofocus: false,
      controller: EtatEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Etat  cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 8 Character)");
        }
        return null;
      },
      onSaved: (value) {
        EtatEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.access_time_filled),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Etat  demande ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );




    final GroupeField = TextFormField(
      autofocus: false,
      controller: GroupeEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Groupe cannot be empty ");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 8 Character)");
        }
        return null;
      },
      onSaved: (value) {
        GroupeEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.g_mobiledata_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Groupe  User  ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );



    final NameField = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      controller: NameEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 8 Character)");
        }
        return null;
      },
      onSaved: (value) {
        NameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.abc),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name Demande   ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent.shade100,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          _FormKey.currentState?.validate();
          CreateDemande();


          if (_FormKey != false){
            Fluttertoast.showToast(msg: 'Demand aded succefuly');  //Navigator.pushNamed(context, GetDemande.screenRoute);
          }

          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetDemande()));

        },
        child: const Text(
          "Add Demande",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20 , color: Colors.white, fontWeight: FontWeight.bold ),
        ),
      ),
    );

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Row(
          children: const [
            //Image.asset('images/image.jpg', height: 25),
            SizedBox(width: 20),
            Text('Ajoute une Nouvelle demande ')
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
               //_auth.signOut();
                Navigator.pushNamed(context, SignInScreen.screenRoute);
                //_auth.signOut();
                // Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _FormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 180,
                        child: Image.asset(
                          "images/image.jpg",
                          fit: BoxFit.contain,
                        )),

                    SizedBox(height: 25),
                    NameField,
                    SizedBox(height: 20),
                    GroupeField,
                    SizedBox(height: 20),
                    EtatField,
                    SizedBox(height: 20),
                    DestinationField,
                    SizedBox(height: 20),
                    DescriptionField,
                    SizedBox(height: 20),
                    // Button d'ahjout
                    addButton,
                    //SizedBox(height: 15)

                  ],
                ),
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


        Map<String,dynamic> data = {"name":NameEditingController.text,"description":descriptionEditingController.text,"titre":DestinationEditingController.text,"groupe":GroupeEditingController.text,"Etat":EtatEditingController.text,"user":user.uid};


        //await firebaseFirestore.collection("basket_items").add(data);


    /*descriptionEditingController = new TextEditingController();
  final DestinationEditingController = new TextEditingController();
  final EtatEditingController = new TextEditingController();
  final GroupeEditingController = new TextEditingController();
  final NameEditingController*/

  }





}









