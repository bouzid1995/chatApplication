import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    required this.id,
    required this.name,
    required this.groupe,
    required this.description,
    required this.titre,
    required this.user,
    required this.Etat,
  });

  String id;
  String name;
  String groupe;
  String description;
  String titre;
  String user;
  String Etat;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json["id"],
      name: json["name"],
      groupe: json["quantity"],
      description : json["description"],
      titre: json["titre"],
      user: json["user"],
      Etat: json["Etat"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity": groupe,
    "description":description,
    "titre":titre,
    "user":user,
    "Etat":Etat
  };
}
