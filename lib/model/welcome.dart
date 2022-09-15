import 'dart:convert';

Items itemsFromJson(String str) => Items.fromJson(json.decode(str));

String itemsToJson(Items data) => json.encode(data.toJson());

class Items {
  Items({

    required this.id,
    required this.description,
    required this.destination,
    required this.Groupe,
    required this.Name,
    required this.Etat,
    required this.user

  });


  String id;
  String description;
  String destination;
  String Groupe;
  String Name;
  String Etat;
  String user;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    id: json["id"],
    description: json["description"],
    destination: json["destination"],
    Groupe: json["Groupe"],
    Name: json["Name"],
    Etat:json["Etat"],
    user:json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "destination": destination,
    "Groupe": Groupe,
    "Name": Name,
    "Etat":Etat,
     "user":user,

  };
}