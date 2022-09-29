
import 'package:chatapplication/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/basket.dart';
import '../model/UsersModels.dart';
import 'Details.dart';


class GetDemande extends StatefulWidget {

  static const String screenRoute = 'Demande_screen';

  const GetDemande({Key? key}) : super(key: key);

  @override
  State<GetDemande> createState() => _GetDemandeState();
}


class _GetDemandeState extends State<GetDemande> {
  List<Item> demandeItem= [];
  List<UsersModels> UserItem=[];
  final _auth = FirebaseAuth.instance;


  @override
  void initState(){
    fechRecrcords();
    //fechUsers();
    super.initState();
  }

     //
  fechRecrcords() async {
    var records =  await FirebaseFirestore.instance.collection('basket_items').get();
   //.where("Approuved",isEqualTo:"true").get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String,dynamic>> records){
    var _list =  records.docs.map
      ((item) => Item(
        id: item.id,
      Description: item['Description'], DateProp:item['DateProp'], user: item['user'], Approuved: item['Approuved'], SituationAvant: item['SituationAvant'], SituationApres: item['SituationApres'], Remarque: item['Remarque'] ,
    )).toList();

    setState(() {
      demandeItem = _list;
    });

  }


 /* fechUsers() async {
    var user =  await FirebaseFirestore.instance.collection('users').
    where("Approuved",isEqualTo:"true").get();

    mapRecords(user);
  }


  mapUsers(QuerySnapshot<Map<String,dynamic>> user){
    var Mylist =  user.docs.map
      ((items) => UsersModels (
    email: items['email'], firstName:items['firstName'], secondName:items['secondName'], uid: items['uid'],
    )).toList();

    setState(() {
      UserItem = Mylist;
      print('tsting return her');
      print(UserItem);
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          automaticallyImplyLeading: false,

          title: Row(
            children: const [
              //Image.asset('images/image.jpg', height: 25),
              SizedBox(width:45),
              Text('List des Suggestion')
            ],
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
      body: ListView.builder(
          itemCount:demandeItem.length ,
          itemBuilder: (context,index){
            return ListTile(
              title: Text(demandeItem[index].Description),
             subtitle: Text(demandeItem[index].Approuved),
                trailing: Text(demandeItem[index].DateProp),
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => DetailDemande(Iduser:demandeItem[index].user,Description:demandeItem[index].Description,Date:demandeItem[index].DateProp,SituationAvant:demandeItem[index].SituationAvant,SituationApres:demandeItem[index].SituationApres,Remarque:demandeItem[index].Remarque,Approuved:demandeItem[index].Approuved),
                  ),
                  );
                },
            leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(demandeItem[index].Description[0] =='' ? '' : demandeItem[index].Description[0].toString()  ,
            style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            ))
            ));
          }




      ),
    );


  }



}
