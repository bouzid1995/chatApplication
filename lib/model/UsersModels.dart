
import 'dart:convert';

UsersModels itemFromJson(String str) => UsersModels.fromJson(json.decode(str));

String itemToJson(UsersModels data) => json.encode(data.toJson());

class UsersModels {
  UsersModels({

    required this.email,
    required this.uid,
    required this.firstName,
    required this.secondName,

  });


  String email;
  String uid;
  String firstName;
  String secondName;


  factory UsersModels.fromJson(Map<String, dynamic> json) => UsersModels(
    uid: json["uid"],
    email: json["email"],
    firstName: json["firstName"],
    secondName : json["secondName"],
  );

  Map<String, dynamic> toJson() => {

    "uid": uid,
    "email": email,
    "firstName": firstName,
    "secondName":secondName,
  };
}
