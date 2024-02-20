class User {
  final String uid;
  final String? email;
  final String? name; // <-- make this nullable
  final String? profilePhoto; // <-- make this nullable
  final String username;

  User({required this.uid, required this.email, required this.name, required this.profilePhoto, required this.username});

  get user => null;

  int? get state => null;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profilePhoto': profilePhoto,
      'username': username,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      profilePhoto: map['profilePhoto'],
      username: map['username'],
    );
  }
}