import 'package:cloud_firestore/cloud_firestore.dart';

///firebase base services
///
///this class is the base class for all services
///it contains the firebase instance and the database instance
class ServicesBase {
  final dbInstance = FirebaseFirestore.instance;

  // User DB
  final userDb = FirebaseFirestore.instance.collection("users");
}
