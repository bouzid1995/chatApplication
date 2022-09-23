import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    required this.id,
    required this.Description,
    required this.SituationAvant,
    required this.SituationApres,
    required this.user,
    required this.DateProp,
    required this.Approuved,
    required this.Remarque,

  });

  String id;
  String Description;
  String SituationAvant;
  String SituationApres;
  String user;
  String DateProp;
  String Approuved;
  String Remarque;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json["id"],
      Description: json["Description"],
      SituationAvant: json["SituationAvant"],
      SituationApres : json["SituationApres"],
      user: json["user"],
      DateProp: json["DateProp"],
      Approuved: json["Approuved"],
      Remarque: json["Remarque"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Description": Description,
    "SituationAvant": SituationAvant,
    "SituationApres":SituationApres,
    "user":user,
     "DateProp":DateProp,
    "Approuved":Approuved,
    "Remarque":Remarque,

  };
}
