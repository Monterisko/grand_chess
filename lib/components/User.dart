class User {
  String id;
  String username;

  User({required this.id, required this.username});

  String getUserName() {
    return username;
  }
}
