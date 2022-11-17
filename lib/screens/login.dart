import 'package:chatapplication/screens/signin_screen.dart';
import 'package:chatapplication/widgets/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/user_model.dart';
import 'WelcomeScreen.dart';
import 'main_drawer.dart';



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

  List<String> useretatList =['Actif','NonActif'];
  String? useretat = 'Actif';
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


  List<String> groups = ['Comptabilité','Développement','Formation','FST-Logistique','GRH','IE','Informatique','Logistique Externe','Logistique Interne','PPS','Production','PrûfTechnique','Qualité','Technique','FFC','Commerciale','Direction'];
  String? groupes='Formation';

  List<String> CommercialeProvince  = ['Resp Technico-commerciale','Responsable Comptabilité','Chef Service Comptabilité'];
  List<String> DeveloppementProvince  = ["Agent Développement","Responsable Développement","Chef Service Développement"];
  List<String> FormationProvince  = ["Formateur","Responsable Formation","Chef Service Formation","Formation Team Leader"];
  List<String> FSTLogistiqueProvince  = ["Agent FST","Responsable FST","Chef Service FST – Logistique"];
  List<String> GRHProvince  = ["Chauffeur","Concierge","Femme Ménage","Responsable RH","Chef Service GRH","Agent Administrative","Agent Sos","Assistant","Coordinateur Recrutement et Intégration","RH Team Leader","Directeur"];
  List<String> IEProvince  = ["Agent Ratio","Agent AV","AV Team leader","Chef de Poste AV","Responsable IE","Chef Service IE",", Agent FBB"];
  List<String> InformatiqueProvince  = ["Agent Informatique","Responsable Informatique","Chef Service Informatique"];
  List<String> LogistiqueExterneProvince  = ["Agent Logistique Externe","Responsable Logistique Externe","Agent Logistique Interne","Chef Poste Logistique Interne"];
  List<String> LogistiqueInterneProvince  = ["Agent Logistique Interne","Chef Poste Logistique Interne","Responsable Logistique","Chef Service Logistique Interne"];
  List<String> PPSProvince   = ["Agent PPS","Responsable PPS","PPS Team Leader"];
  List<String> ProductionProvince   = ["Alimentateur","Montage","Agent CFE","Agent Contrôle 100%","Agent Emballage","Chef de Poste Production","Chef de poste KPI Reporting","Prod Team Leader","Réparateur","Porte-parole"];
  List<String> PrufTechniqueProvince   = ["Agent PrûfTechnique","Responsable PrûfTechnique","Chef Service PrûfTechnique","Chef de Poste Prûftechnik"];
  List<String> QualiteProvince   = ["Agent Qualité","Agent QGate","Coordinateur Client","Responsable Fournisseur","Responsable Qualité","Responsable Qualité Produit","Chef Service Qualité","Chef de poste Qualité","Responsable Processus ESD","Assistante Qualité"];
  List<String> TechniqueProvince    = ["Agent Technique","Agent Maintenance","Responsable Technique","Chef Service Technique","Chef de Poste Tech"];
  List<String> FFCProvince    = ["Conducteur Machine","Ingénieur Projet","Team Leader Plasturgie","Responsable Logistique"];
  List<String> DirectionProvince    = ["Gerant"];

  List<String>? Functions = [];
  String? selectedGroupe;
  String? selectedFunction ;
  String etat ="";


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
    super.initState();
    fetch();
    FirebaseMessaging.instance.getToken().then((token) {
        setState(() {
          print('test');
          print(mtoken);
        });

      });


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
          return ("Votre Nom et prénom n'est pas Valide ");
        }
        if (!regex.hasMatch(value)) {
          return (" Nom prénom doit etre plus que 5 caractere )");
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
        hintText: "Nom et prénom",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );



    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Email ne peut pas être vide ");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Entrer un émail Valide ");
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
          return ("Entrer un Numero Tel Valide (Min. 8 Character)");
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
          return ("Entrer un Mot de Passe Valide (Min. 6 Characteres)");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Typicons.key_outline),
        suffixIcon: GestureDetector(onTap: (){
          setState(() {
            _obscureText=!_obscureText;
          });
        },
        child :Icon(_obscureText ? Icons.visibility :Icons.visibility_off),
          ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Mot de passe ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordEditingController,
        obscureText: _obscureText1,
      validator: (value) {
        if (confirmpasswordEditingController.text != passwordEditingController.text) {
          return "Mot de passe invalide ";
        }
        else if(confirmpasswordEditingController.text.isEmpty)
          {
            return "Confirme Mot de passe est vide ";
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
        hintText: "Confirm Mot de passe",
          border:OutlineInputBorder(),
      ),
    );



    final signUpButton = MyButton(color: Colors.blue[300],

        title: 'Ajouter',
        onPressed: () async {
          if (_formKey.currentState!.validate())
          {
            //print('Votre form est valide');
            signUp(emailEditingController.text,passwordEditingController.text);
            // Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WelcomeScreen(MyIndex: 1,)));
            // await  Navigator.pushNamed(context, sear.screenRoute);
          }
        }

    );


    final signUpButton1 = Material(
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
             // Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                       WelcomeScreen(MyIndex: 1,)));
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


//groups

    final Roledropdown = DropdownButtonFormField(

        value: role_id,
        hint: const Text('sélectionner un Rôle'),
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
        labelText: 'Rôle ',
        prefixIcon: Icon(
        Icons.verified_user,
        ),
        border:OutlineInputBorder(),
      ),
        );


        final groupsropdown = DropdownButtonFormField(

      value: selectedGroupe,
      hint: const Text('sélectionner un groupe'),
      items: groups.map((e) {
        return DropdownMenuItem(child: Text(e),value:e,);
      }
      ).toList(),
          onChanged: (country) {
        if (country == 'Comptabilité') {
          Functions = CommercialeProvince;
        } else if (country == 'Développement') {
          Functions = DeveloppementProvince;
        } else if (country == 'Formation') {
          Functions = FormationProvince;
        }else if (country == 'FST-Logistique') {
          Functions = FSTLogistiqueProvince;
        }else if (country == 'GRH') {
          Functions = GRHProvince;
        }else if (country == 'IE') {
          Functions = IEProvince;
        }else if (country == 'Informatique') {
          Functions = InformatiqueProvince;
        }else if (country == 'Logistique Externe') {
          Functions = LogistiqueExterneProvince;
        }else if (country == 'Logistique Interne') {
          Functions = LogistiqueInterneProvince;
        }else if (country == 'PPS') {
          Functions = PPSProvince;
        }else if (country == 'Production') {
          Functions = ProductionProvince;
        }else if (country == 'PrûfTechnique') {
          Functions = PrufTechniqueProvince;
        }else if (country == 'Qualité') {
          Functions = QualiteProvince;
        }else if (country == 'Technique') {
          Functions = TechniqueProvince;
        }else if (country == 'FFC') {
          Functions = FFCProvince;
        }else if (country == 'Commerciale') {
          Functions = CommercialeProvince;
        }else if (country == 'Direction') {
          Functions = DirectionProvince;
        }
        else {
          Functions = [];
        }
        setState(() {
         selectedFunction = null;
          selectedGroupe = country!;
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.blueAccent,
      ),
      decoration: const InputDecoration(
        labelText: 'Groupe ',
        prefixIcon: Icon(
          Icons.groups,
        ),
        border:OutlineInputBorder(),
      ),
    );

    final functionsropdown = DropdownButtonFormField(

      value: selectedFunction,
      hint: const Text('sélectionner une function '),
      items: Functions?.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (province) {
        setState(() {
          selectedFunction = province!;
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.blueAccent,
      ),
      decoration: const InputDecoration(
        labelText: 'fonction ',
        prefixIcon: Icon(
          Icons.groups,
        ),
        border:OutlineInputBorder(),
      ),
    );



    final Etatuserdropdown = DropdownButtonFormField(

      value: useretat,
      hint: const Text('sélectionner un état'),
      items: useretatList.map((e) {
        return DropdownMenuItem(child: Text(e),value:e,);
      }
      ).toList(),
      onChanged: (val){
        setState(() {
          useretat = val as String;
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.blueAccent,
      ),
      decoration: const InputDecoration(
        labelText: 'Etat ',
        prefixIcon: Icon(
          Icons.person_pin_outlined,
        ),
        border:OutlineInputBorder(),
      ),
    );



    return Scaffold(
      backgroundColor: Colors.white,

      drawer: MainDrawer(),

      appBar:AppBar(
        backgroundColor: Colors.blue,
        title: Text('Ajouter utilisateur '),

        ),

      body: showwidget(myvisibility,firstNameField,NumtelField,emailField,groupsropdown,functionsropdown,Roledropdown,passwordField,confirmpasswordField,signUpButton,_formKey,Etatuserdropdown),


    );

  }
  String? mtoken = " ";



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
    // sedning these values to database

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.Fonction = selectedFunction;
    userModel.Groupe = selectedGroupe;
    userModel.NumTel = numtelEditingController.text;
    userModel.Role = role_id;
    userModel.etat =useretat;
    userModel.token=mtoken;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Utilisateur ajouté avec succes :) ");

  }
}

showwidget(bool myvisibility,Widget firstNameField,Widget NumtelField , Widget emailField ,Widget groupsropdown , Widget functionsropdown , Widget Roledropdown , Widget passwordField, Widget confirmpasswordField , Widget signUpButton , dynamic  _formKey,Widget Etatuserdropdown   ){

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
                Opacity(
                    opacity: 0.8,
                    child: Image.asset('images/add-user.png',width: 100,height: 100,)
                ),
                  SizedBox(height: 20),
                  firstNameField,
                  SizedBox(height: 20),
                  NumtelField,
                  SizedBox(height: 20),
                  emailField,
                  SizedBox(height: 20),
                  groupsropdown,
                  SizedBox(height: 20),
                  functionsropdown,
                  SizedBox(height: 20),
                  Roledropdown,
                  SizedBox(height: 20),
                  Etatuserdropdown,
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
      //Text("Vous etes pas autorisé de cette section")

      ]

    );

  } else {

    CircularProgressIndicator();
  }



}
