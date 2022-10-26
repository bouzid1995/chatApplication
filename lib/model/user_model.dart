class UserModel{

  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? Role;
  String? Group;
  String? Fonction;
  String? NumTel;
  String? matricule;


  UserModel({this.uid,this.email,this.firstName,this.secondName,this.Role,this.Group,this.Fonction,this.NumTel,this.matricule});


  factory UserModel.fromMap(map)
  {

    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      Role: map['Role'],
      Group: map['Group'],
      Fonction: map['Fonction'],
      NumTel: map['NumTel'],
      matricule: map['matricule'],

    );
  }


  Map<String,dynamic> toMap(){
    return {
      'uid' : uid,
      'email':email,
      'firstName': firstName,
      'secondName':secondName,
      'Role':Role,
      'Group':Group,
      'Fonction':Fonction,
      'NumTel':NumTel,
      'matricule':matricule,

    };
  }




}