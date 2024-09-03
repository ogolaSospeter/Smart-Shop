// User class to store user-related information
class User {
  int id;
  String username;
  String email;
  String password;
  String image; // Optional profile picture
  String phoneNumber; // Optional phone number
  String address; // Optional address
  bool isAdmin;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.phoneNumber,
    required this.address,
    this.isAdmin = false, // Default value for whether the user is an admin
  });
}
