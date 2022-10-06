import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  Group({
    required this.id,
    required this.Description,
    required this.Name,
    required this.UserID,


  });

  String id;
  String Description;
  String Name;
  List UserID;


  factory Group.fromJson(Map<String, dynamic> json) => Group(
      id: json["id"],
      Description: json["Description"],
      Name: json["Name"],
      UserID: json["UserID"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Description": Description,
    "Name": Name,
    "UserID":UserID,

  };
}
