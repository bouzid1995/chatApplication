class UserModel{

  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? Role;
  String? Groupe;
  String? Fonction;
  String? NumTel;
  String? etat;
  String? token;


  UserModel({this.uid,this.email,this.firstName,this.secondName,this.Role,this.Groupe,this.Fonction,this.NumTel,this.etat,this.token});


  factory UserModel.fromMap(map)
  {

    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      Role: map['Role'],
      Groupe: map['Group'],
      Fonction: map['Fonction'],
      NumTel: map['NumTel'],
      etat: map['etat'],
      token: map['token'],

    );
  }


  Map<String,dynamic> toMap(){
    return {
      'uid' : uid,
      'email':email,
      'firstName': firstName,
      'secondName':secondName,
      'Role':Role,
      'Groupe':Groupe,
      'Fonction':Fonction,
      'NumTel':NumTel,
      'etat':etat,
      'token':token,

    };
  }




}