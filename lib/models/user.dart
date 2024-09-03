// User class to store user-related information
class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String image;
  final bool isLogged;
  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.password,
      required this.image,
      required this.isLogged});
}
