class Categorie{
  String thumbnail;
  String name;
  int moofCourses;

  Categorie({
    required this.name,
    required this.moofCourses,
    required this.thumbnail
  });
}

List<Categorie> categoryList = [
  Categorie(
    name: 'Admin', 
    moofCourses: 55, 
    thumbnail:'assets/images/gestion_vote.jpeg'
  ),
  Categorie(
    name: 'Candidater', 
    moofCourses: 20, 
    thumbnail:'assets/images/afficher_vote.jpeg'
  ),
  Categorie(
    name: "Resultats", 
    moofCourses: 16, 
    thumbnail:'assets/images/candidater.jpeg'
  ),
  Categorie(
    name: 'Voter', 
    moofCourses: 55, 
    thumbnail:'assets/images/voter.jpeg'
  )  
];