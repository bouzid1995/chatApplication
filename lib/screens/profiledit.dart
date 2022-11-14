import 'package:chatapplication/screens/WelcomeScreen.dart';
import 'package:chatapplication/screens/signin_screen.dart';
import 'package:chatapplication/widgets/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main_drawer.dart';


class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String? firstName ='';
  String?  myfonction ='';
  String?  myGroupe ='';
  String? myNumTel ='';
  String? uiduser = '' ;
  String? mypass ='' ;



  final firstNameEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmpasswordEditingController = new TextEditingController();
  final numtelEditingController = new TextEditingController();
  final groupEditingController = new TextEditingController();
  final fonctionEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool? checkedValue=false ;
  bool? visibl =false ;
  String etat="";


  fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) async {
        if (ds.exists) {
        return  setState(() {
             firstName = ds.data()!['firstName'];
             myfonction = ds.data()!['Fonction'];
             myGroupe = ds.data()!['Groupe'];
             myNumTel = ds.data()!['NumTel'];
             uiduser = firebaseUser.uid;
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
      FirebaseAuth.instance.signOut();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SignInScreen()));
    }

  }



  void updateuser( String NumTel,String uiduser) async{
    //Create an instance of the current user.
    var collectionusers = FirebaseFirestore.instance.collection('users');
    collectionusers
        .doc(uiduser)
        .update(
        { 'NumTel':NumTel }) // <-- Nested value
        .then((_) => print('Success'))

        .catchError((error) => print('Failed: $error'));
  }


  updatepassword (String password) async {
    final user = await FirebaseAuth.instance.currentUser!;
    try{
      await user.updatePassword(password);
      print('password changed successufly');

    }catch(error){
      print(error);
    }


  }

  updateusers(String NumTel,String uiduser,String password ){

    if(password!=''){
      updateuser(NumTel,uiduser);

      setState(() async {
        final user = await FirebaseAuth.instance.currentUser!;
        try{
          await user.updatePassword(password);
          print('password changed successufly');

          Fluttertoast.showToast(
            msg: 'profil mise a jour avec succceé vous devez reconnectez  ',
            backgroundColor:Colors.green,
            timeInSecForIosWeb:1,
          );
          print('test1');
          FirebaseAuth.instance.signOut();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SignInScreen()));

        }catch(error){
          print(error);
        }
      });


    }
    else {
      updateuser(NumTel,uiduser);
      Fluttertoast.showToast(
        msg: 'profil mise a jour avec succceé ',
        backgroundColor:Colors.green,
        timeInSecForIosWeb: 1,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => WelcomeScreen(MyIndex: 3,)),
      );

    }


  }

  @override
  void initState() {
    super.initState();
    fetch();
  }
  @override
  Widget build(BuildContext context) {

    final firstNameField = TextFormField(
      autofocus: false,
      enabled: false,
      controller: TextEditingController(text: this.firstName),
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{5,}$');
        if (value!.isEmpty) {
          return ("Votre Nom et Prenom n'est pas Valide ");
        }
        if (!regex.hasMatch(value)) {
          return (" Nom Prenom doit etre plus que 5 caractere )");
        }
        return null;
      },
      onChanged: (value) {
        this.firstName = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Nom et Prenom",
        labelText: "Nom et Prenom",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );



    final GroupeField = TextFormField(
      autofocus: false,
      enabled: false,
      controller: TextEditingController(text: this.myGroupe),
      keyboardType: TextInputType.text,

      onSaved: (value) {
        this.myGroupe = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.group_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Groupe",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final fonctionField = TextFormField(
      autofocus: false,
      enabled: false,
      controller: TextEditingController(text: this.myfonction),
      keyboardType: TextInputType.text,

      onChanged: (value) {
        this.myfonction = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.functions),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Fonction",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );


    final NumtelField = TextFormField(
      autofocus: false,
      controller: TextEditingController(text:myNumTel.toString()),
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Numero Tel ne peut pas être vide");
        }
        if (!regex.hasMatch(value)) {
          return (" Numero Tel iunvalid ( Minimun  8 caractère )");
        }
      },
      onChanged: (value) {
        this.myNumTel = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone_android),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Télèphone",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );


    final passwordField = TextFormField(
      autofocus: false,
      obscureText: _obscureText,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return (" Mot de passe n'est peut pas etre vide  ");
        }
        if (!regex.hasMatch(value)) {
          return ("Mot de Passe invalid (Minimun 6 caractère)");
        }
        return null;
      },
      onChanged: (value) {
        mypass = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Nouveau mot de passe ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: GestureDetector(onTap:(){

          setState(() {
            _obscureText=!_obscureText;
          });

        },
          child :Icon(_obscureText ? Icons.visibility :Icons.visibility_off),
      ),
      ) );


    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordEditingController,
      obscureText: _obscureText1,
      validator: (value) {

        if (confirmpasswordEditingController.text != mypass) {
          return "Mot de passe n'est pas conforme";
        }
        if (value!.isEmpty) {
          return (" Mot de passe n'est peut pas etre vide  ");
        }
        return null;
      },
      onSaved: (value) {
        confirmpasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration:  InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        suffixIcon: GestureDetector(onTap:(){

          setState(() {
            _obscureText1=!_obscureText1;
          });

        },
          child :Icon(_obscureText1 ? Icons.visibility :Icons.visibility_off),
        ) ,


        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Confirmer Mot de passe ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );


    final savedUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width-15,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {

            updateusers(myNumTel!, uiduser!,mypass!);
          }    },

        child: const Text(
          "Mettre à jour ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title:Text('Modifier Profil '),
          //centerTitle: true,
        ),
        body: SingleChildScrollView(
                child: Container(
                    //color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                 Opacity(
                                   opacity: 0.8,
                                 child:Image.asset('images/user.png',width: 100,height: 100,),
                                 ),

                                  SizedBox(height: 30),
                                  firstNameField,
                                  SizedBox(height: 30),
                                  fonctionField,
                                  SizedBox(height: 30),
                                  GroupeField,
                                  SizedBox(height: 20),
                                  NumtelField,
                                  SizedBox(height: 10),

                                /*  CheckboxListTile(
                                    title: Text("Cliquer pour mettre a jour votre mot de passe "),
                                    value: checkedValue,
                                    onChanged: (checkedValue) {
                                      setState(() {
                                        this.checkedValue = checkedValue!;
                                          this.visibl = checkedValue;
                                        print('visible est ');
                                        print(visibl);
                                        print('checkbox');
                                        print(checkedValue);
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),*/
                                  SizedBox(height: 2),

                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if(visibl==false){
                                          this.visibl = true;
                                        }
                                        else
                                          this.visibl = false;
                                        print('visible est ');
                                        print(visibl);

                                      });
                                    },
                                    child: Text('Cliquer ici pour changer votre Mot de passe    \u{1F511} ',style:TextStyle(fontSize:17),),
                                  ),


                                  SizedBox(height: 2),

                                  Visibility(
                                    visible: visibl!,
                                    child: passwordField,
                                  ),

                                  SizedBox(height: 10),

                                  Visibility(
                                       visible: visibl!,
                                       child: confirmpasswordField
                                  ),

                                  SizedBox(height: 10),
                                  MyButton(color: Colors.blue[300]!, title: 'Mettre a jour ',
                                    onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      updateusers(myNumTel!, uiduser!,mypass!);
                                    }    }, ),

                                  //savedUpButton
                                ]))))));
  }
}
