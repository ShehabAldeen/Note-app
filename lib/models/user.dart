import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static String collectionName = 'users';
  String id = '';

  String firstName = '';

  String lastName = '';

  String userName = '';

  String email = '';

  String password = '';

  User(
      {this.id,
      this.userName,
      this.password,
      this.email,
      this.firstName,
      this.lastName});

  User.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as String,
            firstName: json['firstName'] as String,
            lastName: json['lastName'] as String,
            userName: json['userName'] as String,
            password: json['password'] as String,
            email: json['email'] as String);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'password': password,
      'email': email
    };
  }

  static CollectionReference<User> withConverter() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<User>(
          fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()),
          toFirestore: (User, _) => User.toJson(),
        );
  }
}
