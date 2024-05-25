import 'package:cloud_firestore/cloud_firestore.dart';

///firebase base services
///
///this class is the base class for all services
///it contains the firebase instance and the database instance
class ServicesBase {
  final dbInstance = FirebaseFirestore.instance;

  // User DB
  final userDb = FirebaseFirestore.instance.collection("users");
  /// Hatim DB
  /// It will hold the hatim groups data in the database
  ///  each group will have a unique id
  ///  each gorup will have a list of 30 users
  ///  each user will have a list of 30 chapters
  ///  it will show if the person has read the chapter or not
  final groupsDb = FirebaseFirestore.instance.collection("groups");


}