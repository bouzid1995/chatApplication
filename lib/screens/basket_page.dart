// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/basket.dart';
import '../model/UsersModels.dart';


class BasketPage extends StatefulWidget {
  static const String screenRoute = 'Welcome_screen';

  const BasketPage({Key? key}) : super(key: key);

  @override
  State<BasketPage> createState() => _BasketPageState();
}


class _BasketPageState extends State<BasketPage> {
  List<Item> basketItem= [];

  @override
  void initState(){

    fechRecrcords();
    super.initState();
  }


  fechRecrcords() async {
    var records =  await FirebaseFirestore.instance.collection('basket_items').get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String,dynamic>> records){
    var _list =  records.docs.map
      ((item) => Item(
        id: item.id,
        Description:item['Description'],
        SituationApres: item['SituationApres'],
        SituationAvant: item['SituationAvant'],
        user: '',
        DateProp: item['DateProp'],
        Approuved: item['Approuved'],
        Remarque: item['Remarque'],
        )).toList();

    setState(() {
      basketItem = _list;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount:basketItem.length ,
          itemBuilder: (context,index){
            return ListTile(
              title: Text(basketItem[index].Description),
              subtitle: Text(basketItem[index].Approuved),
            );
          }




      ),
    );


  }



}
