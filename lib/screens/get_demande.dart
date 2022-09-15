
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/basket.dart';
import '../model/welcome.dart';


class GetDemande extends StatefulWidget {

  static const String screenRoute = 'Demande_screen';

  const GetDemande({Key? key}) : super(key: key);

  @override
  State<GetDemande> createState() => _GetDemandeState();
}


class _GetDemandeState extends State<GetDemande> {
  List<Item> demandeItem= [];



  @override
  void initState(){

    print('testtttt');
    fechRecrcords();
    print('testtttt');
    super.initState();
  }


  fechRecrcords() async {
    var records =  await FirebaseFirestore.instance.collection('basket_items').get();
    //where("user",isEqualTo:FirebaseAuth.instance.currentUser!.uid ).
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String,dynamic>> records){
    var _list =  records.docs.map
      ((item) => Item(
        id: item.id,
      name: item['name'], groupe: item['groupe'], description:item['description'], titre: item['titre'], user: item['user'], Etat: item['Etat'] ,
    )).toList();

    setState(() {
      demandeItem = _list;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Row(
            children: const [
              //Image.asset('images/image.jpg', height: 25),
              SizedBox(width: 20),
              Text('Liste des demandes  ')
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                //  _auth.signOut();
                //  Navigator.pushNamed(context, SignInScreen.screenRoute);
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
              title: Text(demandeItem[index].titre),
              subtitle: Text(demandeItem[index].description),
            leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(demandeItem[index].titre[0] =='' ? '' : demandeItem[index].name[0].toString()  ,
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
