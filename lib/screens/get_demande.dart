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
  List<Item> demandeItem = [];
  List<UsersModels> UserItem = [];
  final _auth = FirebaseAuth.instance;
  List<dynamic> RoleList = [
    {"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}
  ];

  @override
  void initState() {
    //fechRecrcords();
    //fechUsers();
    getsuggestionperuser(_auth.currentUser?.uid.toString());
    super.initState();
  }

  //
  /*fechRecrcords() async {
    //
    var records =  await FirebaseFirestore.instance.collection('basket_items').get();
   //.where("Approuved",isEqualTo:"false").get();
    mapRecords(records);
  }*/

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs
        .map((item) => Item(
              id: item.id,
              Description: item['Description'],
              DateProp: item['DateProp'],
              user: item['user'],
              Approuved: item['Approuved'],
              SituationAvant: item['SituationAvant'],
              SituationApres: item['SituationApres'],
              Remarque: item['Remarque'],
            ))
        .toList();
    if (this.mounted) {
      setState(() {
        demandeItem = _list;
      });
    }
  }

  Future getsuggestionperuser(dynamic username) async {
    List dataList = [];
    var records = await FirebaseFirestore.instance
        .collection('basket_items')
        .orderBy('DateProp', descending: true)
        .get();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: username)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  dataList.add(doc.data());
                }),
              });
      if (this.mounted) {
        setState(() {
          this.RoleList = dataList;
        });
      }

      if (this.RoleList[0]['Role'] == 'Admin') {
        // print('user connected is Admin');

        records = await FirebaseFirestore.instance
            .collection('basket_items')
            .orderBy('DateProp', descending: true)
            .get();
      } else {
        //print('User connected is user');
        records = await FirebaseFirestore.instance
            .collection('basket_items')
            .where("Approuved", isEqualTo: "true")
            .get();
      }
      return mapRecords(records);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            //Image.asset('images/image.jpg', height: 25),
            SizedBox(width: 45),
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
          itemCount: demandeItem.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(demandeItem[index].Description),
                subtitle: Text(demandeItem[index].Approuved),
                trailing: Text(demandeItem[index].DateProp),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailDemande(
                          IdDoc: demandeItem[index].id,
                          Iduser: demandeItem[index].user,
                          Description: demandeItem[index].Description,
                          Date: demandeItem[index].DateProp,
                          SituationAvant: demandeItem[index].SituationAvant,
                          SituationApres: demandeItem[index].SituationApres,
                          Remarque: demandeItem[index].Remarque,
                          Approuved: demandeItem[index].Approuved),
                    ),
                  );
                },
                leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                        demandeItem[index].Description[0] == ''
                            ? ''
                            : demandeItem[index].Description[0].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ))));
          }),
    );
  }
}
