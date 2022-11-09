import 'package:chatapplication/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'main_drawer.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}


class _SearchUserState extends State<SearchUser> {

  String name = "";
  String myGroupe="";
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
            myGroupe = ds.data()!['Groupe'];
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        drawer:MainDrawer(),

        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Card(
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').orderBy('firstName').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                  as Map<String, dynamic>;

                  if (name.isEmpty   &&  data['Groupe']== myGroupe) {
                    return ListTile(
                      title: Text(
                        data['firstName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data['NumTel'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(icon:Icon(Icons.person), onPressed: () {},color:Colors.white,)),
                      trailing:Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                          IconButton(
                              onPressed: () async  {
                                // FlutterPhoneDirectCaller.callNumber(data['NumTel']);
                                final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: data['NumTel'].toString() );
                                if(await canLaunchUrlString(launchUri.toString())){
                                  await launchUrlString(launchUri.toString());
                                }
                                else {
                                  print('The action is not supported ');

                                }


                                //launchUrl('tel:',data['NumTel']);

                              },
                            icon:Icon(Icons.phone) ),

                          IconButton(
                              onPressed: () async  {
                               // FlutterPhoneDirectCaller.callNumber(data['NumTel']);
                                final Uri launchUri = Uri(
                                    scheme: 'sms',
                                    path: data['NumTel'].toString() );
                                if(await canLaunchUrlString(launchUri.toString())){
                                  await launchUrlString(launchUri.toString());
                                }
                                else {
                                  print('The action is not supported ');

                                }


                                //launchUrl('tel:',data['NumTel']);

                              },
                              icon:Icon(Icons.message_outlined) ),


                        ]


                      )

                    );
                  }
                  if (data['firstName'].toString().toLowerCase().startsWith(name.toLowerCase()) &&  data['Groupe']== myGroupe )
                  {
                    return ListTile(
                      title: Text(
                        data['firstName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data['NumTel'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                              data['firstName'][0] == ''
                                  ? ''
                                  : data['firstName'][0].toString().toLowerCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ))),
                        trailing:Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async  {
                                    // FlutterPhoneDirectCaller.callNumber(data['NumTel']);
                                    final Uri launchUri = Uri(
                                        scheme: 'sms',
                                        path: data['NumTel'].toString() );
                                    if(await canLaunchUrlString(launchUri.toString())){
                                      await launchUrlString(launchUri.toString());
                                    }
                                    else {
                                      print('The action is not supported ');

                                    }


                                    //launchUrl('tel:',data['NumTel']);

                                  },
                                  icon:Icon(Icons.phone) ),

                              IconButton(
                                  onPressed: () async  {
                                    // FlutterPhoneDirectCaller.callNumber(data['NumTel']);
                                    final Uri launchUri = Uri(
                                        scheme: 'msg',
                                        path: data['NumTel'].toString() );
                                    if(await canLaunchUrlString(launchUri.toString())){
                                      await launchUrlString(launchUri.toString());
                                    }
                                    else {
                                      print('The action is not supported ');

                                    }


                                    //launchUrl('tel:',data['NumTel']);

                                  },
                                  icon:Icon(Icons.message_outlined) ),


                            ]


                        ),
                    );
                  }
                  return Container(

                  );
                });
          },
        )
    );

  }
}