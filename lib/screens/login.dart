import 'package:chatapplication/screens/chat_screen.dart';
import 'package:chatapplication/screens/registration_screen.dart';
import 'package:chatapplication/screens/searchuser.dart';
import 'package:chatapplication/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'WelcomeScreen.dart';



class Login extends StatefulWidget {
  static const String screenRoute = 'Login_screen';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;


  final _formKey  = GlobalKey<FormState>();
  bool _obscureText= true;
  bool _obscureText1= true;
  bool myvisibility = false;
  bool myvisibility2 = true;
  String Role='';
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmpasswordEditingController = new TextEditingController();
  final numtelEditingController = new TextEditingController();
  final groupEditingController = new TextEditingController();
  final fonctionEditingController = new TextEditingController();
  final matriculeEditingController = new TextEditingController();


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
            Role = ds.data()!['Role'];
            if(Role=='Admin'){
              print(Role);
              myvisibility=true;
              myvisibility2 = false;
            }


          });
        }
      }).catchError((e) {
        print(e);
      });
  }

    String? role_id ='Admin';
    final  Roles = ['Admin','user'];
    List test=[];

  @override
  void initState() {
    super.initState();
    fetch();
    print(myvisibility2);
  }
  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
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
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Nom et Prenom",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );



    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Entrer votre Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Entrer un email valide");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final MatriculeField = TextFormField(
      controller: matriculeEditingController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return (" Matricule ne peut pas être vide");
        }

      },
      onSaved: (value) {
        matriculeEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.perm_identity_sharp),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Matricule",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final NumtelField = TextFormField(
      controller: numtelEditingController,
      keyboardType: TextInputType.phone,
      obscureText: false,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Numero Tel ne peut pas être vide");
        }
        if (!regex.hasMatch(value)) {
          return ("Entrer Valide Numero Tel(Min. 8 Character)");
        }
      },
      onSaved: (value) {
        numtelEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone_android),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Num tel",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final groupeField = TextFormField(
      autofocus: false,
      controller: groupEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex =  RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Groupe ne peut pas être vide");
        }
        if (!regex.hasMatch(value)) {
          return ("Entrer Valide Groupe(Min. 3 Charactere)");
        }
        return null;
      },
      onSaved: (value) {
        groupEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Groupe",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final fonctionField = TextFormField(
      autofocus: false,
      controller: fonctionEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex =  RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Fonction ne peut pas être vide");
        }
        if (!regex.hasMatch(value)) {
          return ("Entrer Valide Fonction (Min. 3 Charactere)");
        }
        return null;
      },
      onSaved: (value) {
        fonctionEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.functions),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Fonction",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
     obscureText: _obscureText,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Mot de Passe est obligatoire pour inscription ");
        }
        if (!regex.hasMatch(value)) {
          return ("Entrer Valide Mot de Passe(Min. 6 Charactere)");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        suffixIcon: GestureDetector(onTap: (){
          setState(() {
            _obscureText=!_obscureText;
          });

        },
        child :Icon(_obscureText ? Icons.visibility :Icons.visibility_off),
          ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Mot de Passe ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordEditingController,
        obscureText: _obscureText1,
      validator: (value) {
        if (confirmpasswordEditingController.text != passwordEditingController.text) {
          return "Mot de passe n'est pas conforme";
        }
        else if(confirmpasswordEditingController.text.isEmpty)
          {
            return "Mot de passe vide ";
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
          child :Icon(_obscureText ? Icons.visibility :Icons.visibility_off),
        ) ,


        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
          border:OutlineInputBorder(),
      ),
    );




    final signUpButton = Material(
      elevation: 5,
       borderRadius: BorderRadius.circular(30),
      color: Colors.blue[300],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate())
            {
             //print('Votre form est valide');

              signUp(emailEditingController.text,passwordEditingController.text);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                       SearchUser()));
            // await  Navigator.pushNamed(context, sear.screenRoute);
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



    final Roledropdown = DropdownButtonFormField(

        value: role_id,
        hint: const Text('selectionner un Role'),
        items: Roles.map((e) {
          return DropdownMenuItem(child: Text(e),value:e,);
        }
        ).toList(),
        onChanged: (val){
          setState(() {
            role_id = val as String;
          });
  },
        icon: const Icon(
          Icons.arrow_drop_down_circle,
          color: Colors.blueAccent,
        ),
      decoration: const InputDecoration(
        labelText: 'Role ',
        prefixIcon: Icon(
        Icons.verified_user,
        ),
        border:OutlineInputBorder(),
      ),
        );



    return Scaffold(
      backgroundColor: Colors.white,

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
              title: const Text('Page 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      appBar:AppBar(
        backgroundColor: Colors.blue[300],
        //automaticallyImplyLeading: false,
        title: Row(
          children:  const [ SizedBox(width: 1),
              Text('Ajouter un nouvel utilisateur ')
            ],
        ),
      ),
      body: showwidget(myvisibility,firstNameField,NumtelField,emailField,groupeField,fonctionField,Roledropdown,passwordField,confirmpasswordField,signUpButton,_formKey),


    );

  }


  void signUp(String email, String password) async {
 // if (_formKey.currentUser!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
 // }
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.Fonction = fonctionEditingController.text;
    userModel.Group = groupEditingController.text;
    userModel.NumTel = numtelEditingController.text;
    userModel.Role = role_id;
    userModel.matricule=matriculeEditingController.text;



    if(firstNameEditingController.text == true){

      print('test is her');

    }
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

   /* Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => ChatScreen(firstName:this.firstNameEditingController.text,secondName:secondNameEditingController.text)),
            (route) => false);*/
    //Navigator.of(context).push(MaterialPageRoute(builder:(context) =>ChatScreen()  ));
  }
}


showwidget(bool myvisibility,Widget firstNameField,Widget NumtelField , Widget emailField ,Widget groupeField , Widget fonctionField , Widget Roledropdown , Widget passwordField, Widget confirmpasswordField , Widget signUpButton , dynamic  _formKey   ){
  if(myvisibility==true){

    return  Container (
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: 20),
                  firstNameField,
                  SizedBox(height: 20),
                  NumtelField,
                  SizedBox(height: 20),
                  emailField,
                  SizedBox(height: 20),
                  groupeField,
                  SizedBox(height: 20),
                  fonctionField,
                  SizedBox(height: 20),
                  Roledropdown,
                  SizedBox(height: 20),
                  passwordField,
                  SizedBox(height: 20),
                  confirmpasswordField,
                  SizedBox(height: 20),
                  signUpButton,
                  SizedBox(height: 15),

                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
  else if(myvisibility==false){

    return  Column(
      children:[
        Center(child:CircularProgressIndicator(), ),
        Center(child:Text('Vous etes pas autorisé '),)

      ]

    );

  } else {

    CircularProgressIndicator();
  }



}
