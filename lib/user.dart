class User{
  final String Nom;
  final  String Email;
  final String mdp;


  User({
    required this.Nom,
    required this.Email,
    required this.mdp,
  });

  static User fromJson(Map<String,dynamic> json){
    
    User user = User(
    Nom:json['idcours'],
    Email:json['idjour'],
    mdp:json['idclasse'],

    );
    return user;
  }
  
}